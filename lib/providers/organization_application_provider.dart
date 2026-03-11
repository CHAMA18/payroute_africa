import 'package:flutter/foundation.dart';
import 'package:payroute_desktop/models/organization_application_model.dart';
import 'package:payroute_desktop/services/organization_application_service.dart';

/// Provider to manage organization application state across all onboarding steps
class OrganizationApplicationProvider extends ChangeNotifier {
  final OrganizationApplicationService _service = OrganizationApplicationService();

  // Step 1: Entity Details
  String _entityType = 'fintech';
  String? _incorporationDocumentUrl;

  // Step 2: Authorized Representative
  String _authorizedRepName = '';
  DateTime? _authorizedRepDob;
  String _authorizedRepPosition = '';
  String _authorizedRepIdType = 'nationalId';

  // Step 3: Beneficial Owners
  List<BeneficialOwnerDraft> _beneficialOwners = [BeneficialOwnerDraft()];

  // Submission state
  bool _isSubmitting = false;
  String? _submissionError;
  String? _applicationId;

  // Getters for Step 1
  String get entityType => _entityType;
  String? get incorporationDocumentUrl => _incorporationDocumentUrl;

  // Getters for Step 2
  String get authorizedRepName => _authorizedRepName;
  DateTime? get authorizedRepDob => _authorizedRepDob;
  String get authorizedRepPosition => _authorizedRepPosition;
  String get authorizedRepIdType => _authorizedRepIdType;

  // Getters for Step 3
  List<BeneficialOwnerDraft> get beneficialOwners => _beneficialOwners;

  // Getters for submission state
  bool get isSubmitting => _isSubmitting;
  String? get submissionError => _submissionError;
  String? get applicationId => _applicationId;

  // Step 1: Update entity details
  void updateEntityDetails({
    required String entityType,
    String? incorporationDocumentUrl,
  }) {
    _entityType = entityType;
    _incorporationDocumentUrl = incorporationDocumentUrl;
    debugPrint('OrganizationApplicationProvider: Updated entity details - type=$_entityType, docUrl=$_incorporationDocumentUrl');
    notifyListeners();
  }

  // Step 2: Update authorized representative
  void updateAuthorizedRep({
    required String fullName,
    required DateTime? dob,
    required String position,
    required String idType,
  }) {
    _authorizedRepName = fullName;
    _authorizedRepDob = dob;
    _authorizedRepPosition = position;
    _authorizedRepIdType = idType;
    debugPrint('OrganizationApplicationProvider: Updated authorized rep - name=$_authorizedRepName, dob=$_authorizedRepDob, position=$_authorizedRepPosition, idType=$_authorizedRepIdType');
    notifyListeners();
  }

  // Step 3: Update beneficial owners
  void updateBeneficialOwners(List<BeneficialOwnerDraft> owners) {
    _beneficialOwners = owners;
    debugPrint('OrganizationApplicationProvider: Updated beneficial owners - count=${_beneficialOwners.length}');
    notifyListeners();
  }

  void addBeneficialOwner() {
    _beneficialOwners.add(BeneficialOwnerDraft());
    notifyListeners();
  }

  void removeBeneficialOwner(int index) {
    if (_beneficialOwners.length > 1) {
      _beneficialOwners.removeAt(index);
      notifyListeners();
    }
  }

  void updateBeneficialOwnerAt(int index, BeneficialOwnerDraft owner) {
    if (index >= 0 && index < _beneficialOwners.length) {
      _beneficialOwners[index] = owner;
      notifyListeners();
    }
  }

  // Helper to get entity type display name
  String get entityTypeDisplayName {
    switch (_entityType) {
      case 'fintech':
        return 'Fintech';
      case 'neobank':
        return 'Neobank';
      case 'remittance':
        return 'Remittance';
      case 'enterprise':
        return 'Enterprise';
      default:
        return _entityType;
    }
  }

  // Helper to get ID type display name
  String get idTypeDisplayName {
    switch (_authorizedRepIdType) {
      case 'nationalId':
        return 'National ID Card';
      case 'passport':
        return 'International Passport';
      case 'driversLicense':
        return 'Driver\'s License';
      default:
        return _authorizedRepIdType;
    }
  }

  // Submit application to Firestore
  Future<bool> submitApplication(String userId) async {
    _isSubmitting = true;
    _submissionError = null;
    notifyListeners();

    try {
      // Validate required fields
      if (_authorizedRepName.isEmpty) {
        throw Exception('Authorized representative name is required');
      }
      if (_authorizedRepDob == null) {
        throw Exception('Authorized representative date of birth is required');
      }
      if (_authorizedRepPosition.isEmpty) {
        throw Exception('Authorized representative position is required');
      }
      if (_beneficialOwners.isEmpty) {
        throw Exception('At least one beneficial owner is required');
      }

      // Convert draft owners to model
      final owners = _beneficialOwners
          .where((o) => o.fullName.isNotEmpty)
          .map((o) => BeneficialOwner(
                fullName: o.fullName,
                ownershipPercent: double.tryParse(o.ownershipPercent) ?? 0.0,
                nationality: o.nationality,
              ))
          .toList();

      if (owners.isEmpty) {
        throw Exception('At least one beneficial owner with a name is required');
      }

      final now = DateTime.now();
      final application = OrganizationApplicationModel(
        id: '', // Will be set by Firestore
        userId: userId,
        entityType: _entityType,
        incorporationDocumentUrl: _incorporationDocumentUrl,
        authorizedRepName: _authorizedRepName,
        authorizedRepDob: _authorizedRepDob!,
        authorizedRepPosition: _authorizedRepPosition,
        authorizedRepIdType: _authorizedRepIdType,
        beneficialOwners: owners,
        status: 'pending_review',
        createdAt: now,
        updatedAt: now,
      );

      _applicationId = await _service.createApplication(application);
      debugPrint('OrganizationApplicationProvider: Application submitted successfully with id=$_applicationId');

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('OrganizationApplicationProvider.submitApplication error: $e');
      _submissionError = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // Reset all data (for starting a new application)
  void reset() {
    _entityType = 'fintech';
    _incorporationDocumentUrl = null;
    _authorizedRepName = '';
    _authorizedRepDob = null;
    _authorizedRepPosition = '';
    _authorizedRepIdType = 'nationalId';
    _beneficialOwners = [BeneficialOwnerDraft()];
    _isSubmitting = false;
    _submissionError = null;
    _applicationId = null;
    notifyListeners();
  }

  void clearError() {
    _submissionError = null;
    notifyListeners();
  }
}

/// Draft model for beneficial owner during form editing
class BeneficialOwnerDraft {
  String fullName;
  String ownershipPercent;
  String nationality;

  BeneficialOwnerDraft({
    this.fullName = '',
    this.ownershipPercent = '',
    this.nationality = '',
  });

  BeneficialOwnerDraft copyWith({
    String? fullName,
    String? ownershipPercent,
    String? nationality,
  }) => BeneficialOwnerDraft(
    fullName: fullName ?? this.fullName,
    ownershipPercent: ownershipPercent ?? this.ownershipPercent,
    nationality: nationality ?? this.nationality,
  );
}
