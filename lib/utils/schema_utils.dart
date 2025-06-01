import 'package:vuet_app/mcp_tools/supabase_mcp_tool.dart';
import 'package:vuet_app/utils/logger.dart';

// Utility functions for schema modifications and backend tasks via MCP.
// These should be used with caution and typically run once.
class SchemaUtils {
  static final SupabaseMcpTool _mcpTool = SupabaseMcpTool();
  
  // Main method to perform all Phase 1 backend fixes
  static Future<bool> performPhase1BackendFixes() async {
    log('[SchemaUtils] Starting Phase 1 backend fixes...', name: 'SchemaUtils');
    
    // Test connection first
    final isConnected = await _mcpTool.testConnection();
    if (!isConnected) {
      log('[SchemaUtils] Failed to connect to Supabase via MCP', name: 'SchemaUtils', level: LogLevel.error);
      return false;
    }
    
    bool allSuccess = true;
    
    // 1. Add is_professional column
    final columnSuccess = await addIsProfessionalColumn();
    allSuccess = allSuccess && columnSuccess;
    
    // 2. Analyze RLS policies (diagnostic step)
    await analyzeRlsPolicies();
    
    // 3. Check table structures
    await checkTableStructures();
    
    log('[SchemaUtils] Phase 1 backend fixes completed. Overall success: $allSuccess', name: 'SchemaUtils');
    return allSuccess;
  }
  
  // Add is_professional column to entity_categories
  static Future<bool> addIsProfessionalColumn() async {
    log('[SchemaUtils] Adding is_professional column...', name: 'SchemaUtils');
    
    try {
      final success = await _mcpTool.addIsProfessionalColumn();
      
      if (success) {
        log('[SchemaUtils] ✅ Successfully added is_professional column', name: 'SchemaUtils');
        
        // Verify the column was added
        final tableStructure = await _mcpTool.describeTable(tableName: 'entity_categories');
        final hasProfessionalColumn = tableStructure.any((column) => 
          column['column_name'] == 'is_professional'
        );
        
        if (hasProfessionalColumn) {
          log('[SchemaUtils] ✅ Verified: is_professional column exists', name: 'SchemaUtils');
          return true;
        } else {
          log('[SchemaUtils] ❌ Column addition may have failed - not found in table structure', name: 'SchemaUtils', level: LogLevel.error);
          return false;
        }
      } else {
        log('[SchemaUtils] ❌ Failed to add is_professional column', name: 'SchemaUtils', level: LogLevel.error);
        return false;
      }
    } catch (e, stackTrace) {
      log('[SchemaUtils] Error adding is_professional column: $e', name: 'SchemaUtils', error: e, stackTrace: stackTrace, level: LogLevel.error);
      return false;
    }
  }
  
  // Analyze RLS policies to identify issues
  static Future<void> analyzeRlsPolicies() async {
    log('[SchemaUtils] Analyzing RLS policies...', name: 'SchemaUtils');
    
    final tables = ['tasks', 'entity_categories', 'entities'];
    
    for (final tableName in tables) {
      try {
        log('[SchemaUtils] Checking RLS policies for: $tableName', name: 'SchemaUtils');
        
        final policies = await _mcpTool.listRlsPolicies(tableName: tableName);
        
        if (policies.isEmpty) {
          log('[SchemaUtils] ⚠️  No RLS policies found for $tableName', name: 'SchemaUtils', level: LogLevel.warning);
        } else {
          log('[SchemaUtils] Found ${policies.length} RLS policies for $tableName:', name: 'SchemaUtils');
          
          for (final policy in policies) {
            final policyName = policy['policyname'] ?? 'Unknown';
            final cmd = policy['cmd'] ?? 'Unknown';
            final qual = policy['qual']?.toString() ?? 'No condition';
            
            log('[SchemaUtils]   - Policy: $policyName (Command: $cmd)', name: 'SchemaUtils');
            log('[SchemaUtils]     Condition: $qual', name: 'SchemaUtils');
            
            // Check for potential recursive patterns
            if (qual.contains('tasks') && tableName == 'tasks') {
              log('[SchemaUtils] ⚠️  Potential recursive reference in tasks RLS policy: $policyName', name: 'SchemaUtils', level: LogLevel.warning);
            }
          }
        }
      } catch (e) {
        log('[SchemaUtils] Error analyzing RLS for $tableName: $e', name: 'SchemaUtils', level: LogLevel.error);
      }
    }
  }
  
