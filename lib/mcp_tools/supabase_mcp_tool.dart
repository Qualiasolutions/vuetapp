import 'package:flutter/foundation.dart';
import 'package:vuet_app/mcp_tools/mcp_tool_interface.dart';
import 'package:vuet_app/utils/logger.dart';

// Enhanced wrapper for interacting with Supabase MCP tools
class SupabaseMcpTool {
  final String? projectId;
  final String? token; // New: Supabase project token

  SupabaseMcpTool({this.projectId, this.token});
  static const String serverName = 'github.com/supabase-community/supabase-mcp';

  // Helper to extract project ID from the token
  String? _getEffectiveProjectId() {
    if (token != null && token!.startsWith('sbp_')) {
      // Assuming the part after 'sbp_' is the project ID
      return token!.substring(4);
    }
    return projectId ?? 'xrloafqzfdzewdoawysh'; // Fallback to default if no token or invalid format
  }

  // Method to execute SQL using the MCP tool
  Future<List<Map<String, dynamic>>> executeSql({
    String? projectId,
    required String query,
  }) async {
    final String useProjectId = projectId ?? _getEffectiveProjectId() ?? 'xrloafqzfdzewdoawysh';

    try {
      log('[MCP] Executing SQL: $query', name: 'SupabaseMcpTool');

      final result = await McpToolInterface.useMcpTool(
        serverName: serverName,
        toolName: 'execute_sql',
        arguments: {
          'project_id': useProjectId,
          'query': query,
        },
      );

      if (result is List) {
        log('[MCP] SQL execution successful, returned ${result.length} rows',
            name: 'SupabaseMcpTool');
        return List<Map<String, dynamic>>.from(result);
      } else {
        log('[MCP] Unexpected result format: $result',
            name: 'SupabaseMcpTool', level: LogLevel.warning);
        return [];
      }
    } catch (e, stackTrace) {
      log('[MCP] Error executing SQL: $e',
          name: 'SupabaseMcpTool',
          error: e,
          stackTrace: stackTrace,
          level: LogLevel.error);
      return [];
    }
  }

  // Method to list tables using the MCP tool
  Future<List<Map<String, dynamic>>> listTables({
    String? projectId,
  }) async {
    final String useProjectId = projectId ?? _getEffectiveProjectId() ?? 'xrloafqzfdzewdoawysh';

    try {
      final result = await McpToolInterface.useMcpTool(
        serverName: serverName,
        toolName: 'list_tables',
        arguments: {
          'project_id': useProjectId,
        },
      );

      if (result is List) {
        return List<Map<String, dynamic>>.from(result);
      } else {
        debugPrint('Unexpected result format from list_tables: $result');
        return [];
      }
    } catch (e, stackTrace) {
      log('[MCP] Error listing tables: $e',
          name: 'SupabaseMcpTool',
          error: e,
          stackTrace: stackTrace,
          level: LogLevel.error);
      return [];
    }
  }

  // Method for applying migrations
  Future<Map<String, dynamic>> applyMigration({
    String? projectId,
    required String name,
    required String query,
  }) async {
    final String useProjectId = projectId ?? _getEffectiveProjectId() ?? 'xrloafqzfdzewdoawysh';

    try {
      log('[MCP] Applying migration: $name', name: 'SupabaseMcpTool');

      final result = await McpToolInterface.useMcpTool(
        serverName: serverName,
        toolName: 'apply_migration',
        arguments: {
          'project_id': useProjectId,
          'name': name,
          'query': query,
        },
      );

      if (result is Map) {
        log('[MCP] Migration applied successfully', name: 'SupabaseMcpTool');
        return Map<String, dynamic>.from(result);
      } else {
        log('[MCP] Unexpected result format from apply_migration: $result',
            name: 'SupabaseMcpTool', level: LogLevel.warning);
        return {};
      }
    } catch (e, stackTrace) {
      log('[MCP] Error applying migration: $e',
          name: 'SupabaseMcpTool',
          error: e,
          stackTrace: stackTrace,
          level: LogLevel.error);
      return {};
    }
  }

  // Enhanced method to check if column exists
  Future<bool> columnExists({
    String? projectId,
    required String tableName,
    required String columnName,
  }) async {
    final String useProjectId = projectId ?? _getEffectiveProjectId() ?? 'xrloafqzfdzewdoawysh';

    const String checkColumnQuery = '''
      SELECT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = ? 
        AND column_name = ?
      ) as column_exists;
    ''';

    try {
      final result = await executeSql(
        projectId: useProjectId,
        query: checkColumnQuery
            .replaceFirst('?', "''$tableName''")
            .replaceFirst('?', "''$columnName''"),
      );

      if (result.isNotEmpty && result.first.containsKey('column_exists')) {
        return result.first['column_exists'] == true;
      }
      return false;
    } catch (e) {
      log('[MCP] Error checking column existence: $e',
          name: 'SupabaseMcpTool', level: LogLevel.error);
      return false;
    }
  }

