// web/env.js
// Environment configuration for Vuet App web builds
// This file is loaded in index.html before Flutter initialization

// Environment detection
(function(window) {
  // Check if we're running in production mode
  // This can be set by the build process or detected from the URL
  const isProduction = () => {
    // Check for production flag from Flutter build
    if (window.flutterConfiguration && window.flutterConfiguration.FLUTTER_ENV === 'production') {
      console.log('🚀 Running in PRODUCTION mode (via Flutter configuration)');
      return true;
    }
    
    // Check for production domain
    const productionDomains = ['vuet.ai', 'vuettttt.web.app', 'vuettttt.firebaseapp.com'];
    const isProductionDomain = productionDomains.some(domain => window.location.hostname.includes(domain));
    
    if (isProductionDomain) {
      console.log('🚀 Running in PRODUCTION mode (via domain detection)');
      return true;
    }
    
    // Default to development for local testing
    console.log('🔧 Running in DEVELOPMENT mode');
    return false;
  };

  // Environment variables
  const ENV = {
    // Development environment
    development: {
      SUPABASE_URL: 'https://tkmvvaapumqkbbtokxjv.supabase.co',
      SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRrbXZ2YWFwdW1xa2JidG9reGp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTExNTQ2NTAsImV4cCI6MjA2NjczMDY1MH0.7GBgJlQbjKpInd7jSXZihhvSdGmu2gVM1jRKHYKsqPI',
      SUPABASE_SERVICE_ROLE_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxc2JvYW1oZm13ZXplZnRpZnprIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MDM2NTA3OCwiZXhwIjoyMDY1OTQxMDc4fQ.VBPakQ5zrXiuDrJa-aOjn_ShFMv1s7LbPj77yYIlqGw',
      SUPABASE_PROJECT_ID: 'tkmvvaapumqkbbtokxjv',
      FLUTTER_ENV: 'development',
      API_BASE_URL: 'https://api-dev.vuet.ai/v1',
      ENABLE_ANALYTICS: false,
      ENABLE_CRASH_REPORTING: false,
      ENABLE_PERFORMANCE_MONITORING: false
    },
    
    // Production environment
    production: {
      SUPABASE_URL: 'https://xrloafqzfdzewdoawysh.supabase.co',
      SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhybG9hZnF6ZmR6ZXdkb2F3eXNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0MjY5NDEsImV4cCI6MjA2MzAwMjk0MX0.czspEL9cWQKNnNaNrjObokPO20Lty9okrvnrBD93u0M',
      SUPABASE_SERVICE_ROLE_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhybG9hZnF6ZmR6ZXdkb2F3eXNoIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzQyNjk0MSwiZXhwIjoyMDYzMDAyOTQxfQ.GY5yA1pdXw-f2xDpdPdMrNm5ubpOAVguGRkIBBkMjhc',
      SUPABASE_PROJECT_ID: 'xrloafqzfdzewdoawysh',
      FLUTTER_ENV: 'production',
      API_BASE_URL: 'https://api.vuet.ai/v1',
      WEBHOOK_URL: 'https://hooks.vuet.ai/events',
      EXTERNAL_CALENDAR_API: 'https://calendar-sync.vuet.ai/v1',
      ENABLE_FAMILY_SHARING: true,
      ENABLE_CALENDAR_SYNC: true,
      ENABLE_AI_ASSISTANT: true,
      ENABLE_EXTERNAL_CALENDAR: true,
      ENABLE_PUSH_NOTIFICATIONS: true,
      ENABLE_DEEP_LINKING: true,
      ENABLE_ANALYTICS: true,
      ENABLE_CRASH_REPORTING: true,
      ENABLE_PREMIUM_FEATURES: true
    }
  };

  // Select the environment based on detection
  const currentEnv = isProduction() ? ENV.production : ENV.development;
  
  // Make environment variables available globally
  window.ENV = currentEnv;
  
  // Log environment status (for debugging)
  console.log(`🔄 Environment loaded: ${currentEnv.FLUTTER_ENV}`);
  console.log(`🔌 Supabase Project: ${currentEnv.SUPABASE_PROJECT_ID}`);
  
  // Expose a method to check if we're in production
  window.isProduction = isProduction;
  
  // Create Flutter configuration object if it doesn't exist
  window.flutterConfiguration = window.flutterConfiguration || {};
  
  // Copy environment variables to Flutter configuration
  Object.keys(currentEnv).forEach(key => {
    window.flutterConfiguration[key] = currentEnv[key];
  });
  
})(window);
