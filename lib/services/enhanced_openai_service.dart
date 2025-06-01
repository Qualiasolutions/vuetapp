import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../utils/web_environment.dart';
import '../models/task_model.dart';
import '../providers/integrated_task_providers.dart';
import '../providers/auth_providers.dart';

class EnhancedOpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  
  final String _apiKey;
  final String _assistantId;
  final Ref _ref;
  String? _threadId;

  EnhancedOpenAIService({
    required Ref ref,
    String? apiKey,
    String? assistantId,
  }) : 
    _ref = ref,
    _apiKey = apiKey ?? WebEnvironment.openaiApiKey ?? '',
    _assistantId = assistantId ?? 'asst_3IqsMAVMvzwsS88MuHHeFjnc';

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
      debugPrint('Enhanced OpenAI Service Error: $e');
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
    final user = _ref.read(currentUserProvider);
    final enhancedContext = {
      'currentDate': DateTime.now().toIso8601String(),
      'timezone': DateTime.now().timeZoneName,
      'userId': user?.id,
      'userEmail': user?.email,
      ...?userContext,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/threads/$threadId/runs'),
      headers: _headers,
      body: jsonEncode({
        'assistant_id': _assistantId,
        'additional_instructions': 'User Context: ${jsonEncode(enhancedContext)}',
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
        
        // Handle the function call with real implementation
        final result = await _handleFunctionCall(functionName, arguments);
        
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

  Future<String> _handleFunctionCall(String functionName, Map<String, dynamic> arguments) async {
    try {
      switch (functionName) {
        case 'create_task':
          return await _createTask(arguments);
        case 'get_tasks':
          return await _getTasks(arguments);
        case 'update_task_status':
          return await _updateTaskStatus(arguments);
        case 'create_event':
          return await _createEvent(arguments);
        case 'create_list_item':
          return await _createListItem(arguments);
        default:
          return 'Function $functionName is not implemented yet.';
      }
    } catch (e) {
      debugPrint('Error executing function $functionName: $e');
      return 'I encountered an error while executing that action. Please try again.';
    }
  }

  Future<String> _createTask(Map<String, dynamic> arguments) async {
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) throw Exception('User not authenticated');

      final taskRepository = _ref.read(integratedTaskRepositoryProvider);
      
      // Parse due date if provided
      DateTime? dueDate;
      if (arguments['dueDate'] != null) {
        try {
          dueDate = DateTime.parse(arguments['dueDate']);
        } catch (e) {
          // If parsing fails, try to parse relative dates
          final dueDateStr = arguments['dueDate'].toString().toLowerCase();
          if (dueDateStr.contains('today')) {
            dueDate = DateTime.now();
          } else if (dueDateStr.contains('tomorrow')) {
            dueDate = DateTime.now().add(const Duration(days: 1));
          } else if (dueDateStr.contains('next week')) {
            dueDate = DateTime.now().add(const Duration(days: 7));
          }
        }
      }

      final task = TaskModel(
        id: const Uuid().v4(),
        title: arguments['title'] ?? 'New Task',
        description: arguments['description'],
        dueDate: dueDate,
        priority: arguments['priority'] ?? 'medium',
        status: 'pending',
        isRecurring: false,
        categoryId: arguments['categoryId'],
        createdById: user.id,
        assignedToId: user.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await taskRepository.createTask(task);
      
      // Invalidate providers to refresh UI
      _ref.invalidate(integratedTasksProvider);
      
      final dueDateText = dueDate != null ? ' due ${_formatDate(dueDate)}' : '';
      return '✅ Task created successfully: "${task.title}"$dueDateText';
    } catch (e) {
      return 'Failed to create task: $e';
    }
  }

  Future<String> _getTasks(Map<String, dynamic> arguments) async {
    try {
      final taskRepository = _ref.read(integratedTaskRepositoryProvider);
      final tasks = await taskRepository.getTasks();
      
      // Apply filters if provided
      var filteredTasks = tasks;
      
      if (arguments['status'] != null) {
        filteredTasks = filteredTasks.where((task) => task.status == arguments['status']).toList();
      }
      
      if (arguments['dueDate'] != null) {
        final filterDate = DateTime.parse(arguments['dueDate']);
        filteredTasks = filteredTasks.where((task) => 
          task.dueDate != null && 
          task.dueDate!.year == filterDate.year &&
          task.dueDate!.month == filterDate.month &&
          task.dueDate!.day == filterDate.day
        ).toList();
      }

      if (filteredTasks.isEmpty) {
        return 'No tasks found matching your criteria.';
      }

      final taskList = filteredTasks.take(10).map((task) {
        final dueDateText = task.dueDate != null ? ' (due ${_formatDate(task.dueDate!)})' : '';
        final statusIcon = task.status == 'completed' ? '✅' : '⏳';
        return '$statusIcon ${task.title}$dueDateText';
      }).join('\n');

      final totalCount = filteredTasks.length;
      final showing = totalCount > 10 ? ' (showing first 10 of $totalCount)' : '';
      
      return 'Here are your tasks$showing:\n\n$taskList';
    } catch (e) {
      return 'Failed to retrieve tasks: $e';
    }
  }

  Future<String> _updateTaskStatus(Map<String, dynamic> arguments) async {
    try {
      final taskId = arguments['taskId'];
      final status = arguments['status'];
      
      if (taskId == null || status == null) {
        return 'Task ID and status are required.';
      }

      final taskRepository = _ref.read(integratedTaskRepositoryProvider);
      
      if (status == 'completed') {
        await taskRepository.completeTask(taskId);
      } else {
        // For other status updates, we'd need to implement updateTask method
        // For now, just handle completion
        return 'Only task completion is currently supported.';
      }
      
      // Invalidate providers to refresh UI
      _ref.invalidate(integratedTasksProvider);
      
      return '✅ Task marked as $status successfully!';
    } catch (e) {
      return 'Failed to update task status: $e';
    }
  }

  Future<String> _createEvent(Map<String, dynamic> arguments) async {
    try {
      // This would integrate with calendar providers when implemented
      final title = arguments['title'] ?? 'New Event';
      final startDateTime = arguments['startDateTime'];
      final endDateTime = arguments['endDateTime'];
      final location = arguments['location'];
      
      // For now, return a confirmation message
      // In the future, this would create an actual calendar event
      final locationText = location != null ? ' at $location' : '';
      return '📅 Event scheduled: "$title" from $startDateTime to $endDateTime$locationText\n\n(Note: Calendar integration coming soon!)';
    } catch (e) {
      return 'Failed to create event: $e';
    }
  }

  Future<String> _createListItem(Map<String, dynamic> arguments) async {
    try {
      // This would integrate with list providers when implemented
      final itemTitle = arguments['itemTitle'] ?? 'New Item';
      final listName = arguments['listName'] ?? 'Default List';
      
      // For now, return a confirmation message
      // In the future, this would create an actual list item
      return '📝 Added "$itemTitle" to "$listName" list\n\n(Note: List integration coming soon!)';
    } catch (e) {
      return 'Failed to create list item: $e';
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);
    
    if (targetDate == today) {
      return 'today';
    } else if (targetDate == tomorrow) {
      return 'tomorrow';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  // Start a new conversation thread
  void startNewConversation() {
    _threadId = null;
  }

  // Method to validate if assistant is configured
  bool get isConfigured => _apiKey.isNotEmpty && _assistantId.isNotEmpty;
}
