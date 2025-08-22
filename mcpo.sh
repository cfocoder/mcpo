#!/bin/bash

# MCPO Management Script
# Usage: ./mcpo.sh [start|stop|restart|logs|status|update|backup|restore]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_requirements() {
    log_info "Checking requirements..."
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! docker compose version &> /dev/null; then
        log_error "Docker Compose is not available. Please install Docker Compose first."
        exit 1
    fi
    
    if [ ! -f ".env" ]; then
        log_error ".env file not found. Please create one based on .env.example"
        exit 1
    fi
    
    # Check if API key is set
    if grep -q "your-secure-api-key-here" .env; then
        log_warning "Please update the MCPO_API_KEY in .env file before starting"
    fi
    
    log_success "Requirements check passed"
}

start_services() {
    log_info "Starting MCPO services..."
    check_requirements
    
    # Create data directory if it doesn't exist
    mkdir -p data
    
    # Build and start services
    docker compose up -d --build
    
    if [ $? -eq 0 ]; then
        log_success "MCPO services started successfully"
        log_info "MCPO is available at: https://mcpo.cfocoder.com"
        log_info "API documentation: https://mcpo.cfocoder.com/docs"
        log_info "Direct access: http://localhost:8001"
        log_info "Use 'docker compose logs -f' to view logs"
        log_info ""
        log_info "🔄 Remember to reload your system Caddy: sudo systemctl reload caddy"
    else
        log_error "Failed to start MCPO services"
        exit 1
    fi
}

stop_services() {
    log_info "Stopping MCPO services..."
    docker compose down
    log_success "MCPO services stopped"
}

restart_services() {
    log_info "Restarting MCPO services..."
    stop_services
    start_services
}

show_logs() {
    log_info "Showing MCPO logs (Ctrl+C to exit)..."
    docker compose logs -f
}

show_status() {
    log_info "MCPO Services Status:"
    docker compose ps
    
    echo ""
    log_info "Container Resource Usage:"
    docker stats --no-stream $(docker compose ps -q) 2>/dev/null || true
    
    echo ""
    log_info "Health Checks:"
    if curl -sf http://localhost:8000/health > /dev/null 2>&1; then
        log_success "MCPO health check: PASSED"
    else
        log_error "MCPO health check: FAILED"
    fi
}

update_services() {
    log_info "Updating MCPO..."
    
    # Backup current config
    backup_config
    
    # Pull latest changes
    git pull origin main
    
    # Rebuild and restart services
    docker compose down
    docker compose pull
    docker compose up -d --build
    
    log_success "MCPO updated successfully"
}

backup_config() {
    BACKUP_DIR="backups"
    BACKUP_FILE="$BACKUP_DIR/mcpo-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    
    log_info "Creating backup..."
    mkdir -p "$BACKUP_DIR"
    
    tar -czf "$BACKUP_FILE" \
        config.json \
        .env \
        docker-compose.yml \
        Caddyfile \
        data/ 2>/dev/null || true
    
    log_success "Backup created: $BACKUP_FILE"
}

restore_config() {
    if [ -z "$1" ]; then
        log_error "Usage: $0 restore <backup-file>"
        exit 1
    fi
    
    BACKUP_FILE="$1"
    
    if [ ! -f "$BACKUP_FILE" ]; then
        log_error "Backup file not found: $BACKUP_FILE"
        exit 1
    fi
    
    log_info "Restoring from backup: $BACKUP_FILE"
    
    # Stop services
    stop_services
    
    # Restore files
    tar -xzf "$BACKUP_FILE"
    
    # Start services
    start_services
    
    log_success "Backup restored successfully"
}

install_mcpo() {
    log_info "Installing MCPO..."
    
    # Install dependencies
    sudo apt-get update
    sudo apt-get install -y curl git
    
    # Install Docker if not present
    if ! command -v docker &> /dev/null; then
        log_info "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
        log_success "Docker installed. Please log out and back in for group changes to take effect."
    fi
    
    # Install Docker Compose if not present
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        log_info "Installing Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        log_success "Docker Compose installed"
    fi
    
    log_success "MCPO installation completed"
    log_info "Please edit the .env file with your API keys and configuration"
    log_info "Then run: $0 start"
}

# Main script logic
case "${1:-}" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    logs)
        show_logs
        ;;
    status)
        show_status
        ;;
    update)
        update_services
        ;;
    backup)
        backup_config
        ;;
    restore)
        restore_config "$2"
        ;;
    install)
        install_mcpo
        ;;
    *)
        echo "MCPO Management Script"
        echo ""
        echo "Usage: $0 {start|stop|restart|logs|status|update|backup|restore|install}"
        echo ""
        echo "Commands:"
        echo "  start     - Start MCPO services"
        echo "  stop      - Stop MCPO services"
        echo "  restart   - Restart MCPO services"
        echo "  logs      - Show service logs"
        echo "  status    - Show service status and health"
        echo "  update    - Update MCPO to latest version"
        echo "  backup    - Create configuration backup"
        echo "  restore   - Restore from backup file"
        echo "  install   - Install Docker and dependencies"
        echo ""
        echo "Examples:"
        echo "  $0 start"
        echo "  $0 logs"
        echo "  $0 restore backups/mcpo-backup-20250101-120000.tar.gz"
        exit 1
        ;;
esac