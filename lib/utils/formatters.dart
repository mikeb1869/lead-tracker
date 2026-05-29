import 'package:flutter/material.dart';
import '../models/lead.dart';

Color statusColor(LeadStatus status) {
  switch (status) {
    case LeadStatus.fresh:
      return Colors.blue;
    case LeadStatus.contacted:
      return Colors.orange;
    case LeadStatus.closed:
      return Colors.green;
    case LeadStatus.lost:
      return Colors.red;
  }
}

String formatEnum(String raw) {
  final spaced = raw.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[0]}');
  return spaced[0].toUpperCase() + spaced.substring(1);
}

String formatDate(DateTime dt) {
  return '${dt.month}/${dt.day}/${dt.year} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
