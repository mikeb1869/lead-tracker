import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/lead.dart';

class LeadRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // --- READ (Automatic Updates) ---
  // Returns a stream of leads that updates in real-time.
  Stream<List<Lead>> getLeadsStream() {
    return _firestore
        .collection('leads')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Lead.fromMap(data);
          }).toList(),
        );
  }

  // --- WRITE / UPDATE / DELETE (Futures) ---
  // Add a new lead to Firestore
  Future<void> addLead(Lead lead) async {
    try {
      final id = _firestore.collection('leads').doc().id;
      final leadWithId = lead.copyWith(id: id);
      await _firestore.collection('leads').doc(id).set(leadWithId.toMap());
    } catch (e) {
      debugPrint("Error adding lead: $e");
      rethrow;
    }
  }

  // Update an existing lead in Firestore
  Future<void> updateLead(Lead lead) async {
    try {
      await _firestore.collection('leads').doc(lead.id).update(lead.toMap());
    } catch (e) {
      debugPrint('Error updating lead: $e');
      rethrow;
    }
  }

  // Delete a lead from Firestore
  Future<void> deleteLead(String leadId) async {
    try {
      await _firestore.collection('leads').doc(leadId).delete();
    } catch (e) {
      debugPrint('Error deleting lead: $e');
      rethrow;
    }
  }

  // --- FOLLOW-UPS ---

  Future<void> addFollowUp(FollowUp followUp) async {
    try {
      final id = _firestore
          .collection('leads')
          .doc(followUp.leadId)
          .collection('followups')
          .doc()
          .id;
      final followUpWithId = followUp.copyWith(id: id);
      await _firestore
          .collection('leads')
          .doc(followUp.leadId)
          .collection('followups')
          .doc(id)
          .set(followUpWithId.toMap());
    } catch (e) {
      debugPrint('Error adding follow-up: $e');
      rethrow;
    }
  }

  Stream<List<FollowUp>> getFollowUpsStream(String leadId) {
    return _firestore
        .collection('leads')
        .doc(leadId)
        .collection('followups')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            data['leadId'] = leadId;
            return FollowUp.fromMap(data);
          }).toList(),
        );
  }
}
