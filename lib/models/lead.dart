enum LeadStatus { fresh, contacted, closed, lost }

enum LeadChannel { website, socialMedia, sms, email, phone }

class Lead {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String message;
  final LeadChannel channel;
  final DateTime timestamp;
  final LeadStatus status;

  Lead({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.message,
    required this.channel,
    required this.timestamp,
    required this.status,
  });

  factory Lead.fromMap(Map<String, dynamic> map) {
    return Lead(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      message: map['message'],
      channel: LeadChannel.values.byName(map['channel']),
      timestamp: DateTime.parse(map['timestamp']),
      status: LeadStatus.values.byName(map['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'message': message,
      'channel': channel.name,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
    };
  }

  Lead copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? message,
    LeadChannel? channel,
    DateTime? timestamp,
    LeadStatus? status,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      message: message ?? this.message,
      channel: channel ?? this.channel,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

class FollowUp {
  final String id;
  final String leadId;
  final DateTime timestamp;
  final LeadChannel channel;
  final bool responded;
  final String note;

  FollowUp({
    required this.id,
    required this.leadId,
    required this.timestamp,
    required this.channel,
    required this.responded,
    this.note = '',
  });

  factory FollowUp.fromMap(Map<String, dynamic> map) {
    return FollowUp(
      id: map['id'],
      leadId: map['leadId'],
      timestamp: DateTime.parse(map['timestamp']),
      channel: LeadChannel.values.byName(map['channel']),
      responded: map['responded'],
      note: map['note'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'channel': channel.name,
      'responded': responded,
      'note': note,
    };
  }

  FollowUp copyWith({
    String? id,
    String? leadId,
    DateTime? timestamp,
    LeadChannel? channel,
    bool? responded,
    String? note,
  }) {
    return FollowUp(
      id: id ?? this.id,
      leadId: leadId ?? this.leadId,
      timestamp: timestamp ?? this.timestamp,
      channel: channel ?? this.channel,
      responded: responded ?? this.responded,
      note: note ?? this.note,
    );
  }
}
