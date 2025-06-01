#!/bin/bash

# Flutter Chrome Launcher
# This script provides options for running Flutter apps on Chrome
# across different environments (Linux/Windows)

# Text colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Working directory - the project root
PROJECT_DIR="/home/user/vv"
cd "$PROJECT_DIR" || exit 1

# Detect if CHROME_EXECUTABLE is already set
check_chrome_executable() {
  if [ -z "$CHROME_EXECUTABLE" ]; then
    echo -e "${YELLOW}CHROME_EXECUTABLE is not set.${NC}"
    return 1
  else
    echo -e "${GREEN}CHROME_EXECUTABLE is set to:${NC} $CHROME_EXECUTABLE"
    
    # Check if the file exists and is accessible (only for local paths)
    if [[ "$CHROME_EXECUTABLE" == /* ]] && [ ! -f "$CHROME_EXECUTABLE" ]; then
      echo -e "${RED}Warning: The Chrome executable file was not found at this path.${NC}"
      echo "This might be expected if it's a Windows path or network path."
    fi
    
    return 0
  fi
}

# Launch Flutter with Chrome once CHROME_EXECUTABLE is set
launch_flutter_chrome() {
  if check_chrome_executable; then
    echo -e "${BLUE}Launching Flutter app with Chrome...${NC}"
    flutter run -d chrome
  else
    echo -e "${RED}Cannot launch: CHROME_EXECUTABLE is not set.${NC}"
    echo "Please set it first using option 2 or 3."
  fi
}

# Run the web server approach
run_web_server() {
  echo -e "${BLUE}Running Flutter web server...${NC}"
  echo "This will make your app accessible from any browser on your network."
  
  # Get IP address
  IP_ADDRESSES=$(hostname -I)
  PRIMARY_IP=$(echo "$IP_ADDRESSES" | awk '{print $1}')
  
  if [ -n "$PRIMARY_IP" ]; then
    echo -e "${GREEN}Your app will be available at:${NC} http://$PRIMARY_IP:8080"
  else
    echo -e "${YELLOW}Could not detect IP address. Run ./scripts/get_ip_address.sh for more info.${NC}"
  fi
  
  echo -e "${BLUE}Starting server...${NC}"
  ./scripts/run_web_server.sh
}

# Set Chrome executable path interactively
set_chrome_path_interactive() {
  echo -e "${BLUE}Set Chrome Executable Path${NC}"
  echo -e "${YELLOW}Common locations for Chrome on Windows:${NC}"
  echo "1) C:/Program Files/Google/Chrome/Application/chrome.exe"
  echo "2) C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"
  echo "3) /mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
  echo "4) Custom path"
  
  read -rp "Choose an option (1-4): " choice
  
  case $choice in
    1) CHROME_PATH="C:/Program Files/Google/Chrome/Application/chrome.exe" ;;
    2) CHROME_PATH="C:/Program Files (x86)/Google/Chrome/Application/chrome.exe" ;;
    3) CHROME_PATH="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" ;;
    4)
      read -rp "Enter custom Chrome path: " CHROME_PATH
      ;;
    *)
      echo -e "${RED}Invalid option.${NC}"
      return 1
      ;;
  esac
  
  export CHROME_EXECUTABLE="$CHROME_PATH"
  echo -e "${GREEN}CHROME_EXECUTABLE has been set to:${NC} $CHROME_EXECUTABLE"
  
  # Ask if user wants to save this to their script
  read -rp "Save this path to scripts/set_chrome_path.sh? (y/n): " save_choice
  if [[ $save_choice == "y" || $save_choice == "Y" ]]; then
    sed -i "s|CHROME_PATH=.*|CHROME_PATH=\"$CHROME_PATH\"|" "$PROJECT_DIR/scripts/set_chrome_path.sh"
    echo -e "${GREEN}Path saved to scripts/set_chrome_path.sh${NC}"
  fi
  
  return 0
}

# Source the existing set_chrome_path.sh script
source_chrome_path_script() {
  if [ -f "$PROJECT_DIR/scripts/set_chrome_path.sh" ]; then
    source "$PROJECT_DIR/scripts/set_chrome_path.sh"
    echo -e "${GREEN}Chrome path sourced from script.${NC}"
    check_chrome_executable
  else
    echo -e "${RED}Error: scripts/set_chrome_path.sh not found.${NC}"
  fi
}

# Show help about the different approaches
show_help() {
  cat "$PROJECT_DIR/README_CHROME_SETUP.md"
  
  echo ""
  echo -e "${BLUE}Press Enter to return to the menu...${NC}"
  read -r
}

# Check Flutter web server capabilities
check_web_capabilities() {
  echo -e "${BLUE}Checking Flutter web capabilities...${NC}"
  
  # Check if Flutter is installed
  if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Flutter not found. Please install Flutter first.${NC}"
    return 1
  fi
  
  # Check Flutter version
  FLUTTER_VERSION=$(flutter --version | head -n 1)
  echo -e "${GREEN}Flutter version:${NC} $FLUTTER_VERSION"
  
  # Check web support
  echo -e "${BLUE}Checking web support...${NC}"
  flutter devices | grep -E "web|chrome|Chrome"
  
  # Get IP info
  echo ""
  echo -e "${BLUE}Network information:${NC}"
  "$PROJECT_DIR/scripts/get_ip_address.sh"
  
  echo ""
  echo -e "${BLUE}Press Enter to return to the menu...${NC}"
  read -r
}

# Main menu
main_menu() {
  clear
  echo -e "${BLUE}====== Flutter Chrome Launcher ======${NC}"
  echo ""
  echo "1) Run Flutter app in web server mode (Recommended)"
  echo "2) Set Chrome executable path interactively"
  echo "3) Use Chrome path from scripts/set_chrome_path.sh"
  echo "4) Launch Flutter app with Chrome (requires CHROME_EXECUTABLE to be set)"
  echo "5) Check current setup"
  echo "6) Show help"
  echo "7) Exit"
  echo ""
  check_chrome_executable
  echo ""
  read -rp "Enter your choice (1-7): " choice
  
  case $choice in
    1) run_web_server ;;
    2) set_chrome_path_interactive && main_menu ;;
    3) source_chrome_path_script && main_menu ;;
    4) launch_flutter_chrome ;;
    5) check_web_capabilities && main_menu ;;
    6) show_help && main_menu ;;
    7) echo "Exiting."; exit 0 ;;
    *) echo -e "${RED}Invalid option.${NC}"; sleep 1; main_menu ;;
  esac
}

# Execute main menu
main_menu
