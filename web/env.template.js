// This file configures the environment variables for the Flutter web app.
// Copy this file to env.js and fill in your actual values
// It will be loaded by index.html

console.log('🚀 Executing env.js...');

window.flutterWebEnvironment = {
  // Environment detection - Set to "development" for dev builds, "production" for prod
  FLUTTER_ENV: "development", // Should be "production" for production builds
  
  // Supabase Configuration
  SUPABASE_URL: "your_supabase_url_here",
  SUPABASE_ANON_KEY: "your_supabase_anon_key_here",
  
  // OpenAI Configuration for LANA AI Assistant
  OPENAI_API_KEY: "your_openai_api_key_here",
  OPENAI_ASSISTANT_ID: "your_openai_assistant_id_here",
  
  // reCAPTCHA Configuration
  RECAPTCHA_SITE_KEY: "your_recaptcha_site_key_here",
  RECAPTCHA_SECRET_KEY: "your_recaptcha_secret_key_here"
};

console.log('✅ window.flutterWebEnvironment assigned in env.js.');
console.log('   FLUTTER_ENV set to:', window.flutterWebEnvironment.FLUTTER_ENV);
console.log('   SUPABASE_URL set to:', window.flutterWebEnvironment.SUPABASE_URL ? window.flutterWebEnvironment.SUPABASE_URL.substring(0, 40) + '...' : 'NOT SET');
console.log('   SUPABASE_ANON_KEY set to:', window.flutterWebEnvironment.SUPABASE_ANON_KEY ? window.flutterWebEnvironment.SUPABASE_ANON_KEY.substring(0, 20) + '...' : 'NOT SET');

// Old debug logging for environment detection (can be redundant now but kept for consistency with original)
console.log('🌐 Web Environment Loaded (old log):', window.flutterWebEnvironment.FLUTTER_ENV);
console.log('🔑 Supabase URL Available (old log):', !!window.flutterWebEnvironment.SUPABASE_URL);
console.log('🔐 Supabase Key Available (old log):', !!window.flutterWebEnvironment.SUPABASE_ANON_KEY);
console.log('📍 Full Supabase URL (old log):', window.flutterWebEnvironment.SUPABASE_URL);
console.log('🔑 Anon Key Preview (old log):', window.flutterWebEnvironment.SUPABASE_ANON_KEY ? window.flutterWebEnvironment.SUPABASE_ANON_KEY.substring(0, 20) + '...' : 'NOT FOUND'); 