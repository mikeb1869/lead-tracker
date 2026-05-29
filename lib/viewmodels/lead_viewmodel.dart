import 'dart:async';
import 'package:flutter/foundation.dart';
import '../repositories/lead_repository.dart';
import '../models/lead.dart';

class LeadViewModel extends ValueNotifier<List<Lead>> {
  final LeadRepository leadRepository;
  late final StreamSubscription<List<Lead>> _leadsSubscription;

  LeadViewModel({required this.leadRepository}) : super([]) {
    _leadsSubscription = leadRepository.getLeadsStream().listen((leads) {
      value = leads;
    });
  }

  @override
  void dispose() {
    _leadsSubscription.cancel();
    super.dispose();
  }

  Future<void> addLead(Lead lead) async {
    try {
      await leadRepository.addLead(lead);
    } catch (e) {
      debugPrint('Error adding lead: $e');
    }
  }

  Future<void> updateLead(Lead lead) async {
    try {
      await leadRepository.updateLead(lead);
    } catch (e) {
      debugPrint('Error updating lead: $e');
    }
  }

  Future<void> deleteLead(String leadId) async {
    try {
      await leadRepository.deleteLead(leadId);
    } catch (e) {
      debugPrint('Error deleting lead: $e');
    }
  }

  Future<void> addFollowUp(FollowUp followUp) async {
    try {
      await leadRepository.addFollowUp(followUp);
    } catch (e) {
      debugPrint('Error adding follow-up: $e');
    }
  }

  Stream<List<FollowUp>> getFollowUpsStream(String leadId) {
    return leadRepository.getFollowUpsStream(leadId);
  }
}
