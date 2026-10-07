class Note {
  final String? id;
  final String? note;
  final String? addedBy;
  final DateTime? createdAt;

  Note({
    this.id,
    this.note,
    this.addedBy,
    this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'],
      note: json['note'],
      addedBy: json['addedBy'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'note': note,
      'addedBy': addedBy,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class NotesData {
  final List<Note>? notes;
  final DateTime? updatedAt;

  NotesData({
    List<Note>? notes,
    this.updatedAt,
  }) : notes = notes ?? [];

  factory NotesData.fromJson(Map<String, dynamic> json) {
    return NotesData(
      notes: json['notes'] != null
          ? (json['notes'] as List)
              .map((e) => Note.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notes': notes?.map((e) => e.toJson()).toList(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
