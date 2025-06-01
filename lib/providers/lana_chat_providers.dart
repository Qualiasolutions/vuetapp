import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/lana/chat_message_model.dart';
import '../services/enhanced_openai_service.dart';

// Enhanced OpenAI Assistant Service Provider
final enhancedOpenAIServiceProvider = Provider<EnhancedOpenAIService>((ref) {
  return EnhancedOpenAIService(ref: ref);
});

// Chat Session State
class ChatState {
  final ChatSession? currentSession;
  final bool isLoading;
  final String? error;
  final bool isTyping;

  const ChatState({
    this.currentSession,
    this.isLoading = false,
    this.error,
    this.isTyping = false,
  });

  ChatState copyWith({
    ChatSession? currentSession,
    bool? isLoading,
    String? error,
    bool? isTyping,
  }) {
    return ChatState(
      currentSession: currentSession ?? this.currentSession,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

// Chat State Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final EnhancedOpenAIService _enhancedOpenAIService;
  final Uuid _uuid = const Uuid();

  ChatNotifier(this._enhancedOpenAIService) : super(const ChatState()) {
    _initializeChat();
  }

  void _initializeChat() {
    final session = ChatSession(
      id: _uuid.v4(),
      title: 'Chat with LANA',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messages: [
        ChatMessage(
          id: _uuid.v4(),
          content: "Hi! I'm LANA, your personal productivity assistant. I can help you create tasks, schedule events, manage lists, and organize your workflow. What would you like to work on today?",
          sender: MessageSender.assistant,
          timestamp: DateTime.now(),
        ),
      ],
    );

    state = state.copyWith(currentSession: session);
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final currentSession = state.currentSession;
    if (currentSession == null) return;

    // Add user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: content,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...currentSession.messages, userMessage];
    final updatedSession = currentSession.copyWith(
      messages: updatedMessages,
      updatedAt: DateTime.now(),
    );

    state = state.copyWith(
      currentSession: updatedSession,
      isLoading: true,
      isTyping: true,
    );

    try {
      // Check if OpenAI service is configured
      if (!_enhancedOpenAIService.isConfigured) {
        throw Exception('OpenAI Assistant is not properly configured. Please check your API key and Assistant ID in the environment variables.');
      }

      // Get AI response using Assistant service
      final response = await _enhancedOpenAIService.sendMessage(
        message: content,
        userContext: _getUserContext(),
      );

      // Add assistant message
      final assistantMessage = ChatMessage(
        id: _uuid.v4(),
        content: response,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
      );

      final finalMessages = [...updatedMessages, assistantMessage];
      final finalSession = updatedSession.copyWith(
        messages: finalMessages,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        currentSession: finalSession,
        isLoading: false,
        isTyping: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isTyping: false,
        error: e.toString(),
      );
    }
  }

  Map<String, dynamic> _getUserContext() {
    // This would typically fetch user's current tasks, events, etc.
    // For now, return basic context
    return {
      'currentDate': DateTime.now().toIso8601String(),
      'timezone': DateTime.now().timeZoneName,
    };
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void startNewChat() {
    _enhancedOpenAIService.startNewConversation();
    _initializeChat();
  }

  // Get quick suggestions based on current context
  List<String> getQuickSuggestions() {
    return [
      "Create a task for today",
      "What do I have scheduled?",
      "Add items to my shopping list", 
      "Schedule a meeting",
      "Show my completed tasks",
      "Help me organize my day",
    ];
  }
}

// Main Chat Provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final enhancedOpenAIService = ref.watch(enhancedOpenAIServiceProvider);
  return ChatNotifier(enhancedOpenAIService);
});

// Convenience providers for UI
final currentChatSessionProvider = Provider<ChatSession?>((ref) {
  return ref.watch(chatProvider).currentSession;
});

final chatMessagesProvider = Provider<List<ChatMessage>>((ref) {
  final session = ref.watch(currentChatSessionProvider);
  return session?.messages ?? [];
});

final isChatLoadingProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).isLoading;
});

final isChatTypingProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).isTyping;
});

final chatErrorProvider = Provider<String?>((ref) {
  return ref.watch(chatProvider).error;
});

// Quick suggestions provider
final quickSuggestionsProvider = Provider<List<String>>((ref) {
  final chatNotifier = ref.watch(chatProvider.notifier);
  return chatNotifier.getQuickSuggestions();
});
