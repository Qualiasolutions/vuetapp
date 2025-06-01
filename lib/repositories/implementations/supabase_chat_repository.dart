import 'package:vuet_app/models/lana/chat_message_model.dart';
import 'package:vuet_app/repositories/chat_repository.dart';
import 'package:vuet_app/config/supabase_config.dart';

/// Supabase implementation of ChatRepository
class SupabaseChatRepository implements ChatRepository {
  final _client = SupabaseConfig.client;

  @override
  Future<List<ChatSession>> getUserChatSessions(String userId) async {
    try {
      final response = await _client
          .from('chat_sessions')
          .select('*, chat_messages(*)')
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return (response as List)
          .map((json) => ChatSession.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user chat sessions: $e');
    }
  }

  @override
  Future<ChatSession?> getChatSession(String sessionId) async {
    try {
      final response = await _client
          .from('chat_sessions')
          .select('*, chat_messages(*)')
          .eq('id', sessionId)
          .single();

      return ChatSession.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ChatSession> createChatSession(String userId, String title) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      final response = await _client
          .from('chat_sessions')
          .insert({
            'user_id': userId,
            'title': title,
            'created_at': now,
            'updated_at': now,
          })
          .select()
          .single();

      // Return session with empty messages list
      return ChatSession.fromJson({
        ...response,
        'chat_messages': [],
      });
    } catch (e) {
      throw Exception('Failed to create chat session: $e');
    }
  }

  @override
  Future<void> updateChatSession(ChatSession session) async {
    try {
      await _client
          .from('chat_sessions')
          .update({
            'title': session.title,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', session.id);
    } catch (e) {
      throw Exception('Failed to update chat session: $e');
    }
  }

  @override
  Future<void> deleteChatSession(String sessionId) async {
    try {
      // Delete messages first (cascade should handle this, but being explicit)
      await _client
          .from('chat_messages')
          .delete()
          .eq('session_id', sessionId);

      // Delete session
      await _client
          .from('chat_sessions')
          .delete()
          .eq('id', sessionId);
    } catch (e) {
      throw Exception('Failed to delete chat session: $e');
    }
  }

  @override
  Future<List<ChatMessage>> getSessionMessages(String sessionId) async {
    try {
      final response = await _client
          .from('chat_messages')
          .select()
          .eq('session_id', sessionId)
          .order('timestamp', ascending: true);

      return (response as List)
          .map((json) => ChatMessage.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get session messages: $e');
    }
  }

  @override
  Future<ChatMessage> addMessage(ChatMessage message) async {
    try {
      final messageData = {
        'id': message.id,
        'session_id': _extractSessionId(message),
        'content': message.content,
        'sender': message.sender.name,
        'timestamp': message.timestamp.toIso8601String(),
        'type': message.type.name,
        'function_call': message.functionCall,
        'metadata': message.metadata,
        'is_processing': message.isProcessing,
      };

      final response = await _client
          .from('chat_messages')
          .insert(messageData)
          .select()
          .single();

      // Update session's updated_at timestamp
      await _client
          .from('chat_sessions')
          .update({'updated_at': DateTime.now().toIso8601String()})
          .eq('id', _extractSessionId(message));

      return ChatMessage.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add message: $e');
    }
  }

  @override
  Future<void> updateMessage(ChatMessage message) async {
    try {
      await _client
          .from('chat_messages')
          .update({
            'content': message.content,
            'function_call': message.functionCall,
            'metadata': message.metadata,
            'is_processing': message.isProcessing,
          })
          .eq('id', message.id);
    } catch (e) {
      throw Exception('Failed to update message: $e');
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    try {
      await _client
          .from('chat_messages')
          .delete()
          .eq('id', messageId);
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  @override
  Future<void> clearSessionMessages(String sessionId) async {
    try {
      await _client
          .from('chat_messages')
          .delete()
          .eq('session_id', sessionId);
    } catch (e) {
      throw Exception('Failed to clear session messages: $e');
    }
  }

  /// Extract session ID from message metadata or context
  String _extractSessionId(ChatMessage message) {
    // Try to get session ID from metadata first
    if (message.metadata != null && message.metadata!.containsKey('session_id')) {
      return message.metadata!['session_id'] as String;
    }
    
    // If not in metadata, we'll need to pass it differently
    // For now, throw an error to indicate this needs to be handled
    throw Exception('Session ID not found in message metadata');
  }
}
