import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/web_environment.dart';

class OpenAIAssistantService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  
  final String _apiKey;
  final String _assistantId;
  String? _threadId;

  OpenAIAssistantService({
    String? apiKey,
    String? assistantId,
  }) : 
    _apiKey = apiKey ?? WebEnvironment.openaiApiKey ?? '',
    _assistantId = assistantId ?? WebEnvironment.openaiAssistantId ?? '';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_apiKey',
    'Content-Type': 'application/json',
    'OpenAI-Beta': 'assistants=v2',
  };

  // Initialize or get existing thread
  Future<String> _getOrCreateThread() async {
    if (_threadId != null) return _threadId!;
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/threads'),
        headers: _headers,
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _threadId = data['id'];
        return _threadId!;
      } else {
        throw Exception('Failed to create thread: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error creating thread: $e');
      rethrow;
    }
  }

  Future<String> sendMessage({
    required String message,
    Map<String, dynamic>? userContext,
  }) async {
    try {
      // Get or create thread
      final threadId = await _getOrCreateThread();
      
      // Add message to thread
      await _addMessageToThread(threadId, message);
      
      // Run the assistant
      final runId = await _runAssistant(threadId, userContext);
      
      // Wait for completion and get response
      final response = await _waitForRunCompletion(threadId, runId);
      
      return response;
    } catch (e) {
      debugPrint('OpenAI Assistant Service Error: $e');
      return 'I encountered an error while processing your request. Please try again.';
    }
  }

  Future<void> _addMessageToThread(String threadId, String message) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/threads/$threadId/messages'),
      headers: _headers,
      body: jsonEncode({
        'role': 'user',
        'content': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add message: ${response.body}');
    }
  }

  Future<String> _runAssistant(String threadId, Map<String, dynamic>? userContext) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/threads/$threadId/runs'),
      headers: _headers,
      body: jsonEncode({
        'assistant_id': _assistantId,
        'additional_instructions': userContext != null 
            ? 'User Context: ${jsonEncode(userContext)}'
            : null,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Failed to run assistant: ${response.body}');
    }
  }

  Future<String> _waitForRunCompletion(String threadId, String runId) async {
    while (true) {
      final response = await http.get(
        Uri.parse('$_baseUrl/threads/$threadId/runs/$runId'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get run status: ${response.body}');
      }

      final data = jsonDecode(response.body);
      final status = data['status'];

      switch (status) {
        case 'completed':
          return await _getLatestMessage(threadId);
        case 'requires_action':
          await _handleRequiredAction(threadId, runId, data);
          break;
        case 'failed':
        case 'cancelled':
        case 'expired':
          throw Exception('Run failed with status: $status');
        case 'queued':
        case 'in_progress':
        case 'cancelling':
          // Wait a bit before checking again
          await Future.delayed(const Duration(milliseconds: 1000));
          break;
      }
    }
  }

  Future<void> _handleRequiredAction(String threadId, String runId, Map<String, dynamic> runData) async {
    final requiredAction = runData['required_action'];
    if (requiredAction['type'] == 'submit_tool_outputs') {
      final toolCalls = requiredAction['submit_tool_outputs']['tool_calls'];
      final toolOutputs = <Map<String, dynamic>>[];

      for (final toolCall in toolCalls) {
        final functionName = toolCall['function']['name'];
        final arguments = jsonDecode(toolCall['function']['arguments']);
        
        // Handle the function call
        final result = _handleFunctionCall(functionName, arguments);
        
        toolOutputs.add({
          'tool_call_id': toolCall['id'],
          'output': result,
        });
      }

      // Submit tool outputs
      await http.post(
        Uri.parse('$_baseUrl/threads/$threadId/runs/$runId/submit_tool_outputs'),
        headers: _headers,
        body: jsonEncode({
          'tool_outputs': toolOutputs,
        }),
      );
    }
  }

  String _handleFunctionCall(String functionName, Map<String, dynamic> arguments) {
    // Here we would typically execute the actual function
    // For now, we'll return a confirmation message
    switch (functionName) {
      case 'create_task':
        return 'Task created: "${arguments['title']}"${arguments['dueDate'] != null ? ' due ${arguments['dueDate']}' : ''}';
      case 'create_event':
        return 'Event scheduled: "${arguments['title']}" from ${arguments['startDateTime']} to ${arguments['endDateTime']}${arguments['location'] != null ? ' at ${arguments['location']}' : ''}';
      case 'create_list_item':
        return 'Added "${arguments['itemTitle']}" to "${arguments['listName']}" list';
      case 'get_tasks':
        return 'Retrieved tasks (filtered by: ${arguments.toString()})';
      case 'update_task_status':
        return 'Task ${arguments['taskId']} marked as ${arguments['status']}';
      default:
        return 'Function $functionName executed with arguments: ${arguments.toString()}';
    }
  }

  Future<String> _getLatestMessage(String threadId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/threads/$threadId/messages?limit=1'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final messages = data['data'];
      if (messages.isNotEmpty) {
        final latestMessage = messages[0];
        if (latestMessage['role'] == 'assistant') {
          final content = latestMessage['content'];
          if (content.isNotEmpty && content[0]['type'] == 'text') {
            return content[0]['text']['value'];
          }
        }
      }
    }
    
    return 'I apologize, but I couldn\'t generate a response.';
  }

  // Start a new conversation thread
  void startNewConversation() {
    _threadId = null;
  }

  // Method to validate if assistant is configured
  bool get isConfigured => _apiKey.isNotEmpty && _assistantId.isNotEmpty;
}
