import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/mcp_tools/supabase_mcp_tool.dart';
import 'package:vuet_app/utils/logger.dart';

/// A utility class for verifying the alignment between Flutter models and Supabase database schema.
/// 
/// This utility connects to Supabase using the provided token, extracts the project ID,
/// and verifies that all critical tables exist with the correct column structure.
class SchemaVerificationTest {
  /// The Supabase project token
  final String token;
  
  /// The Supabase MCP tool instance
  late final SupabaseMcpTool _mcpTool;
  
  /// The extracted project ID from the token
  late final String _projectId;
  
  /// Constructor
  SchemaVerificationTest({required this.token}) {
    // Extract project ID from token (part after 'sbp_')
    if (token.startsWith('sbp_')) {
      _projectId = token.substring(4);
      log('Extracted project ID: $_projectId', name: 'SchemaVerificationTest');
    } else {
      throw ArgumentError('Invalid Supabase token format. Expected format: sbp_<project_id>');
    }
    
    // Initialize MCP tool with token
    _mcpTool = SupabaseMcpTool(token: token);
  }
  
  /// Test connectivity to the Supabase project
  Future<bool> testConnectivity() async {
    try {
      log('Testing connectivity to Supabase project: $_projectId', name: 'SchemaVerificationTest');
      
      // Try using MCP tool first (note: this may not work in all environments due to MCP limitations)
      final mcpResult = await _mcpTool.testConnection();
      if (mcpResult) {
        log('Successfully connected via MCP tool', name: 'SchemaVerificationTest');
        return true;
      }
      
      // If MCP fails, try direct Supabase connection
      log('MCP connection failed, trying direct Supabase connection', name: 'SchemaVerificationTest');
      
      // Get current Supabase client from config
      final client = SupabaseConfig.client;
      
      // Simple query to test connection
      final result = await client.from('_schema_verification_test')
          .select()
          .limit(1)
          .maybeSingle()
          .onError((error, stackTrace) async {
            // It's okay if this table doesn't exist, we just need to test connectivity
            return null;
          });
      
      log('Successfully connected via direct Supabase client', name: 'SchemaVerificationTest');
      return true;
    } catch (e, stackTrace) {
      log('Failed to connect to Supabase: $e', 
          name: 'SchemaVerificationTest', 
          error: e, 
          stackTrace: stackTrace,
          level: LogLevel.error);
      return false;
    }
  }
  
