enum Author { user, bot }

class ChatMessage {
  final String id;
  final String text;
  final Author author;
  final bool isLoading;

  ChatMessage({
    required this.id,
    required this.text,
    required this.author,
    this.isLoading = false,
  });

  ChatMessage copyWith(
      {String? id, String? text, Author? author, bool? isLoading}) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
