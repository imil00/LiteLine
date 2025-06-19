// lib/models/conversation.dart
import 'package:liteline/models/message.dart'; // SESUAIKAN NAMA PAKET

class Conversation {
  final String id;
  final List<String> participantIds;
  final String? name;
  final String? imageUrl;
  final Message? lastMessage;

  Conversation({
    required this.id,
    required this.participantIds,
    this.name,
    this.imageUrl,
    this.lastMessage,
  });
}