import 'package:vuet_app/models/lana/chat_message_model.dart';

/// Repository interface for chat persistence
abstract class ChatRepository {
  /// Get all chat sessions for a user
  Future<List<ChatSession>> getUserChatSessions(String userId);
  
  /// Get a specific chat session by ID
  Future<ChatSession?> getChatSession(String sessionId);
  
  /// Create a new chat session
  Future<ChatSession> createChatSession(String userId, String title);
  
  /// Update a chat session
  Future<void> updateChatSession(ChatSession session);
  
  /// Delete a chat session
  Future<void> deleteChatSession(String sessionId);
  
  /// Get messages for a chat session
  Future<List<ChatMessage>> getSessionMessages(String sessionId);
  
  /// Add a message to a chat session
  Future<ChatMessage> addMessage(ChatMessage message);
  
  /// Update a message
  Future<void> updateMessage(ChatMessage message);
  
  /// Delete a message
  Future<void> deleteMessage(String messageId);
  
  /// Clear all messages in a session
  Future<void> clearSessionMessages(String sessionId);
}
