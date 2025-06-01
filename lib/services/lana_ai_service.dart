import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vuet_app/models/lana/chat_message_model.dart';
import 'package:vuet_app/utils/web_environment.dart';

/// Service for LANA AI natural language processing and function calling
class LanaAiService {
  String get _edgeFunctionUrl => '${WebEnvironment.supabaseUrl}/functions/v1/lana-ai';
  String get _anonKey => WebEnvironment.supabaseAnonKey ?? '';
  
  /// Process a chat message and get AI response with potential function calls
  Future<ChatMessage> processMessage({
    required String sessionId,
    required String userMessage,
    required String userId,
    List<ChatMessage>? conversationHistory,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_edgeFunctionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_anonKey',
          'apikey': _anonKey,
        },
        body: jsonEncode({
          'session_id': sessionId,
          'user_message': userMessage,
          'user_id': userId,
          'conversation_history': conversationHistory?.map((msg) => msg.toJson()).toList() ?? [],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatMessage.fromJson(data['ai_response']);
      } else {
        throw Exception('Failed to process message: ${response.body}');
      }
    } catch (e) {
      // Return error message as AI response
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'I apologize, but I encountered an error processing your request. Please try again.',
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Execute a function call from LANA AI
  Future<Map<String, dynamic>> executeFunctionCall({
    required String functionName,
    required Map<String, dynamic> parameters,
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_edgeFunctionUrl/execute-function'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_anonKey',
          'apikey': _anonKey,
        },
        body: jsonEncode({
          'function_name': functionName,
          'parameters': parameters,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to execute function: ${response.body}');
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get available functions that LANA can call
  List<Map<String, dynamic>> getAvailableFunctions() {
    return [
      {
        'name': 'create_list',
        'description': 'Create a new list (shopping, planning, etc.)',
        'parameters': {
          'type': 'object',
          'properties': {
            'name': {'type': 'string', 'description': 'Name of the list'},
            'type': {'type': 'string', 'enum': ['shopping', 'planning', 'other'], 'description': 'Type of list'},
            'items': {
              'type': 'array',
              'items': {'type': 'string'},
              'description': 'Initial items to add to the list'
            }
          },
          'required': ['name', 'type']
        }
      },
      {
        'name': 'add_list_items',
        'description': 'Add items to an existing list',
        'parameters': {
          'type': 'object',
          'properties': {
            'list_name': {'type': 'string', 'description': 'Name of the list to add items to'},
            'items': {
              'type': 'array',
              'items': {'type': 'string'},
              'description': 'Items to add to the list'
            }
          },
          'required': ['list_name', 'items']
        }
      },
      {
        'name': 'create_routine',
        'description': 'Create a new routine with scheduled tasks',
        'parameters': {
          'type': 'object',
          'properties': {
            'name': {'type': 'string', 'description': 'Name of the routine'},
            'schedule_type': {
              'type': 'string', 
              'enum': ['daily', 'weekly', 'monthly_date', 'monthly_day'],
              'description': 'How often the routine repeats'
            },
            'days_of_week': {
              'type': 'array',
              'items': {'type': 'integer', 'minimum': 0, 'maximum': 6},
              'description': 'Days of week (0=Sun, 1=Mon, ..., 6=Sat) for weekly routines'
            },
            'time_of_day': {'type': 'string', 'description': 'Time in HH:mm format'},
            'tasks': {
              'type': 'array',
              'items': {'type': 'string'},
              'description': 'List of tasks in the routine'
            }
          },
          'required': ['name', 'schedule_type', 'tasks']
        }
      },
      {
        'name': 'create_timeblock',
        'description': 'Create a time block in the weekly calendar',
        'parameters': {
          'type': 'object',
          'properties': {
            'title': {'type': 'string', 'description': 'Title of the time block'},
            'day_of_week': {
              'type': 'integer',
              'minimum': 0,
              'maximum': 6,
              'description': 'Day of week (0=Sun, 1=Mon, ..., 6=Sat)'
            },
            'start_time': {'type': 'string', 'description': 'Start time in HH:mm format'},
            'end_time': {'type': 'string', 'description': 'End time in HH:mm format'},
            'color': {'type': 'string', 'description': 'Color for the time block (hex code)'}
          },
          'required': ['title', 'day_of_week', 'start_time', 'end_time']
        }
      },
      {
        'name': 'get_user_data',
        'description': 'Get information about user\'s lists, routines, or schedule',
        'parameters': {
          'type': 'object',
          'properties': {
            'data_type': {
              'type': 'string',
              'enum': ['lists', 'routines', 'timeblocks', 'tasks'],
              'description': 'Type of data to retrieve'
            },
            'filter': {'type': 'string', 'description': 'Optional filter criteria'}
          },
          'required': ['data_type']
        }
      },
      {
        'name': 'complete_task',
        'description': 'Mark a task or list item as completed',
        'parameters': {
          'type': 'object',
          'properties': {
            'item_type': {
              'type': 'string',
              'enum': ['task', 'list_item'],
              'description': 'Type of item to complete'
            },
            'item_id': {'type': 'string', 'description': 'ID of the item to complete'},
            'item_name': {'type': 'string', 'description': 'Name of the item (if ID not available)'}
          },
          'required': ['item_type']
        }
      }
    ];
  }

  /// Generate a smart suggestion based on user's data patterns
  Future<String> generateSmartSuggestion({
    required String userId,
    required String context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_edgeFunctionUrl/smart-suggestion'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_anonKey',
          'apikey': _anonKey,
        },
        body: jsonEncode({
          'user_id': userId,
          'context': context,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['suggestion'] ?? 'No suggestions available at this time.';
      } else {
        return 'Unable to generate suggestions right now.';
      }
    } catch (e) {
      return 'Unable to generate suggestions right now.';
    }
  }
}
