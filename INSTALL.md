# 🚀 MCPO Installation Guide

## 📋 Quick Installation

### 1. **Clone or Download**
```bash
# If you have these files, you're ready to go!
cd /your/installation/directory
```

### 2. **Configure Environment**
```bash
# Copy and edit environment file
cp .env.example .env
# Edit with your API keys:
nano .env
```

### 3. **Configure MCP Servers**
```bash
# Copy and edit configuration
cp config.example.json config.json
# Or use the working example:
cp config.working-example.json config.json
# Edit as needed:
nano config.json
```

### 4. **Run MCPO**
```bash
# Make script executable
chmod +x mcpo.sh

# Start MCPO
./mcpo.sh start

# Check status
./mcpo.sh status

# View logs
./mcpo.sh logs

# Stop MCPO
./mcpo.sh stop
```

## 🔧 Management Commands

```bash
./mcpo.sh start          # Start MCPO
./mcpo.sh stop           # Stop MCPO
./mcpo.sh restart        # Restart MCPO
./mcpo.sh status         # Check status
./mcpo.sh logs           # View logs
./mcpo.sh logs -f        # Follow logs
```

## 🌐 Access MCPO

- **Local Docs**: http://localhost:8001/docs
- **Health Check**: http://localhost:8001/health

## 📝 Configuration Files

- **`.env`** - Environment variables (API keys)
- **`config.json`** - MCP servers configuration
- **`docker-compose.yml`** - Docker setup
- **`config.working-example.json`** - Example working configuration

## 🔐 Required API Keys

Add these to your `.env` file:

```bash
EXA_API_KEY=your_exa_api_key_here
PERPLEXITY_API_KEY=your_perplexity_api_key_here
```

## 🎯 Integration

### Open WebUI Integration
Use these OpenAPI endpoints:
```
http://localhost:8001/exa/openapi.json
http://localhost:8001/perplexity/openapi.json
http://localhost:8001/memory/openapi.json
```

### Tailscale Integration
For secure remote access, configure Tailscale serve:
```bash
sudo tailscale serve --https=8443 --set-path=/mcpo http://localhost:8001
```

Then access via: `https://your-tailscale-hostname:8443/mcpo/`

## ✅ Verification

1. Check if MCPO is running: `./mcpo.sh status`
2. Visit: http://localhost:8001/docs
3. Test API: `curl http://localhost:8001/health`

## 🆘 Troubleshooting

- **Container not starting**: Check `./mcpo.sh logs`
- **API errors**: Verify API keys in `.env`
- **Port conflicts**: MCPO uses port 8001
- **Permission issues**: Ensure `mcpo.sh` is executable

For more help, check the logs: `./mcpo.sh logs`
