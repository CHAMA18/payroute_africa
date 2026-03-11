import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:payroute_desktop/models/organization_application_model.dart';

class OrganizationApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'organization_applications';

  Future<OrganizationApplicationModel?> getApplicationById(String applicationId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(applicationId).get();
      if (doc.exists && doc.data() != null) {
        return OrganizationApplicationModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('OrganizationApplicationService.getApplicationById error: $e');
      rethrow;
    }
  }

  Future<List<OrganizationApplicationModel>> getApplicationsByUserId(String userId) async {
    try {
      final query = await _firestore
          .collection(_collectionName)
          .where('user_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .limit(50)
          .get();
      
      return query.docs
          .map((doc) => OrganizationApplicationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('OrganizationApplicationService.getApplicationsByUserId error: $e');
      rethrow;
    }
  }

  Future<String> createApplication(OrganizationApplicationModel application) async {
    try {
      final docRef = await _firestore.collection(_collectionName).add(application.toJson());
      await docRef.update({'id': docRef.id});
      return docRef.id;
    } catch (e) {
      debugPrint('OrganizationApplicationService.createApplication error: $e');
      rethrow;
    }
  }

  Future<void> updateApplication(OrganizationApplicationModel application) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(application.id)
          .update(application.toJson());
    } catch (e) {
      debugPrint('OrganizationApplicationService.updateApplication error: $e');
      rethrow;
    }
  }

  Future<void> updateApplicationStatus(String applicationId, String status) async {
    try {
      await _firestore.collection(_collectionName).doc(applicationId).update({
        'status': status,
        'updated_at': Timestamp.now(),
      });
    } catch (e) {
      debugPrint('OrganizationApplicationService.updateApplicationStatus error: $e');
      rethrow;
    }
  }

  Future<void> deleteApplication(String applicationId) async {
    try {
      await _firestore.collection(_collectionName).doc(applicationId).delete();
    } catch (e) {
      debugPrint('OrganizationApplicationService.deleteApplication error: $e');
      rethrow;
    }
  }

  Stream<List<OrganizationApplicationModel>> watchUserApplications(String userId) {
    return _firestore
        .collection(_collectionName)
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrganizationApplicationModel.fromJson(doc.data()))
          .toList();
    });
  }
}
