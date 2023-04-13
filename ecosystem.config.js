module.exports = { 
  apps:[{
    name: "frontend",
    script: "./server.js",
    cwd: "/app/frontend",
    env: {
      "PORT": 3000
    }
  },{
    name: "backend",
    script: "npm",
    cwd: "/app/backend",
    args: "run start",
    env: {
      "PORT": 4000
    }
  }]
};