  // Check table structures
  static Future<void> checkTableStructures() async {
    log('[SchemaUtils] Checking table structures...', name: 'SchemaUtils');
    
    final tables = ['entity_categories', 'entities', 'tasks'];
    
    for (final tableName in tables) {
      try {
        log('[SchemaUtils] Checking structure of: $tableName', name: 'SchemaUtils');
        
        final structure = await _mcpTool.describeTable(tableName: tableName);
        
        if (structure.isEmpty) {
          log('[SchemaUtils] ❌ Table $tableName not found or inaccessible', name: 'SchemaUtils', level: LogLevel.error);
        } else {
          log('[SchemaUtils] ✅ Table $tableName has ${structure.length} columns:', name: 'SchemaUtils');
          
          for (final column in structure) {
            final columnName = column['column_name'];
            final dataType = column['data_type'];
            final isNullable = column['is_nullable'];
            final defaultValue = column['column_default'] ?? 'None';
            
            log('[SchemaUtils]   - $columnName ($dataType, nullable: $isNullable, default: $defaultValue)', name: 'SchemaUtils');
          }
        }
      } catch (e) {
        log('[SchemaUtils] Error checking structure of $tableName: $e', name: 'SchemaUtils', level: LogLevel.error);
      }
    }
  }
  
  // Method to test basic queries on key tables
  static Future<void> testBasicQueries() async {
    log('[SchemaUtils] Testing basic queries...', name: 'SchemaUtils');
    
    final testQueries = [
      {
        'name': 'Count entity_categories',
        'query': 'SELECT COUNT(*) as count FROM public.entity_categories;'
      },
      {
        'name': 'Count entities', 
        'query': 'SELECT COUNT(*) as count FROM public.entities;'
      },
      {
        'name': 'Count tasks',
        'query': 'SELECT COUNT(*) as count FROM public.tasks;'
      },
      {
        'name': 'Test entity_categories with is_professional',
        'query': 'SELECT id, name, is_professional FROM public.entity_categories LIMIT 5;'
      }
    ];
    
    for (final test in testQueries) {
      try {
        log('[SchemaUtils] Testing: ${test['name']}', name: 'SchemaUtils');
        
        final result = await _mcpTool.executeSql(query: test['query']!);
        
        if (result.isNotEmpty) {
          log('[SchemaUtils] ✅ ${test['name']}: Success (${result.length} rows)', name: 'SchemaUtils');
          
          // Log first result for context
          if (result.isNotEmpty) {
            log('[SchemaUtils]   Sample result: ${result.first}', name: 'SchemaUtils');
          }
        } else {
          log('[SchemaUtils] ⚠️  ${test['name']}: No results returned', name: 'SchemaUtils', level: LogLevel.warning);
        }
      } catch (e) {
        log('[SchemaUtils] ❌ ${test['name']}: Failed - $e', name: 'SchemaUtils', level: LogLevel.error);
      }
    }
  }
  
  // Method to create a simple RLS policy fix for tasks (if needed)
  static Future<bool> createSimpleTasksRlsPolicy() async {
    log('[SchemaUtils] Attempting to create simple RLS policy for tasks...', name: 'SchemaUtils');
    
    try {
      // First, drop any existing problematic policies
      await _mcpTool.executeSql(
        query: 'DROP POLICY IF EXISTS "Users can manage their own tasks" ON public.tasks;'
      );
      
      // Create a simple, non-recursive policy
      const String createPolicyQuery = '''
        CREATE POLICY "Users can manage their own tasks" 
        ON public.tasks 
        FOR ALL 
        USING (auth.uid() = user_id)
        WITH CHECK (auth.uid() = user_id);
      ''';
      
      await _mcpTool.executeSql(query: createPolicyQuery);
      
      log('[SchemaUtils] ✅ Created simple RLS policy for tasks', name: 'SchemaUtils');
      return true;
      
    } catch (e, stackTrace) {
      log('[SchemaUtils] ❌ Failed to create RLS policy for tasks: $e', name: 'SchemaUtils', error: e, stackTrace: stackTrace, level: LogLevel.error);
      return false;
    }
  }
  
  // Emergency method to disable RLS temporarily for debugging
  static Future<bool> temporarilyDisableRls({required String tableName}) async {
    log('[SchemaUtils] ⚠️  TEMPORARILY disabling RLS for $tableName (DEBUG ONLY)', name: 'SchemaUtils', level: LogLevel.warning);
    
    try {
      await _mcpTool.executeSql(
        query: 'ALTER TABLE public.$tableName DISABLE ROW LEVEL SECURITY;'
      );
      
      log('[SchemaUtils] ⚠️  RLS disabled for $tableName - REMEMBER TO RE-ENABLE', name: 'SchemaUtils', level: LogLevel.warning);
      return true;
      
    } catch (e) {
      log('[SchemaUtils] Failed to disable RLS for $tableName: $e', name: 'SchemaUtils', level: LogLevel.error);
      return false;
    }
  }
  
  // Method to re-enable RLS
  static Future<bool> enableRls({required String tableName}) async {
    log('[SchemaUtils] Re-enabling RLS for $tableName', name: 'SchemaUtils');
    
    try {
      await _mcpTool.executeSql(
        query: 'ALTER TABLE public.$tableName ENABLE ROW LEVEL SECURITY;'
      );
      
      log('[SchemaUtils] ✅ RLS enabled for $tableName', name: 'SchemaUtils');
      return true;
      
    } catch (e) {
      log('[SchemaUtils] Failed to enable RLS for $tableName: $e', name: 'SchemaUtils', level: LogLevel.error);
      return false;
    }
  }
}