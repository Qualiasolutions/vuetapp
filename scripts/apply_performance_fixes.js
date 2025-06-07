// Script to apply performance fix migration to Supabase
const { exec } = require('child_process');
const path = require('path');

console.log('Applying Supabase performance fix migration...');

// Get the directory of the migration file
const migrationPath = path.resolve(__dirname, '../supabase/migrations/20250701000000_fix_performance_warnings.sql');

// Command to apply the migration using Supabase CLI
const command = `supabase migration up --file ${migrationPath}`;

// Execute the command
exec(command, (error, stdout, stderr) => {
  if (error) {
    console.error(`Error applying migration: ${error.message}`);
    return;
  }
  
  if (stderr) {
    console.error(`Migration stderr: ${stderr}`);
    return;
  }
  
  console.log(`Migration applied successfully: ${stdout}`);
  console.log('Database performance fixes have been applied.');
}); 