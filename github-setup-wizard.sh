#!/bin/bash
# GitHub Setup Wizard - SSH & Go Private Configuration

# Colors and styling
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Fancy spinner animation
fancy_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Function to draw fancy ASCII art logo
draw_logo() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ╔═════════════════════════════════════════════════════════════╗
    ║   ███████╗██╗      █████╗ ██████╗     ██╗███╗   ██╗ ██████╗ ║
    ║   ██╔════╝██║     ██╔══██╗██╔══██╗    ██║████╗  ██║██╔════╝ ║
    ║   ███████╗██║     ███████║██████╔╝    ██║██╔██╗ ██║██║      ║
    ║   ╚════██║██║     ██╔══██║██╔═══╝     ██║██║╚██╗██║██║      ║
    ║   ███████║███████╗██║  ██║██║         ██║██║ ╚████║╚██████╗ ║
    ║   ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝         ╚═╝╚═╝  ╚═══╝ ╚═════╝ ║
    ║                                                             ║
    ║                  🚀 GitHub Setup Wizard 🔒                  ║
    ║           Developed by Slap Inc. v1.0                       ║
    ╚═════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Function to show fancy section header
show_header() {
    local title="$1"
    local title_length=${#title}
    local padding=$(( (50 - title_length) / 2 ))
    echo
    echo -e "${PURPLE}╭$([[ $title_length -lt 48 ]] && printf '═%.0s' {1..48})╮${NC}"
    echo -e "${PURPLE}│${NC}${BOLD}$(printf '%*s' $padding)$title$(printf '%*s' $padding)${NC}${PURPLE}│${NC}"
    echo -e "${PURPLE}╰$([[ $title_length -lt 48 ]] && printf '═%.0s' {1..48})╯${NC}"
    echo
}

# Function for fancy status messages
show_status() {
    local message="$1"
    local type="$2"
    case $type in
        "success")
            echo -e "${GREEN}✨ $message ✨${NC}"
            ;;
        "error")
            echo -e "${RED}❌ $message ❌${NC}"
            ;;
        "info")
            echo -e "${CYAN}ℹ️  $message${NC}"
            ;;
        "warning")
            echo -e "${YELLOW}⚠️  $message${NC}"
            ;;
    esac
}

# Fancy pause function
pause() {
    echo
    echo -e "${YELLOW}┌────────────────────────────────────────┐${NC}"
    read -p "$(echo -e ${YELLOW}│    Press Enter to continue...           │${NC})"
    echo -e "${YELLOW}└────────────────────────────────────────┘${NC}"
}

# Function to check command status with fancy output
check_status() {
    if [ $? -eq 0 ]; then
        show_status "$1" "success"
        pause
    else
        show_status "$1" "error"
        echo -e "${YELLOW}Would you like to retry? (y/n)${NC}"
        read answer
        if [ "$answer" = "y" ]; then
            return 1
        else
            show_status "Script aborted by user" "error"
            exit 1
        fi
    fi
    return 0
}

# Detect OS with fancy output
detect_os() {
    case "$(uname -s)" in
        MINGW*|CYGWIN*) 
            OS="Windows"
            OS_ICON="🪟"
            SSH_DIR="$USERPROFILE/.ssh"
            ;;
        Darwin*)
            OS="Mac"
            OS_ICON="🍎"
            SSH_DIR="$HOME/.ssh"
            ;;
        *)
            OS="Unix"
            OS_ICON="🐧"
            SSH_DIR="$HOME/.ssh"
            ;;
    esac
}