  // Method to safely add the is_professional column
  Future<bool> addIsProfessionalColumn({String? projectId}) async {
    final String useProjectId = projectId ?? _getEffectiveProjectId() ?? 'xrloafqzfdzewdoawysh';

    try {
      log('[MCP] Checking if is_professional column exists...',
          name: 'SupabaseMcpTool');

      // Check if column already exists
      final columnExists = await this.columnExists(
        projectId: useProjectId,
        tableName: 'entity_categories',
        columnName: 'is_professional',
      );

      if (columnExists) {
        log('[MCP] Column is_professional already exists',
            name: 'SupabaseMcpTool');
        return true;
      }

      log('[MCP] Adding is_professional column to entity_categories...',
          name: 'SupabaseMcpTool');

      const String alterTableQuery = '''
        ALTER TABLE public.entity_categories
        ADD COLUMN is_professional BOOLEAN DEFAULT false;
      ''';

      await executeSql(
        projectId: useProjectId,
        query: alterTableQuery,
      );

      // Update existing rows to ensure they have the default value
      log('[MCP] Updating existing rows with default value...',
          name: 'SupabaseMcpTool');
      const String updateExistingQuery = '''
        UPDATE public.entity_categories 
        SET is_professional = false 
        WHERE is_professional IS NULL;
      ''';

      await executeSql(
        projectId: useProjectId,
        query: updateExistingQuery,
      );

      log('[MCP] Successfully added is_professional column',
          name: 'SupabaseMcpTool');
      return true;
    } catch (e, stackTrace) {
      log('[MCP] Failed to add is_professional column: $e',
          name: 'SupabaseMcpTool',
          error: e,
          stackTrace: stackTrace,
          level: LogLevel.error);
      return false;
    }
  }

  // Method to list RLS policies for a table
  Future<List<Map<String, dynamic>>> listRlsPolicies({
    String? projectId,
    required String tableName,
  }) async {
    final String useProjectId = projectId ?? _getEffectiveProjectId() ?? 'xrloafqzfdzewdoawysh';

    const String listPoliciesQuery = '''
      SELECT 
        schemaname,
        tablename,
        policyname,
        permissive,
        roles,
        cmd,
        qual,
        with_check
      FROM pg_policies 
      WHERE tablename = ?
      ORDER BY policyname;
    ''';

    try {
      log('[MCP] Listing RLS policies for table: $tableName',
          name: 'SupabaseMcpTool');

      final result = await executeSql(
        projectId: useProjectId,
        query: listPoliciesQuery.replaceFirst('?', "'$tableName'"),
      );

      log('[MCP] Found ${result.length} RLS policies for $tableName',
          name: 'SupabaseMcpTool');
      return result;
    } catch (e, stackTrace) {
      log('[MCP] Error listing RLS policies: $e',
          name: 'SupabaseMcpTool',
          error: e,
          stackTrace: stackTrace,
          level: LogLevel.error);
      return [];
    }
  }

  // Method to check table structure
  Future<List<Map<String, dynamic>>> describeTable({
    String? projectId,
    required String tableName,
  }) async {
    final String useProjectId = projectId ?? _getEffectiveProjectId() ?? 'xrloafqzfdzewdoawysh';

    const String describeQuery = '''
      SELECT 
        column_name,
        data_type,
        is_nullable,
        column_default,
        character_maximum_length
      FROM information_schema.columns 
      WHERE table_schema = 'public' 
      AND table_name = ?
      ORDER BY ordinal_position;
    ''';

    try {
      log('[MCP] Describing table structure: $tableName',
          name: 'SupabaseMcpTool');

      final result = await executeSql(
        projectId: useProjectId,
        query: describeQuery.replaceFirst('?', "'$tableName'"),
      );

      log('[MCP] Table $tableName has ${result.length} columns',
          name: 'SupabaseMcpTool');
      return result;
    } catch (e, stackTrace) {
      log('[MCP] Error describing table: $e',
          name: 'SupabaseMcpTool',
          error: e,
          stackTrace: stackTrace,
          level: LogLevel.error);
      return [];
    }
  }

  // Method to test basic connectivity
  Future<bool> testConnection({String? projectId}) async {
    final String useProjectId = projectId ?? _getEffectiveProjectId() ?? 'xrloafqzfdzewdoawysh';

    try {
      log('[MCP] Testing connection...', name: 'SupabaseMcpTool');

      final result = await executeSql(
        projectId: useProjectId,
        query: 'SELECT 1 as test;',
      );

      final isConnected = result.isNotEmpty && result.first['test'] == 1;
      log('[MCP] Connection test: ${isConnected ? 'SUCCESS' : 'FAILED'}',
          name: 'SupabaseMcpTool');

      return isConnected;
    } catch (e) {
      log('[MCP] Connection test failed: $e',
          name: 'SupabaseMcpTool', level: LogLevel.error);
      return false;
    }
  }

  // Method to verify database schema alignment with Flutter models
  Future<Map<String, dynamic>> verifySchemaAlignment({
    String? projectId,
    required List<String> requiredTables,
  }) async {
    final String useProjectId = projectId ?? _getEffectiveProjectId() ?? 'xrloafqzfdzewdoawysh';
    
    final Map<String, dynamic> results = {
      'success': true,
      'missing_tables': <String>[],
      'tables_info': <String, dynamic>{},
    };

    try {
      log('[MCP] Verifying schema alignment...', name: 'SupabaseMcpTool');
      
      // Get all tables
      final tables = await listTables(projectId: useProjectId);
      final tableNames = tables.map((t) => t['table_name'] as String).toList();
      
      // Check for missing tables
      for (final requiredTable in requiredTables) {
        if (!tableNames.contains(requiredTable)) {
          results['missing_tables'].add(requiredTable);
          results['success'] = false;
        } else {
          // Get table structure
          final tableInfo = await describeTable(
            projectId: useProjectId,
            tableName: requiredTable,
          );
          results['tables_info'][requiredTable] = tableInfo;
        }
      }
      
      log('[MCP] Schema verification ${results['success'] ? 'passed' : 'failed'}',
          name: 'SupabaseMcpTool');
      
      return results;
    } catch (e, stackTrace) {
      log('[MCP] Error verifying schema: $e',
          name: 'SupabaseMcpTool',
          error: e,
          stackTrace: stackTrace,
          level: LogLevel.error);
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
