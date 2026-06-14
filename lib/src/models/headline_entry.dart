class HeadlineEntry {
  const HeadlineEntry({
    required this.id,
    required this.person,
    required this.action,
    required this.conclusion,
    required this.asset,
    required this.createdAt,
  });

  final String id;
  final String person;
  final String action;
  final String conclusion;
  final String asset;
  final int createdAt;

  String get preview {
    final text = '$person $action $conclusion'.trim();
    return text.length > 120 ? '${text.substring(0, 117)}...' : text;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'person': person,
        'action': action,
        'conclusion': conclusion,
        'asset': asset,
        'createdAt': createdAt,
      };

  factory HeadlineEntry.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'] as int;
    return HeadlineEntry(
      id: json['id'] as String? ?? createdAt.toString(),
      person: json['person'] as String,
      action: json['action'] as String,
      conclusion: json['conclusion'] as String,
      asset: json['asset'] as String,
      createdAt: createdAt,
    );
  }

  static HeadlineEntry create({
    required String person,
    required String action,
    required String conclusion,
    required String asset,
  }) {
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    return HeadlineEntry(
      id: createdAt.toString(),
      person: person,
      action: action,
      conclusion: conclusion,
      asset: asset,
      createdAt: createdAt,
    );
  }
}