# Function to setup SSH
setup_ssh() {
    show_header "SSH Setup Wizard"
    
    # Create .ssh directory if it doesn't exist
    show_header "Initialize SSH Directory"
    if [ ! -d "$SSH_DIR" ]; then
        show_status "Creating SSH directory..." "info"
        mkdir -p "$SSH_DIR"
        chmod 700 "$SSH_DIR"
        check_status "Created .ssh directory" || exit 1
    else
        show_status ".ssh directory already exists" "success"
        pause
    fi

    # Get email with fancy prompt
    show_header "GitHub Email Configuration"
    while true; do
        echo -e "${CYAN}📧 Please enter your GitHub email:${NC}"
        read EMAIL
        echo -e "\n${YELLOW}You entered: ${BOLD}$EMAIL${NC}"
        read -p "$(echo -e ${YELLOW}Is this correct? [y/n]: ${NC})" confirm
        if [ "$confirm" = "y" ]; then
            break
        fi
    done

    # Generate SSH key with fancy output
    show_header "Generating SSH Key 🔑"
    while true; do
        show_status "Creating new SSH key pair..." "info"
        ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_DIR/id_ed25519"
        if check_status "SSH key generation"; then
            break
        fi
    done

    # Start SSH agent and add key with OS-specific handling
    show_header "SSH Agent Configuration"
    case "$OS" in
        Windows)
            show_status "Starting SSH agent service..." "info"
            powershell.exe -Command "Get-Service -Name ssh-agent | Set-Service -StartupType Automatic"
            powershell.exe -Command "Start-Service ssh-agent"
            check_status "SSH agent startup"
            
            show_status "Adding SSH key to agent..." "info"
            ssh-add "$SSH_DIR/id_ed25519"
            check_status "Key addition to SSH agent"
            
            show_status "Copying public key to clipboard..." "info"
            cat "$SSH_DIR/id_ed25519.pub" | clip
            ;;
        Mac)
            show_status "Starting SSH agent..." "info"
            eval "$(ssh-agent -s)"
            check_status "SSH agent startup"
            
            show_status "Adding SSH key to agent..." "info"
            ssh-add "$SSH_DIR/id_ed25519"
            check_status "Key addition to SSH agent"
            
            show_status "Copying public key to clipboard..." "info"
            pbcopy < "$SSH_DIR/id_ed25519.pub"
            ;;
        Unix)
            show_status "Starting SSH agent..." "info"
            eval "$(ssh-agent -s)"
            check_status "SSH agent startup"
            
            show_status "Adding SSH key to agent..." "info"
            ssh-add "$SSH_DIR/id_ed25519"
            check_status "Key addition to SSH agent"
            
            show_status "Attempting to copy public key..." "info"
            if command -v xclip > /dev/null; then
                xclip -selection clipboard < "$SSH_DIR/id_ed25519.pub"
            elif command -v xsel > /dev/null; then
                xsel -b < "$SSH_DIR/id_ed25519.pub"
            else
                show_status "Clipboard utilities not found. Your public key is:" "warning"
                cat "$SSH_DIR/id_ed25519.pub"
                show_status "Please copy it manually" "warning"
            fi
            ;;
    esac

    # Create SSH config
    show_header "SSH Configuration"
    show_status "Creating SSH config file..." "info"
    cat > "$SSH_DIR/config" << EOL
Host github.com
    IdentityFile ~/.ssh/id_ed25519
    UseKeychain yes
    AddKeysToAgent yes
EOL

    chmod 600 "$SSH_DIR/config"
    check_status "SSH config creation"

    # GitHub instructions
    show_header "GitHub Setup Instructions"
    echo -e "${CYAN}Please follow these steps to add your key to GitHub:${NC}"
    echo
    echo -e "${GREEN}1.${NC} 🌐 Open ${BOLD}https://github.com/settings/ssh/new${NC}"
    echo -e "${GREEN}2.${NC} 📝 Give your key a memorable title"
    echo -e "${GREEN}3.${NC} 📋 Paste the key from your clipboard"
    echo -e "${GREEN}4.${NC} 💾 Click ${BOLD}\"Add SSH key\"${NC}"
    pause

    # Test connection
    show_header "Connection Test"
    while true; do
        show_status "Ready to test connection to GitHub?" "info"
        read -p "$(echo -e ${YELLOW}Press y when ready: ${NC})" ready
        if [ "$ready" = "y" ]; then
            show_status "Testing connection..." "info"
            ssh -T git@github.com
            if check_status "GitHub connection test"; then
                break
            fi
        fi
    done

    show_status "SSH Setup Complete!" "success"
}

