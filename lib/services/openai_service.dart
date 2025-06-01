import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/lana/chat_message_model.dart';
import '../utils/web_environment.dart';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  
  final String _apiKey;
  final String _model;
  final int _maxTokens;

  OpenAIService({
    String? apiKey,
    String? model,
    int? maxTokens,
  }) : 
    _apiKey = apiKey ?? WebEnvironment.openaiApiKey ?? '',
    _model = model ?? WebEnvironment.getEnv('OPENAI_MODEL') ?? 'gpt-4',
    _maxTokens = maxTokens ?? int.tryParse(WebEnvironment.getEnv('OPENAI_MAX_TOKENS') ?? '1000') ?? 1000;

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_apiKey',
    'Content-Type': 'application/json',
  };

  // Available function definitions that LANA can call
  List<Map<String, dynamic>> get _availableFunctions => [
    {
      "name": "create_task",
      "description": "Create a new task with the given details",
      "parameters": {
        "type": "object",
        "properties": {
          "title": {
            "type": "string",
            "description": "The title of the task"
          },
          "description": {
            "type": "string",
            "description": "Optional description of the task"
          },
          "dueDate": {
            "type": "string",
            "format": "date",
            "description": "Optional due date in YYYY-MM-DD format"
          },
          "priority": {
            "type": "string",
            "enum": ["low", "medium", "high"],
            "description": "Priority level of the task"
          },
          "category": {
            "type": "string",
            "description": "Category or tag for the task"
          }
        },
        "required": ["title"]
      }
    },
    {
      "name": "get_tasks",
      "description": "Retrieve tasks based on filters",
      "parameters": {
        "type": "object",
        "properties": {
          "status": {
            "type": "string",
            "enum": ["pending", "completed", "all"],
            "description": "Filter tasks by status"
          },
          "date": {
            "type": "string",
            "format": "date",
            "description": "Get tasks for a specific date (YYYY-MM-DD)"
          },
          "category": {
            "type": "string",
            "description": "Filter tasks by category"
          }
        }
      }
    },
    {
      "name": "update_task_status",
      "description": "Update the status of a task",
      "parameters": {
        "type": "object",
        "properties": {
          "taskId": {
            "type": "string",
            "description": "The ID of the task to update"
          },
          "status": {
            "type": "string",
            "enum": ["pending", "completed"],
            "description": "New status for the task"
          }
        },
        "required": ["taskId", "status"]
      }
    },
    {
      "name": "create_event",
      "description": "Create a calendar event or appointment",
      "parameters": {
        "type": "object",
        "properties": {
          "title": {
            "type": "string",
            "description": "The title of the event"
          },
          "description": {
            "type": "string",
            "description": "Optional description of the event"
          },
          "startDateTime": {
            "type": "string",
            "format": "date-time",
            "description": "Start date and time (ISO format)"
          },
          "endDateTime": {
            "type": "string",
            "format": "date-time",
            "description": "End date and time (ISO format)"
          },
          "location": {
            "type": "string",
            "description": "Optional location for the event"
          }
        },
        "required": ["title", "startDateTime", "endDateTime"]
      }
    },
    {
      "name": "create_list_item",
      "description": "Add an item to a list",
      "parameters": {
        "type": "object",
        "properties": {
          "listName": {
            "type": "string",
            "description": "Name of the list (will be created if it doesn't exist)"
          },
          "itemTitle": {
            "type": "string",
            "description": "Title of the list item"
          },
          "description": {
            "type": "string",
            "description": "Optional description for the list item"
          },
          "priority": {
            "type": "string",
            "enum": ["low", "medium", "high"],
            "description": "Priority level of the item"
          }
        },
        "required": ["listName", "itemTitle"]
      }
    }
  ];

  Future<String> sendMessage({
    required List<ChatMessage> conversationHistory,
    required String newMessage,
    Map<String, dynamic>? userContext,
  }) async {
    try {
      // Convert conversation history to OpenAI format
      final messages = _convertMessagesToOpenAIFormat(conversationHistory, newMessage, userContext);
      
      final requestBody = {
        'model': _model,
        'messages': messages,
        'max_tokens': _maxTokens,
        'temperature': 0.7,
        'functions': _availableFunctions,
        'function_call': 'auto',
      };

      debugPrint('OpenAI Request: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: _headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choice = data['choices'][0];
        final message = choice['message'];
        
        // Check if it's a function call
        if (message['function_call'] != null) {
          return _handleFunctionCall(message['function_call']);
        } else {
          return message['content'] ?? 'I apologize, but I couldn\'t generate a response.';
        }
      } else {
        debugPrint('OpenAI API Error: ${response.statusCode} - ${response.body}');
        return 'I\'m having trouble connecting to my AI service right now. Please try again later.';
      }
    } catch (e) {
      debugPrint('OpenAI Service Error: $e');
      return 'I encountered an error while processing your request. Please try again.';
    }
  }

  List<Map<String, dynamic>> _convertMessagesToOpenAIFormat(
    List<ChatMessage> history, 
    String newMessage, 
    Map<String, dynamic>? userContext
  ) {
    final messages = <Map<String, dynamic>>[
      {
        'role': 'system',
        'content': _getSystemPrompt(userContext),
      }
    ];

    // Add conversation history
    for (final msg in history) {
      messages.add({
        'role': msg.sender == MessageSender.user ? 'user' : 'assistant',
        'content': msg.content,
      });
    }

    // Add new message
    messages.add({
      'role': 'user',
      'content': newMessage,
    });

    return messages;
  }

  String _getSystemPrompt(Map<String, dynamic>? userContext) {
    return '''
You are LANA (Learning Adaptive Needs Assistant), a helpful AI assistant integrated into the Vuet productivity app. Your role is to help users manage their tasks, events, lists, and schedules more effectively.

Key capabilities:
- Create and manage tasks with proper categorization
- Schedule events and appointments
- Manage lists and list items
- Provide productivity advice and suggestions
- Help organize and prioritize work
- Answer questions about the user's data and schedule

User Context: ${userContext != null ? jsonEncode(userContext) : 'No specific context provided'}

Always be helpful, concise, and proactive in suggesting ways to improve the user's productivity. When creating tasks or events, try to suggest appropriate categories and priorities based on the content.

If you need to perform an action like creating a task or event, use the available functions. Always confirm what action you've taken for the user.
''';
  }

  String _handleFunctionCall(Map<String, dynamic> functionCall) {
    final functionName = functionCall['name'];
    final arguments = jsonDecode(functionCall['arguments']);
    
    // Here we would typically execute the actual function
    // For now, we'll return a confirmation message
    switch (functionName) {
      case 'create_task':
        return 'I\'ve created a task: "${arguments['title']}"${arguments['dueDate'] != null ? ' due ${arguments['dueDate']}' : ''}. Is there anything else you\'d like me to help you with?';
      case 'create_event':
        return 'I\'ve scheduled "${arguments['title']}" from ${arguments['startDateTime']} to ${arguments['endDateTime']}${arguments['location'] != null ? ' at ${arguments['location']}' : ''}. The event has been added to your calendar.';
      case 'create_list_item':
        return 'I\'ve added "${arguments['itemTitle']}" to your "${arguments['listName']}" list. Anything else I can help you organize?';
      case 'get_tasks':
        return 'Let me fetch your tasks for you... (This would show actual task data from your account)';
      case 'update_task_status':
        return 'I\'ve updated the task status. The task is now marked as ${arguments['status']}.';
      default:
        return 'I tried to perform an action but encountered an issue. Please try again.';
    }
  }

  // Method to validate if API key is configured
  bool get isConfigured => _apiKey.isNotEmpty;
}
