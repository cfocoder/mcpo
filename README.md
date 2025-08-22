# MCPO Self-Hosted Setup

This repository contains a complete Docker Compose setup for running MCPO (MCP-to-OpenAPI proxy) with enhanced deployment configurations, management scripts, and self-hosting capabilities.

## 📖 Detailed Installation Guide

For a comprehensive installation guide with real-world examples and troubleshooting tips, check out our detailed blog post:

**[🚀 Installing and Configuring MCPO for Open WebUI: A Complete Guide](https://cfocoder.com/%f0%9f%9a%80-installing-and-configuring-mcpo-for-open-webui-a-complete-guide/)**

This guide includes step-by-step instructions, management scripts usage, and Open WebUI integration examples.

## 🙏 Credits

This repository is based on the excellent work by the [Open WebUI team](https://github.com/open-webui) and their original [MCPO project](https://github.com/open-webui/mcpo). We've added Docker Compose setup, management scripts, and deployment configurations to make self-hosting easier.

**Original Project:** [open-webui/mcpo](https://github.com/open-webui/mcpo)  
**License:** MIT License  
**Special Thanks:** To the Open WebUI community for creating this amazing MCP-to-OpenAPI bridge.

## Overview

MCPO exposes any MCP (Model Context Protocol) tool as an OpenAPI-compatible HTTP server, making it easy to integrate MCP servers with various applications and services.

## 🚀 Our Enhancements

This repository adds the following improvements to the original MCPO:

- **🐳 Docker Compose Setup** - Complete containerized deployment
- **📝 Management Script (`mcpo.sh`)** - Easy start/stop/status/logs management
- **📋 Configuration Examples** - Working example configurations with placeholders
- **🔧 Self-Hosting Ready** - Production-ready deployment configurations
- **📖 Enhanced Documentation** - Comprehensive installation and troubleshooting guides
- **🔄 Backup & Restore** - Configuration backup utilities

## 🎮 Management Script Usage

The included `mcpo.sh` script makes MCPO management incredibly easy:

```bash
# Start MCPO services
./mcpo.sh start

# Check running status  
./mcpo.sh status

# View logs
./mcpo.sh logs

# Follow logs in real-time
./mcpo.sh logs -f

# Stop services
./mcpo.sh stop

# Restart services
./mcpo.sh restart
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Basic Linux command line knowledge
- API keys for the services you want to use

### Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/cfocoder/mcpo.git
   cd mcpo
   ```

2. **Configure environment:**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

3. **Configure MCP servers:**
   ```bash
   cp config.example.json config.json
   # Or use the working example:
   cp config.working-example.json config.json
   ```

4. **Start MCPO:**
   ```bash
   chmod +x mcpo.sh
   ./mcpo.sh start
   ```

5. **Verify installation:**
   - Visit: http://localhost:8001/docs
   - Check status: `./mcpo.sh status`

## 🔗 Open WebUI Integration

Once MCPO is running, integrate it with Open WebUI using these OpenAPI endpoints:

```
http://localhost:8001/exa/openapi.json
http://localhost:8001/perplexity/openapi.json
http://localhost:8001/memory/openapi.json
```

Add these URLs in Open WebUI Settings → Tools → Manage Tool Servers.

## 📁 Repository Structure

```
mcpo/
├── src/mcpo/                      # Core MCPO source code (from original project)
├── docker-compose.yml             # Docker orchestration
├── mcpo.sh                        # Management script
├── config.example.json            # Configuration template
├── config.working-example.json    # Working configuration example
├── .env.example                   # Environment variables template
├── .env.working-example           # Working environment example
├── INSTALL.md                     # Detailed installation guide
├── BLOG_POST.md                   # Complete blog post tutorial
└── README.md                      # This file
```

## 🛠️ Development

For development and testing:

```bash
# View logs during development
./mcpo.sh logs -f

# Restart after configuration changes
./mcpo.sh restart

# Check container status
./mcpo.sh status
```

## 🆘 Troubleshooting

- **Container won't start**: Check `./mcpo.sh logs`
- **API errors**: Verify API keys in `.env`
- **Port conflicts**: MCPO uses port 8001
- **Permission issues**: Ensure `mcpo.sh` is executable

For detailed troubleshooting, see our [blog post](https://cfocoder.com/%f0%9f%9a%80-installing-and-configuring-mcpo-for-open-webui-a-complete-guide/).

## �� License

MIT License - Same as the original MCPO project.

## 🤝 Contributing

This repository focuses on deployment and self-hosting enhancements. For core MCPO functionality contributions, please contribute to the [original project](https://github.com/open-webui/mcpo).

For deployment-related improvements to this repository:
- Fork this repo
- Create a feature branch
- Submit a pull request

---

**Note:** This is a deployment-focused fork of the original MCPO project. All core functionality and credit belongs to the [Open WebUI team](https://github.com/open-webui/mcpo).