# Function to setup Go private modules
setup_go_private() {
    show_header "Go Private Modules Setup"
    
    # Show authentication options
    echo -e "${CYAN}Choose authentication method for private Go modules:${NC}"
    echo -e "${GREEN}1.${NC} 🔑 SSH (Recommended if you've already set up SSH)"
    echo -e "${GREEN}2.${NC} 🎫 Personal Access Token"
    echo -e "${GREEN}3.${NC} 📟 GitHub CLI (if you have 'gh' installed)"
    echo
    read -p "$(echo -e ${YELLOW}Enter your choice [1-3]: ${NC})" auth_choice

    case $auth_choice in
        1)  # SSH Authentication
            if [ ! -f "$SSH_DIR/id_ed25519" ]; then
                show_status "SSH key not found. Please set up SSH first." "error"
                return 1
            fi
            
            show_status "Configuring git to use SSH for GitHub..." "info"
            git config --global url."git@github.com:".insteadOf "https://github.com/"
            ;;
            
        2)  # Personal Access Token
            while true; do
                echo -e "${CYAN}🔑 Please enter your GitHub Personal Access Token (with repo scope):${NC}"
                echo -e "${YELLOW}(Create one at https://github.com/settings/tokens if you haven't already)${NC}"
                echo -e "${YELLOW}It should look like: ghp_xxxxxxxxxxxxxxxxxxxxxx${NC}"
                read -s GITHUB_TOKEN
                echo
                
                if [ -z "$GITHUB_TOKEN" ]; then
                    show_status "Token cannot be empty" "error"
                    continue
                fi
                
                if [[ ! $GITHUB_TOKEN =~ ^ghp_ ]]; then
                    show_status "Invalid token format. Token should start with 'ghp_'" "error"
                    continue
                fi
                
                echo -e "\n${YELLOW}Would you like to test the token? [y/n]: ${NC}"
                read test_token
                
                if [ "$test_token" = "y" ]; then
                    show_status "Testing GitHub token..." "info"
                    if curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user > /dev/null; then
                        show_status "Token validation successful!" "success"
                        break
                    else
                        show_status "Invalid token. Please try again." "error"
                        continue
                    fi
                else
                    break
                fi
            done
            
            show_status "Configuring git for private Go modules..." "info"
            git config --global url."https://$GITHUB_TOKEN:x-oauth-basic@github.com/".insteadOf "https://github.com/"
            ;;
            
        3)  # GitHub CLI
            if ! command -v gh &> /dev/null; then
                show_status "GitHub CLI (gh) not found. Please install it first." "error"
                echo -e "${YELLOW}Visit: https://cli.github.com/ for installation instructions${NC}"
                return 1
            fi
            
            show_status "Checking GitHub CLI authentication..." "info"
            if ! gh auth status &> /dev/null; then
                show_status "Please authenticate with GitHub CLI first" "info"
                gh auth login
            fi
            
            show_status "Configuring git to use GitHub CLI credentials..." "info"
            git config --global credential.helper store
            ;;
            
        *)
            show_status "Invalid choice" "error"
            return 1
            ;;
    esac
    
    # Configure GOPRIVATE
    show_status "Setting up GOPRIVATE environment variable..." "info"
    echo -e "${CYAN}Enter your organization/user names for private repos (comma-separated):${NC}"
    echo -e "${YELLOW}Example: github.com/myorg,github.com/myorg-2${NC}"
    read GOPRIVATE_VALUE
    
    # Add GOPRIVATE to appropriate shell config file
    SHELL_CONFIG=""
    case "$SHELL" in
        */bash)
            SHELL_CONFIG="$HOME/.bashrc"
            ;;
        */zsh)
            SHELL_CONFIG="$HOME/.zshrc"
            ;;
        *)
            SHELL_CONFIG="$HOME/.profile"
            ;;
    esac
    
    # Check if GOPRIVATE already exists in config
    if grep -q "export GOPRIVATE=" "$SHELL_CONFIG"; then
        show_status "Updating existing GOPRIVATE configuration..." "info"
        sed -i.bak "s|export GOPRIVATE=.*|export GOPRIVATE=$GOPRIVATE_VALUE|" "$SHELL_CONFIG"
    else
        show_status "Adding GOPRIVATE to shell configuration..." "info"
        echo "export GOPRIVATE=$GOPRIVATE_VALUE" >> "$SHELL_CONFIG"
    fi
    
    # Export for current session
    export GOPRIVATE="$GOPRIVATE_VALUE"
    
    show_status "Go private modules configuration complete!" "success"
    echo -e "${CYAN}Note: You may need to run 'source $SHELL_CONFIG' or restart your terminal${NC}"
    
    # Test the setup
    echo -e "\n${YELLOW}Would you like to test the private module access? [y/n]: ${NC}"
    read test_setup
    if [ "$test_setup" = "y" ]; then
        echo -e "${CYAN}Enter a private module path to test (e.g., github.com/myorg/myrepo):${NC}"
        read test_module
        go mod download $test_module@latest
        check_status "Private module access test"
    fi
    
    pause
}

# Main menu function
show_menu() {
    while true; do
        draw_logo
        show_header "Main Menu"
        echo -e "${CYAN}Please select an option:${NC}"
        echo
        echo -e "${GREEN}1.${NC} 🔑 Setup SSH for GitHub"
        echo -e "${GREEN}2.${NC} 📦 Configure Go Private Modules"
        echo -e "${GREEN}3.${NC} 🚪 Exit"
        echo
        read -p "$(echo -e ${YELLOW}Enter your choice [1-3]: ${NC})" choice
        
        case $choice in
            1)
                detect_os
                setup_ssh
                ;;
            2)
                setup_go_private
                ;;
            3)
                show_status "Thank you for using GitHub Setup Wizard!" "success"
                exit 0
                ;;
            *)
                show_status "Invalid option. Please try again." "error"
                ;;
        esac
        
        read -p "$(echo -e ${YELLOW}Return to main menu? [y/n]: ${NC})" return_menu
        [ "$return_menu" != "y" ] && break
    done
}

# Start the script
show_menu

exit 0