module.exports = { 
  apps:[{
    name: "proxy",
    script: "./index.js",
    cwd: "/app/proxy"
  },{
    name: "frontend",
    script: "./server.js",
    cwd: "/app/frontend"
  },{
    name: "backend",
    script: "npm",
    cwd: "/app/backend",
    args: "run start"
  }]
};