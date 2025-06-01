import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

enum MessageType {
  text,
  functionCall,
  system,
}

enum MessageSender {
  user,
  assistant,
  system,
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String content,
    required MessageSender sender,
    required DateTime timestamp,
    @Default(MessageType.text) MessageType type,
    Map<String, dynamic>? functionCall,
    Map<String, dynamic>? metadata,
    @Default(false) bool isProcessing,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

@freezed
class FunctionCall with _$FunctionCall {
  const factory FunctionCall({
    required String name,
    required Map<String, dynamic> arguments,
    String? result,
    @Default(false) bool isCompleted,
    String? error,
  }) = _FunctionCall;

  factory FunctionCall.fromJson(Map<String, dynamic> json) =>
      _$FunctionCallFromJson(json);
}

@freezed
class ChatSession with _$ChatSession {
  const factory ChatSession({
    required String id,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<ChatMessage> messages,
    Map<String, dynamic>? context,
  }) = _ChatSession;

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);
}
