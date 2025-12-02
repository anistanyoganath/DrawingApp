class AiResponseModel {
  final String createdAt;
  final String content;
  final bool done;
  final int totalDuration;

  AiResponseModel({
    required this.createdAt,
    required this.content,
    required this.done,
    required this.totalDuration,
  });

  factory AiResponseModel.fromJson(Map<String, dynamic> json) {
    return AiResponseModel(
      createdAt: json['created_at'] ?? '',
      content: json['content'] ?? '',
      done: json['done'] is bool
          ? json['done']
          : json['done'].toString() == 'true',
      totalDuration: json['totalDuration'] is int
          ? json['totalDuration']
          : int.tryParse(json['totalDuration'].toString()) ?? 0,
    );
  }
}
