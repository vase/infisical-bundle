module.exports = { 
  apps:[{
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