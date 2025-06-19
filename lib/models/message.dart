// lib/models/message.dart
enum MessageType { text, image, audio, video, callEvent }
class Message {
  final String id;
  final String senderId;
  final String conversationId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final String? status;

  Message({
    required this.id,
    required this.senderId,
    required this.conversationId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.status,
  });
}