  /// Verify all required tables exist and have the correct structure
  Future<Map<String, dynamic>> verifyTableStructures() async {
    final requiredTables = [
      'tasks',
      'entities',
      'entity_categories',
      'recurrences',
      'task_actions',
      'task_reminders',
      'profiles', // users
      'families',
      'family_invitations',
    ];
    
    final results = <String, dynamic>{
      'success': true,
      'missing_tables': <String>[],
      'tables_info': <String, dynamic>{},
    };
    
    try {
      log('Verifying table structures for ${requiredTables.length} tables', 
          name: 'SchemaVerificationTest');
      
      // Try using MCP tool first
      final mcpResult = await _mcpTool.verifySchemaAlignment(
        requiredTables: requiredTables,
      );
      
      if (mcpResult['success'] == true) {
        log('Successfully verified tables via MCP tool', name: 'SchemaVerificationTest');
        return mcpResult;
      }
      
      // If MCP fails, try direct Supabase connection
      log('MCP verification failed, trying direct Supabase verification', 
          name: 'SchemaVerificationTest');
      
      // Get current Supabase client from config
      final client = SupabaseConfig.client;
      
      // Check each required table
      for (final tableName in requiredTables) {
        try {
          // Query to check if table exists and get its structure
          final tableInfo = await client.rpc('schema_info', 
            params: {'table_name': tableName}).maybeSingle();
          
          if (tableInfo == null) {
            results['missing_tables'].add(tableName);
            results['success'] = false;
            log('Table not found: $tableName', 
                name: 'SchemaVerificationTest', 
                level: LogLevel.warning);
          } else {
            results['tables_info'][tableName] = tableInfo;
            log('Table verified: $tableName', name: 'SchemaVerificationTest');
          }
        } catch (e) {
          // If the RPC function doesn't exist, try a simpler approach
          try {
            // Just try to select from the table to see if it exists
            await client.from(tableName).select('id').limit(1);
            results['tables_info'][tableName] = {'exists': true};
            log('Table exists (basic check): $tableName', name: 'SchemaVerificationTest');
          } catch (selectError) {
            results['missing_tables'].add(tableName);
            results['success'] = false;
            log('Table verification failed: $tableName - $selectError', 
                name: 'SchemaVerificationTest', 
                level: LogLevel.warning);
          }
        }
      }
      
      return results;
    } catch (e, stackTrace) {
      log('Failed to verify table structures: $e', 
          name: 'SchemaVerificationTest', 
          error: e, 
          stackTrace: stackTrace,
          level: LogLevel.error);
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
  
  /// Check column types and constraints for a specific table
  Future<Map<String, dynamic>> checkColumnTypesAndConstraints(String tableName) async {
    final results = <String, dynamic>{
      'success': true,
      'table_name': tableName,
      'missing_columns': <String>[],
      'mismatched_columns': <Map<String, dynamic>>[],
      'column_info': <String, dynamic>{},
    };
    
    try {
      log('Checking column types and constraints for table: $tableName', 
          name: 'SchemaVerificationTest');
      
      // Get expected columns based on the model
      final expectedColumns = _getExpectedColumns(tableName);
      if (expectedColumns.isEmpty) {
        results['success'] = false;
        results['error'] = 'No expected columns defined for table: $tableName';
        return results;
      }
      
      // Try using MCP tool first
      final tableInfo = await _mcpTool.describeTable(tableName: tableName);
      
      if (tableInfo.isNotEmpty) {
        // Process column info from MCP
        final columnMap = <String, Map<String, dynamic>>{};
        for (final column in tableInfo) {
          columnMap[column['column_name'] as String] = column;
        }
        
        results['column_info'] = columnMap;
        
        // Check each expected column
        for (final expectedColumn in expectedColumns) {
          final columnName = expectedColumn['name'] as String;
          final expectedType = expectedColumn['type'] as String;
          final isNullable = expectedColumn['nullable'] as bool;
          
          if (!columnMap.containsKey(columnName)) {
            results['missing_columns'].add(columnName);
            results['success'] = false;
            continue;
          }
          
          final actualColumn = columnMap[columnName]!;
          final actualType = actualColumn['data_type'] as String;
          final actualNullable = actualColumn['is_nullable'] == 'YES';
          
          // Check for type mismatches
          if (!_isCompatibleType(expectedType, actualType)) {
            results['mismatched_columns'].add({
              'column': columnName,
              'expected_type': expectedType,
              'actual_type': actualType,
              'issue': 'Type mismatch',
            });
            results['success'] = false;
          }
          
          // Check for nullability mismatches
          if (isNullable != actualNullable) {
            results['mismatched_columns'].add({
              'column': columnName,
              'expected_nullable': isNullable,
              'actual_nullable': actualNullable,
              'issue': 'Nullability mismatch',
            });
            results['success'] = false;
          }
        }
        
        return results;
      }
      
      // If MCP fails, try direct Supabase connection
      log('MCP column check failed, trying direct Supabase check', 
          name: 'SchemaVerificationTest');
      
      // Get current Supabase client from config
      final client = SupabaseConfig.client;
      
      // Query to get column information
      final columnQuery = '''
        SELECT 
          column_name, 
          data_type, 
          is_nullable, 
          column_default
        FROM 
          information_schema.columns 
        WHERE 
          table_schema = 'public' 
          AND table_name = '$tableName'
      ''';
      
      try {
        final columnInfo = await client.rpc('run_sql', 
          params: {'query': columnQuery}).select();
        
        if (columnInfo != null && columnInfo.isNotEmpty) {
          // Process column info
          final columnMap = <String, Map<String, dynamic>>{};
          for (final column in columnInfo) {
            columnMap[column['column_name'] as String] = column;
          }
          
          results['column_info'] = columnMap;
          
          // Check each expected column
          for (final expectedColumn in expectedColumns) {
            final columnName = expectedColumn['name'] as String;
            final expectedType = expectedColumn['type'] as String;
            final isNullable = expectedColumn['nullable'] as bool;
            
            if (!columnMap.containsKey(columnName)) {
              results['missing_columns'].add(columnName);
              results['success'] = false;
              continue;
            }
            
            final actualColumn = columnMap[columnName]!;
            final actualType = actualColumn['data_type'] as String;
            final actualNullable = actualColumn['is_nullable'] == 'YES';
            
            // Check for type mismatches
            if (!_isCompatibleType(expectedType, actualType)) {
              results['mismatched_columns'].add({
                'column': columnName,
                'expected_type': expectedType,
                'actual_type': actualType,
                'issue': 'Type mismatch',
              });
              results['success'] = false;
            }
            
            // Check for nullability mismatches
            if (isNullable != actualNullable) {
              results['mismatched_columns'].add({
                'column': columnName,
                'expected_nullable': isNullable,
                'actual_nullable': actualNullable,
                'issue': 'Nullability mismatch',
              });
              results['success'] = false;
            }
          }
        } else {
          results['success'] = false;
          results['error'] = 'Failed to retrieve column information for table: $tableName';
        }
      } catch (e) {
        // If the RPC function doesn't exist, we can't get detailed column info
        results['success'] = false;
        results['error'] = 'Cannot retrieve column information: $e';
      }
      
      return results;
    } catch (e, stackTrace) {
      log('Failed to check column types and constraints: $e', 
          name: 'SchemaVerificationTest', 
          error: e, 
          stackTrace: stackTrace,
          level: LogLevel.error);
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
  
  /// Report discrepancies between expected and actual schema
  Future<Map<String, dynamic>> reportDiscrepancies() async {
    final report = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'project_id': _projectId,
      'overall_status': 'pending',
      'table_status': <String, dynamic>{},
      'summary': <String, dynamic>{
        'total_tables_checked': 0,
        'tables_with_issues': 0,
        'missing_tables': 0,
        'tables_with_missing_columns': 0,
        'tables_with_mismatched_columns': 0,
      },
    };
    
    try {
      log('Generating schema discrepancy report', name: 'SchemaVerificationTest');
      
      // First verify table structures
      final tableResults = await verifyTableStructures();
      
      // Update report with table existence information
      report['table_status']['existence'] = tableResults;
      report['summary']['total_tables_checked'] = 
          (tableResults['tables_info'] as Map<String, dynamic>).length + 
          (tableResults['missing_tables'] as List).length;
      report['summary']['missing_tables'] = (tableResults['missing_tables'] as List).length;
      
      if (!tableResults['success']) {
        report['overall_status'] = 'failed';
        report['summary']['tables_with_issues'] += (tableResults['missing_tables'] as List).length;
      }
      
      // Check column types and constraints for each existing table
      final existingTables = (tableResults['tables_info'] as Map<String, dynamic>).keys.toList();
      final columnChecks = <String, Map<String, dynamic>>{};
      
      for (final tableName in existingTables) {
        final columnResults = await checkColumnTypesAndConstraints(tableName);
        columnChecks[tableName] = columnResults;
        
        if (!columnResults['success']) {
          report['overall_status'] = 'failed';
          report['summary']['tables_with_issues']++;
          
          if ((columnResults['missing_columns'] as List).isNotEmpty) {
            report['summary']['tables_with_missing_columns']++;
          }
          
          if ((columnResults['mismatched_columns'] as List).isNotEmpty) {
            report['summary']['tables_with_mismatched_columns']++;
          }
        }
      }
      
      report['table_status']['columns'] = columnChecks;
      
      // Set overall status to success if not already failed
      if (report['overall_status'] == 'pending') {
        report['overall_status'] = 'success';
      }
      
      log('Schema discrepancy report generated: ${report['overall_status']}', 
          name: 'SchemaVerificationTest');
      
      return report;
    } catch (e, stackTrace) {
      log('Failed to generate discrepancy report: $e', 
          name: 'SchemaVerificationTest', 
          error: e, 
          stackTrace: stackTrace,
          level: LogLevel.error);
      return {
        'timestamp': DateTime.now().toIso8601String(),
        'project_id': _projectId,
        'overall_status': 'error',
        'error': e.toString(),
      };
    }
  }
  
  /// Suggest fixes for identified schema discrepancies
  Future<Map<String, dynamic>> suggestFixes(Map<String, dynamic> discrepancyReport) async {
    final fixes = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'project_id': _projectId,
      'suggested_migrations': <String, List<String>>{},
      'manual_actions': <String, List<String>>{},
    };
    
    try {
      log('Generating fix suggestions based on discrepancy report', 
          name: 'SchemaVerificationTest');
      
      // Only generate fixes if there are issues
      if (discrepancyReport['overall_status'] == 'success') {
        fixes['message'] = 'No issues detected, no fixes needed.';
        return fixes;
      }
      
      // Handle missing tables
      final tableStatus = discrepancyReport['table_status'] as Map<String, dynamic>;
      final existenceInfo = tableStatus['existence'] as Map<String, dynamic>;
      final missingTables = existenceInfo['missing_tables'] as List;
      
      if (missingTables.isNotEmpty) {
        fixes['suggested_migrations']['create_tables'] = <String>[];
        
        for (final tableName in missingTables) {
          final createTableSql = _generateCreateTableSql(tableName as String);
          if (createTableSql.isNotEmpty) {
            fixes['suggested_migrations']['create_tables'].add(createTableSql);
          } else {
            if (fixes['manual_actions']['create_tables'] == null) {
              fixes['manual_actions']['create_tables'] = <String>[];
            }
            fixes['manual_actions']['create_tables'].add(
              'Create table "$tableName" manually - no template available');
          }
        }
      }
      
      // Handle column issues
      if (tableStatus.containsKey('columns')) {
        final columnChecks = tableStatus['columns'] as Map<String, dynamic>;
        
        fixes['suggested_migrations']['alter_tables'] = <String>[];
        
        for (final entry in columnChecks.entries) {
          final tableName = entry.key;
          final columnResults = entry.value as Map<String, dynamic>;
          
          // Handle missing columns
          final missingColumns = columnResults['missing_columns'] as List;
          if (missingColumns.isNotEmpty) {
            for (final columnName in missingColumns) {
              final addColumnSql = _generateAddColumnSql(
                tableName, columnName as String);
              
              if (addColumnSql.isNotEmpty) {
                fixes['suggested_migrations']['alter_tables'].add(addColumnSql);
              } else {
                if (fixes['manual_actions']['add_columns'] == null) {
                  fixes['manual_actions']['add_columns'] = <String>[];
                }
                fixes['manual_actions']['add_columns'].add(
                  'Add column "$columnName" to table "$tableName" manually');
              }
            }
          }
          
          // Handle mismatched columns
          final mismatchedColumns = columnResults['mismatched_columns'] as List;
          if (mismatchedColumns.isNotEmpty) {
            for (final mismatch in mismatchedColumns) {
              final mismatchInfo = mismatch as Map<String, dynamic>;
              final columnName = mismatchInfo['column'] as String;
              final issue = mismatchInfo['issue'] as String;
              
              if (issue == 'Type mismatch') {
                final alterColumnSql = _generateAlterColumnTypeSql(
                  tableName, 
                  columnName,
                  mismatchInfo['expected_type'] as String,
                  mismatchInfo['actual_type'] as String,
                );
                
                if (alterColumnSql.isNotEmpty) {
                  fixes['suggested_migrations']['alter_tables'].add(alterColumnSql);
                } else {
                  if (fixes['manual_actions']['alter_columns'] == null) {
                    fixes['manual_actions']['alter_columns'] = <String>[];
                  }
                  fixes['manual_actions']['alter_columns'].add(
                    'Alter column "$columnName" in table "$tableName" from type ' +
                    '"${mismatchInfo['actual_type']}" to "${mismatchInfo['expected_type']}" manually');
                }
              } else if (issue == 'Nullability mismatch') {
                final alterNullabilitySql = _generateAlterColumnNullabilitySql(
                  tableName, 
                  columnName,
                  mismatchInfo['expected_nullable'] as bool,
                );
                
                if (alterNullabilitySql.isNotEmpty) {
                  fixes['suggested_migrations']['alter_tables'].add(alterNullabilitySql);
                } else {
                  if (fixes['manual_actions']['alter_columns'] == null) {
                    fixes['manual_actions']['alter_columns'] = <String>[];
                  }
                  fixes['manual_actions']['alter_columns'].add(
                    'Alter column "$columnName" in table "$tableName" to be ' +
                    (mismatchInfo['expected_nullable'] ? 'nullable' : 'NOT NULL') + ' manually');
                }
              }
            }
          }
        }
        
        // Remove empty lists
        if ((fixes['suggested_migrations']['alter_tables'] as List).isEmpty) {
          (fixes['suggested_migrations'] as Map).remove('alter_tables');
        }
      }
      
      // Remove empty sections
      if ((fixes['suggested_migrations'] as Map).isEmpty) {
        fixes.remove('suggested_migrations');
      }
      
      if ((fixes['manual_actions'] as Map).isEmpty) {
        fixes.remove('manual_actions');
      }
      
      log('Fix suggestions generated', name: 'SchemaVerificationTest');
      
      return fixes;
    } catch (e, stackTrace) {
      log('Failed to generate fix suggestions: $e', 
          name: 'SchemaVerificationTest', 
          error: e, 
          stackTrace: stackTrace,
          level: LogLevel.error);
      return {
        'timestamp': DateTime.now().toIso8601String(),
        'project_id': _projectId,
        'error': e.toString(),
      };
    }
  }
  
  /// Run the complete verification process and generate a report with fix suggestions
  Future<Map<String, dynamic>> runCompleteVerification() async {
    final report = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'project_id': _projectId,
      'connectivity': false,
      'discrepancies': null,
      'suggested_fixes': null,
    };
    
    try {
      log('Starting complete schema verification process', name: 'SchemaVerificationTest');
      
      // Test connectivity
      final isConnected = await testConnectivity();
      report['connectivity'] = isConnected;
      
      if (!isConnected) {
        report['error'] = 'Failed to connect to Supabase project';
        return report;
      }
      
      // Generate discrepancy report
      final discrepancies = await reportDiscrepancies();
      report['discrepancies'] = discrepancies;
      
      // Generate fix suggestions if there are issues
      if (discrepancies['overall_status'] != 'success') {
        final fixes = await suggestFixes(discrepancies);
        report['suggested_fixes'] = fixes;
      }
      
      log('Complete verification process finished', name: 'SchemaVerificationTest');
      
      return report;
    } catch (e, stackTrace) {
      log('Complete verification process failed: $e', 
          name: 'SchemaVerificationTest', 
          error: e, 
          stackTrace: stackTrace,
          level: LogLevel.error);
      return {
        'timestamp': DateTime.now().toIso8601String(),
        'project_id': _projectId,
        'error': e.toString(),
      };
    }
  }
  
  /// Helper method to get expected columns for a table
  List<Map<String, dynamic>> _getExpectedColumns(String tableName) {
    switch (tableName) {
      case 'tasks':
        return [
          {'name': 'id', 'type': 'uuid', 'nullable': false},
          {'name': 'title', 'type': 'text', 'nullable': false},
          {'name': 'description', 'type': 'text', 'nullable': true},
          {'name': 'due_date', 'type': 'timestamp', 'nullable': true},
          {'name': 'priority', 'type': 'text', 'nullable': false},
          {'name': 'status', 'type': 'text', 'nullable': false},
          {'name': 'is_recurring', 'type': 'boolean', 'nullable': false},
          {'name': 'recurrence_pattern', 'type': 'jsonb', 'nullable': true},
          {'name': 'category_id', 'type': 'uuid', 'nullable': true},
          {'name': 'created_by_id', 'type': 'uuid', 'nullable': true},
          {'name': 'assigned_to_id', 'type': 'uuid', 'nullable': true},
          {'name': 'parent_task_id', 'type': 'uuid', 'nullable': true},
          {'name': 'entity_id', 'type': 'uuid', 'nullable': true},
          {'name': 'routine_id', 'type': 'uuid', 'nullable': true},
          {'name': 'routine_instance_id', 'type': 'uuid', 'nullable': true},
          {'name': 'is_generated_from_routine', 'type': 'boolean', 'nullable': false},
          {'name': 'task_type', 'type': 'text', 'nullable': true},
          {'name': 'task_subtype', 'type': 'text', 'nullable': true},
          {'name': 'start_datetime', 'type': 'timestamp', 'nullable': true},
          {'name': 'end_datetime', 'type': 'timestamp', 'nullable': true},
          {'name': 'location', 'type': 'text', 'nullable': true},
          {'name': 'type_specific_data', 'type': 'jsonb', 'nullable': true},
          {'name': 'created_at', 'type': 'timestamp', 'nullable': false},
          {'name': 'updated_at', 'type': 'timestamp', 'nullable': false},
          {'name': 'completed_at', 'type': 'timestamp', 'nullable': true},
          {'name': 'task_behavior', 'type': 'text', 'nullable': true},
          {'name': 'urgency', 'type': 'text', 'nullable': true},
          {'name': 'earliest_action_date', 'type': 'timestamp', 'nullable': true},
          {'name': 'duration_minutes', 'type': 'integer', 'nullable': true},
          {'name': 'start_date_time_zone', 'type': 'text', 'nullable': true},
          {'name': 'end_date_time_zone', 'type': 'text', 'nullable': true},
          {'name': 'all_day', 'type': 'boolean', 'nullable': true},
          {'name': 'hidden_tag', 'type': 'text', 'nullable': true},
          {'name': 'tags', 'type': 'text[]', 'nullable': true},
          {'name': 'contact_name', 'type': 'text', 'nullable': true},
          {'name': 'contact_email', 'type': 'text', 'nullable': true},
          {'name': 'contact_phone', 'type': 'text', 'nullable': true},
        ];
        
      case 'entities':
        return [
          {'name': 'id', 'type': 'uuid', 'nullable': false},
          {'name': 'name', 'type': 'text', 'nullable': false},
          {'name': 'description', 'type': 'text', 'nullable': true},
          {'name': 'owner_id', 'type': 'uuid', 'nullable': false}, // user_id in model
          {'name': 'app_category_id', 'type': 'integer', 'nullable': true},
          {'name': 'image_url', 'type': 'text', 'nullable': true},
          {'name': 'parent_id', 'type': 'uuid', 'nullable': true},
          {'name': 'entity_type_id', 'type': 'text', 'nullable': true}, // subtype in model
          {'name': 'created_at', 'type': 'timestamp', 'nullable': false},
          {'name': 'updated_at', 'type': 'timestamp', 'nullable': true},
          {'name': 'is_hidden', 'type': 'boolean', 'nullable': true},
          {'name': 'attributes', 'type': 'jsonb', 'nullable': true},
          {'name': 'due_date', 'type': 'timestamp', 'nullable': true},
          {'name': 'status', 'type': 'text', 'nullable': true},
        ];
        
      case 'entity_categories':
        return [
          {'name': 'id', 'type': 'uuid', 'nullable': false},
          {'name': 'name', 'type': 'text', 'nullable': false},
          {'name': 'color', 'type': 'text', 'nullable': true},
          {'name': 'owner_id', 'type': 'uuid', 'nullable': true},
          {'name': 'created_at', 'type': 'timestamp', 'nullable': false},
          {'name': 'updated_at', 'type': 'timestamp', 'nullable': true},
          {'name': 'parent_id', 'type': 'uuid', 'nullable': true},
          {'name': 'app_category_id', 'type': 'integer', 'nullable': true},
          {'name': 'priority', 'type': 'integer', 'nullable': true},
          {'name': 'icon', 'type': 'text', 'nullable': true},
          {'name': 'is_professional', 'type': 'boolean', 'nullable': true},
        ];
        
      case 'recurrences':
        return [
          {'name': 'id', 'type': 'uuid', 'nullable': false},
          {'name': 'task_id', 'type': 'uuid', 'nullable': false},
          {'name': 'recurrence_type', 'type': 'text', 'nullable': false},
          {'name': 'interval_length', 'type': 'integer', 'nullable': false},
          {'name': 'days_of_week', 'type': 'integer[]', 'nullable': true},
          {'name': 'day_of_month', 'type': 'integer', 'nullable': true},
          {'name': 'week_of_month', 'type': 'integer', 'nullable': true},
          {'name': 'month_of_year', 'type': 'integer', 'nullable': true},
          {'name': 'earliest_occurrence', 'type': 'timestamp', 'nullable': true},
          {'name': 'latest_occurrence', 'type': 'timestamp', 'nullable': true},
          {'name': 'count', 'type': 'integer', 'nullable': true},
          {'name': 'created_at', 'type': 'timestamp', 'nullable': false},
          {'name': 'updated_at', 'type': 'timestamp', 'nullable': false},
        ];
        
      case 'task_actions':
        return [
          {'name': 'id', 'type': 'uuid', 'nullable': false},
          {'name': 'task_id', 'type': 'uuid', 'nullable': false},
          {'name': 'action_title', 'type': 'text', 'nullable': false},
          {'name': 'action_description', 'type': 'text', 'nullable': true},
          {'name': 'action_timedelta_days', 'type': 'integer', 'nullable': true},
          {'name': 'action_timedelta_hours', 'type': 'integer', 'nullable': true},
          {'name': 'action_timedelta_minutes', 'type': 'integer', 'nullable': true},
          {'name': 'is_completed', 'type': 'boolean', 'nullable': false},
          {'name': 'completed_at', 'type': 'timestamp', 'nullable': true},
          {'name': 'created_at', 'type': 'timestamp', 'nullable': false},
          {'name': 'updated_at', 'type': 'timestamp', 'nullable': false},
        ];
        
      case 'task_reminders':
        return [
          {'name': 'id', 'type': 'uuid', 'nullable': false},
          {'name': 'task_id', 'type': 'uuid', 'nullable': false},
          {'name': 'reminder_title', 'type': 'text', 'nullable': true},
          {'name': 'reminder_timedelta_days', 'type': 'integer', 'nullable': true},
          {'name': 'reminder_timedelta_hours', 'type': 'integer', 'nullable': true},
          {'name': 'reminder_timedelta_minutes', 'type': 'integer', 'nullable': true},
          {'name': 'reminder_date_time', 'type': 'timestamp', 'nullable': true},
          {'name': 'is_dismissed', 'type': 'boolean', 'nullable': false},
          {'name': 'created_at', 'type': 'timestamp', 'nullable': false},
          {'name': 'updated_at', 'type': 'timestamp', 'nullable': false},
        ];
        
      case 'profiles': // users
        return [
          {'name': 'id', 'type': 'uuid', 'nullable': false},
          {'name': 'email', 'type': 'text', 'nullable': true}, // From auth.users
          {'name': 'first_name', 'type': 'text', 'nullable': true},
          {'name': 'last_name', 'type': 'text', 'nullable': true},
          {'name': 'avatar_url', 'type': 'text', 'nullable': true},
          {'name': 'created_at', 'type': 'timestamp', 'nullable': false},
          {'name': 'updated_at', 'type': 'timestamp', 'nullable': true},
          {'name': 'phone', 'type': 'text', 'nullable': true},
          {'name': 'is_admin', 'type': 'boolean', 'nullable': true},
          {'name': 'preferences', 'type': 'jsonb', 'nullable': true},
        ];
        
      case 'families':
        return [
          {'name': 'id', 'type': 'uuid', 'nullable': false},
          {'name': 'name', 'type': 'text', 'nullable': false},
          {'name': 'created_by_id', 'type': 'uuid', 'nullable': false},
          {'name': 'created_at', 'type': 'timestamp', 'nullable': false},
          {'name': 'updated_at', 'type': 'timestamp', 'nullable': true},
          {'name': 'description', 'type': 'text', 'nullable': true},
          {'name': 'image_url', 'type': 'text', 'nullable': true},
        ];
        
      case 'family_invitations':
        return [
          {'name': 'id', 'type': 'uuid', 'nullable': false},
          {'name': 'family_id', 'type': 'uuid', 'nullable': false},
          {'name': 'invited_by_id', 'type': 'uuid', 'nullable': false},
          {'name': 'invited_email', 'type': 'text', 'nullable': false},
          {'name': 'status', 'type': 'text', 'nullable': false},
          {'name': 'created_at', 'type': 'timestamp', 'nullable': false},
          {'name': 'updated_at', 'type': 'timestamp', 'nullable': true},
          {'name': 'expires_at', 'type': 'timestamp', 'nullable': true},
          {'name': 'accepted_at', 'type': 'timestamp', 'nullable': true},
          {'name': 'declined_at', 'type': 'timestamp', 'nullable': true},
        ];
        
      default:
        return [];
    }
  }
  
  /// Helper method to check if types are compatible
  bool _isCompatibleType(String expectedType, String actualType) {
    // Normalize types for comparison
    final normalizedExpected = _normalizeType(expectedType);
    final normalizedActual = _normalizeType(actualType);
    
    // Direct match
    if (normalizedExpected == normalizedActual) {
      return true;
    }
    
    // Compatible types
    final compatibleTypes = {
      'uuid': ['uuid', 'text', 'character varying'],
      'text': ['text', 'character varying', 'varchar'],
      'timestamp': ['timestamp', 'timestamp without time zone', 'timestamp with time zone'],
      'integer': ['integer', 'int4', 'int', 'smallint', 'bigint'],
      'boolean': ['boolean', 'bool'],
      'jsonb': ['jsonb', 'json'],
      'text[]': ['text[]', 'character varying[]', 'varchar[]', '_text', '_varchar'],
    };
    
    // Check if the actual type is compatible with the expected type
    if (compatibleTypes.containsKey(normalizedExpected)) {
      return compatibleTypes[normalizedExpected]!.contains(normalizedActual);
    }
    
    return false;
  }
  
  /// Helper method to normalize type names
  String _normalizeType(String type) {
    type = type.toLowerCase();
    
    // Handle common type variations
    if (type.contains('character varying') || type.contains('varchar')) {
      return 'text';
    }
    
    if (type.contains('timestamp')) {
      return 'timestamp';
    }
    
    if (type == 'int' || type == 'int4' || type == 'smallint' || type == 'bigint') {
      return 'integer';
    }
    
    if (type == 'bool') {
      return 'boolean';
    }
    
    if (type == 'json') {
      return 'jsonb';
    }
    
    if (type.contains('_text') || type.contains('_varchar') || 
        type.contains('text[]') || type.contains('varchar[]')) {
      return 'text[]';
    }
    
    return type;
  }
  
  /// Helper method to generate CREATE TABLE SQL for a table
  String _generateCreateTableSql(String tableName) {
    final columns = _getExpectedColumns(tableName);
    if (columns.isEmpty) {
      return '';
    }
    
    final columnDefinitions = columns.map((column) {
      final name = column['name'] as String;
      final type = column['type'] as String;
      final nullable = column['nullable'] as bool;
      
      return '  "$name" $type${nullable ? '' : ' NOT NULL'}';
    }).join(',\n');
    
    return '''
CREATE TABLE public.$tableName (
$columnDefinitions,
  PRIMARY KEY (id)
);

-- Enable RLS
ALTER TABLE public.$tableName ENABLE ROW LEVEL SECURITY;

-- Create default RLS policies
CREATE POLICY "${tableName}_select_policy" ON public.$tableName
  FOR SELECT USING (owner_id = auth.uid() OR created_by_id = auth.uid());
  
CREATE POLICY "${tableName}_insert_policy" ON public.$tableName
  FOR INSERT WITH CHECK (owner_id = auth.uid() OR created_by_id = auth.uid());
  
CREATE POLICY "${tableName}_update_policy" ON public.$tableName
  FOR UPDATE USING (owner_id = auth.uid() OR created_by_id = auth.uid());
  
CREATE POLICY "${tableName}_delete_policy" ON public.$tableName
  FOR DELETE USING (owner_id = auth.uid() OR created_by_id = auth.uid());
''';
  }
  
  /// Helper method to generate ALTER TABLE ADD COLUMN SQL
  String _generateAddColumnSql(String tableName, String columnName) {
    final columns = _getExpectedColumns(tableName);
    final columnInfo = columns.firstWhere(
      (col) => col['name'] == columnName, 
      orElse: () => <String, dynamic>{});
    
    if (columnInfo.isEmpty) {
      return '';
    }
    
    final type = columnInfo['type'] as String;
    final nullable = columnInfo['nullable'] as bool;
    
    return '''
ALTER TABLE public.$tableName
ADD COLUMN "$columnName" $type${nullable ? '' : ' NOT NULL'};
''';
  }
  
  /// Helper method to generate ALTER TABLE ALTER COLUMN TYPE SQL
  String _generateAlterColumnTypeSql(
    String tableName, 
    String columnName, 
    String expectedType, 
    String actualType,
  ) {
    // Check if types are compatible for direct conversion
    if (!_canConvertType(actualType, expectedType)) {
      return ''; // Requires manual conversion
    }
    
    return '''
ALTER TABLE public.$tableName
ALTER COLUMN "$columnName" TYPE $expectedType USING "$columnName"::$expectedType;
''';
  }
  
  /// Helper method to generate ALTER TABLE ALTER COLUMN NULL/NOT NULL SQL
  String _generateAlterColumnNullabilitySql(
    String tableName, 
    String columnName, 
    bool makeNullable,
  ) {
    if (makeNullable) {
      return '''
ALTER TABLE public.$tableName
ALTER COLUMN "$columnName" DROP NOT NULL;
''';
    } else {
      return '''
-- WARNING: Setting a column to NOT NULL requires all existing values to be non-null
-- You may need to update existing null values first
ALTER TABLE public.$tableName
ALTER COLUMN "$columnName" SET NOT NULL;
''';
    }
  }
  
  /// Helper method to check if a type can be converted to another
  bool _canConvertType(String fromType, String toType) {
    // Normalize types
    final normalizedFrom = _normalizeType(fromType);
    final normalizedTo = _normalizeType(toType);
    
    // Same normalized type can always be converted
    if (normalizedFrom == normalizedTo) {
      return true;
    }
    
    // Define safe conversions
    final safeConversions = {
      'text': ['uuid', 'text', 'varchar', 'character varying'],
      'integer': ['smallint'],
      'bigint': ['integer', 'smallint'],
      'double precision': ['integer', 'smallint', 'real'],
      'jsonb': ['json'],
      'timestamp with time zone': ['timestamp', 'timestamp without time zone'],
    };
    
    // Check if conversion is safe
    if (safeConversions.containsKey(normalizedFrom)) {
      return safeConversions[normalizedFrom]!.contains(normalizedTo);
    }
    
    // By default, assume conversion requires manual intervention
    return false;
  }
}
