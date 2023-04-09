import http from "http"
import httpProxy from "http-proxy"
import HttpProxyRules from "http-proxy-rules"

// Set up proxy rules instance
const proxyRules = new HttpProxyRules({
  rules: {
    '/api': 'http://localhost:4000/api', // Rule (1)
  },
  default: 'http://localhost:3000' // default target
});

const proxy = httpProxy.createProxyServer({
  ws: true,
  xfwd: true,
  headers: {
    "Host": "infisical.corp.vase.ai",
    "X-NginX-Proxy": "true"
  },
  cookiePathRewrite: {
    "/": "/; secure; HttpOnly; SameSite=strict"
  }
})
http.createServer((req, res) => {
  const target = proxyRules.match(req)
  if (target) return proxy.web(req, res, { target })
}).listen(8080)