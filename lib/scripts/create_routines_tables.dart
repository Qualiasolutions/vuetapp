import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

Future<void> main() async {
  final logger = Logger();
  // Initialize Supabase client
  // await Supabase.initialize(
  //   url: 'https://xrloafqzfdzewdoawysh.supabase.co',
  //   anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhybG9hZnF6ZmR6ZXdkb2F3eXNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0MjY5NDEsImV4cCI6MjA2MzAwMjk0MX0.czspEL9cWQKNnNaNrjObokPO20Lty9okrvnrBD93u0M',
  // );

  final supabase = Supabase.instance.client;

  final List<String> routineCommands = [
    // Routines Table Structure
    '''
    CREATE TABLE IF NOT EXISTS routines (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        schedule_type TEXT NOT NULL CHECK (schedule_type IN ('daily', 'weekly', 'monthlyDate', 'monthlyDay')),
        interval INTEGER DEFAULT 1 NOT NULL,
        days_of_week INTEGER[],
        day_of_month INTEGER,
        week_of_month INTEGER,
        start_date DATE NOT NULL,
        end_date DATE,
        time_of_day TIME,
        created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
        updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
    )
    ''',
    // Comments for Routines Table
    "COMMENT ON COLUMN routines.days_of_week IS '0=Sunday, 1=Monday, ..., 6=Saturday. Null if not applicable for schedule_type.'",
    "COMMENT ON COLUMN routines.day_of_month IS '1-31. Null if not applicable for schedule_type.'",
    "COMMENT ON COLUMN routines.week_of_month IS '1-4 for 1st-4th week, 5 or -1 for the last week of the month. Null if not applicable for schedule_type.'",
    "COMMENT ON COLUMN routines.schedule_type IS 'Type of schedule: daily, weekly, monthlyDate (e.g., on the 15th), monthlyDay (e.g., on the first Monday).'",
    "COMMENT ON COLUMN routines.time_of_day IS 'Store as HH:mm'",
    // RLS for Routines Table
    "ALTER TABLE routines ENABLE ROW LEVEL SECURITY",
    'DROP POLICY IF EXISTS "Users can view their own routines" ON routines',
    'DROP POLICY IF EXISTS "Users can insert their own routines" ON routines',
    'DROP POLICY IF EXISTS "Users can update their own routines" ON routines',
    'DROP POLICY IF EXISTS "Users can delete their own routines" ON routines',
    '''
    CREATE POLICY "Users can view their own routines"
    ON routines FOR SELECT
    USING (auth.uid() = user_id)
    ''',
    'COMMENT ON POLICY "Users can view their own routines" ON routines IS \'Users can view their own routines.\'',
    '''
    CREATE POLICY "Users can insert their own routines"
    ON routines FOR INSERT
    WITH CHECK (auth.uid() = user_id)
    ''',
    'COMMENT ON POLICY "Users can insert their own routines" ON routines IS \'Users can insert their own routines.\'',
    '''
    CREATE POLICY "Users can update their own routines"
    ON routines FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id)
    ''',
    'COMMENT ON POLICY "Users can update their own routines" ON routines IS \'Users can update their own routines.\'',
    '''
    CREATE POLICY "Users can delete their own routines"
    ON routines FOR DELETE
    USING (auth.uid() = user_id)
    ''',
    'COMMENT ON POLICY "Users can delete their own routines" ON routines IS \'Users can delete their own routines.\'',
    // Index for Routines Table
    "CREATE INDEX IF NOT EXISTS idx_routines_user_id ON routines(user_id)"
  ];

  final List<String> routineTaskTemplateCommands = [
    // Routine Task Templates Table Structure
    '''
    CREATE TABLE IF NOT EXISTS routine_task_templates (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        routine_id UUID REFERENCES routines(id) ON DELETE CASCADE NOT NULL,
        user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        estimated_duration_minutes INTEGER,
        category_id UUID,
        priority TEXT CHECK (priority IN ('low', 'medium', 'high')),
        order_in_routine INTEGER DEFAULT 0 NOT NULL,
        created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
        updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
    )
    ''',
    // Comments for Routine Task Templates Table
    "COMMENT ON COLUMN routine_task_templates.priority IS 'Task priority: low, medium, high. Null if not set.'",
    "COMMENT ON COLUMN routine_task_templates.category_id IS 'Foreign key to a task_categories table if it exists.'",
    // RLS for Routine Task Templates Table
    "ALTER TABLE routine_task_templates ENABLE ROW LEVEL SECURITY",
    'DROP POLICY IF EXISTS "Users can view templates for their routines" ON routine_task_templates',
    'DROP POLICY IF EXISTS "Users can insert templates for their routines" ON routine_task_templates',
    'DROP POLICY IF EXISTS "Users can update templates for their routines" ON routine_task_templates',
    'DROP POLICY IF EXISTS "Users can delete templates for their routines" ON routine_task_templates',
    '''
    CREATE POLICY "Users can view templates for their routines"
    ON routine_task_templates FOR SELECT
    USING (auth.uid() = user_id)
    ''',
    'COMMENT ON POLICY "Users can view templates for their routines" ON routine_task_templates IS \'Users can view templates for their routines.\'',
    '''
    CREATE POLICY "Users can insert templates for their routines"
    ON routine_task_templates FOR INSERT
    WITH CHECK (auth.uid() = user_id)
    ''',
    'COMMENT ON POLICY "Users can insert templates for their routines" ON routine_task_templates IS \'Users can insert templates for their routines.\'',
    '''
    CREATE POLICY "Users can update templates for their routines"
    ON routine_task_templates FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id)
    ''',
    'COMMENT ON POLICY "Users can update templates for their routines" ON routine_task_templates IS \'Users can update templates for their routines.\'',
    '''
    CREATE POLICY "Users can delete templates for their routines"
    ON routine_task_templates FOR DELETE
    USING (auth.uid() = user_id)
    ''',
    'COMMENT ON POLICY "Users can delete templates for their routines" ON routine_task_templates IS \'Users can delete templates for their routines.\'',
    // Indexes for Routine Task Templates Table
    "CREATE INDEX IF NOT EXISTS idx_routine_task_templates_routine_id ON routine_task_templates(routine_id)",
    "CREATE INDEX IF NOT EXISTS idx_routine_task_templates_user_id ON routine_task_templates(user_id)"
  ];

  // Helper to execute a list of SQL commands
  Future<void> executeCommandList(List<String> commands, String tableNameForLogging) async {
    logger.i('Configuring table: $tableNameForLogging');
    for (final command in commands) {
      // Log a snippet of the command to avoid overly long console lines
      final commandSnippet = command.replaceAll('\n', ' '); // Ensure command is on a single line for logging.
      final logMessage = "Executing: ${commandSnippet.substring(0, commandSnippet.length > 70 ? 70 : commandSnippet.length)}...";
      logger.i(logMessage);
      try {
        await supabase.rpc('execute_sql', params: {'sql': command});
        logger.i('  Successfully executed.');
      } catch (e) {
        logger.e('  Error executing command for $tableNameForLogging:');
        logger.e('    Command: $commandSnippet');
        logger.e('    Error: $e');
        // Decide if you want to stop on error or continue
        // For now, it will continue with the next command
      }
    }
    logger.i('$tableNameForLogging configuration finished.');
  }

  // Execute commands for both tables
  await executeCommandList(routineCommands, 'routines');
  await executeCommandList(routineTaskTemplateCommands, 'routine_task_templates');

  logger.i('All database schema setup finished.');
}
