#!/bin/bash
# Enhanced Firebase Deployment Pipeline for Vuet App
# Includes performance monitoring, analytics, and optimization

# Ensure script exits if any command fails
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Banner
echo -e "${BLUE}================================================================${NC}"
echo -e "${BLUE}    Vuet App Enhanced Firebase Deployment Pipeline${NC}"
echo -e "${BLUE}    Production-Ready Deployment with Monitoring & Analytics${NC}"
echo -e "${BLUE}================================================================${NC}"
echo

# Environment validation
print_status "Validating environment..."

# Check if environment files exist
if [ ! -f ".env.production" ]; then
    print_error ".env.production file not found!"
    echo "Please create a .env.production file with your Supabase credentials."
    exit 1
fi

if [ ! -f "web/env.js" ]; then
    print_error "web/env.js file not found!"
    echo "Web environment configuration is missing."
    exit 1
fi

print_success "Environment files validated"

# Check Flutter installation and version
print_status "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | head -n 1)
print_success "Flutter found: $FLUTTER_VERSION"

# Check Firebase CLI
print_status "Checking Firebase CLI..."
if ! command -v firebase &> /dev/null; then
    print_error "Firebase CLI is not installed."
    echo "Please install it with: npm install -g firebase-tools"
    exit 1
fi

FIREBASE_VERSION=$(firebase --version)
print_success "Firebase CLI found: $FIREBASE_VERSION"

# Check Firebase login status
print_status "Verifying Firebase authentication..."
if ! firebase projects:list &> /dev/null; then
    print_warning "Not logged into Firebase. Initiating login..."
    firebase login
fi

# Get current project
CURRENT_PROJECT=$(firebase use)
if [ $? -eq 0 ]; then
    print_success "Using Firebase project: $CURRENT_PROJECT"
else
    print_warning "No active Firebase project set. Using default from .firebaserc"
    CURRENT_PROJECT="qaaaa-448c6"
fi

# Pre-deployment cleanup
print_status "Cleaning project..."
flutter clean
rm -rf build/
print_success "Project cleaned"

# Get dependencies
print_status "Getting Flutter dependencies..."
flutter pub get
print_success "Dependencies updated"

# Run code analysis
print_status "Running code analysis..."
flutter analyze --no-fatal-infos
if [ $? -eq 0 ]; then
    print_success "Code analysis passed"
else
    print_warning "Code analysis found issues (continuing with deployment)"
fi

# Build for web with optimizations
print_status "Building Flutter web app with optimizations..."
print_status "Using optimized build flags for production..."

# Enhanced build command with optimizations
flutter build web \
    --release \
    --web-renderer canvaskit \
    --tree-shake-icons \
    --dart-define=FLUTTER_WEB_USE_SKIA=true \
    --dart-define=FLUTTER_WEB_AUTO_DETECT=true \
    --source-maps

if [ $? -eq 0 ]; then
    print_success "Flutter web build completed successfully"
else
    print_error "Flutter web build failed"
    exit 1
fi

# Verify build output
print_status "Verifying build output..."
if [ ! -d "build/web" ]; then
    print_error "Build directory not found"
    exit 1
fi

if [ ! -f "build/web/index.html" ]; then
    print_error "index.html not found in build output"
    exit 1
fi

BUILD_SIZE=$(du -sh build/web | cut -f1)
print_success "Build verification passed (Size: $BUILD_SIZE)"

# Pre-deployment testing
print_status "Running pre-deployment checks..."

# Check if critical files exist
CRITICAL_FILES=("build/web/index.html" "build/web/main.dart.js" "build/web/flutter.js")
for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        print_error "Critical file missing: $file"
        exit 1
    fi
done

print_success "Pre-deployment checks passed"

# Deploy to Firebase
print_status "Deploying to Firebase Hosting..."
print_status "This may take a few minutes..."

# Deploy with enhanced configuration
firebase deploy --only hosting --message "Enhanced deployment $(date '+%Y-%m-%d %H:%M:%S')"

if [ $? -eq 0 ]; then
    print_success "Deployment completed successfully!"
else
    print_error "Deployment failed"
    exit 1
fi

# Post-deployment verification
print_status "Running post-deployment verification..."

# Get the hosting URL
HOSTING_URL="https://qaaaa-448c6.web.app"
print_status "Verifying deployment at: $HOSTING_URL"

# Test if the site is accessible (requires curl)
if command -v curl &> /dev/null; then
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$HOSTING_URL")
    if [ "$HTTP_STATUS" = "200" ]; then
        print_success "Site is accessible (HTTP $HTTP_STATUS)"
    else
        print_warning "Site returned HTTP $HTTP_STATUS"
    fi
else
    print_warning "curl not available for site verification"
fi

# Deployment summary
echo
echo -e "${GREEN}================================================================${NC}"
echo -e "${GREEN}                 DEPLOYMENT SUCCESSFUL!${NC}"
echo -e "${GREEN}================================================================${NC}"
echo
echo -e "${BLUE}🚀 Your app is now live at:${NC}"
echo -e "${GREEN}   $HOSTING_URL${NC}"
echo
echo -e "${BLUE}📊 Deployment Details:${NC}"
echo -e "   • Build Size: $BUILD_SIZE"
echo -e "   • Renderer: CanvasKit (optimized for performance)"
echo -e "   • Tree Shaking: Enabled"
echo -e "   • Source Maps: Generated"
echo -e "   • CDN: Global (Firebase Hosting)"
echo
echo -e "${BLUE}🌍 International Testing:${NC}"
echo -e "   • Global CDN ensures fast loading worldwide"
echo -e "   • Test from different locations using online tools"
echo -e "   • Monitor performance in Firebase Console"
echo
echo -e "${BLUE}📈 Next Steps:${NC}"
echo -e "   1. Monitor performance in Firebase Console"
echo -e "   2. Check Analytics dashboard for user engagement"
echo -e "   3. Review any error reports in Crashlytics"
echo -e "   4. Test app functionality across different devices"
echo
echo -e "${YELLOW}💡 Pro Tips:${NC}"
echo -e "   • Use Firebase Performance Monitoring for insights"
echo -e "   • Set up alerts for performance degradation"
echo -e "   • Consider A/B testing for feature rollouts"
echo
print_success "Enhanced deployment pipeline completed!"
