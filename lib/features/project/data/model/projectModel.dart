class ProjectModel {
  final int inquiryId;
  final int statusId;
  final String latestStatus;
  final String amountCollected;
  final String amountPending;
  final bool subsidyStatus;
  final int id;
  final DateTime? feasibilityApprovalDate;
  final DateTime? agreementUploadDate;
  final DateTime? installationDate;
  final DateTime? commissioningDate;
  final DateTime? aeApprovalDate;
  final DateTime? bankDetailsSubmissionDate;
  final DateTime? projectCompletionDate;
  final DateTime? createdAt;
  final DateTime? lastUpdated;

  ProjectModel({
    required this.inquiryId,
    required this.statusId,
    required this.latestStatus,
    required this.amountCollected,
    required this.amountPending,
    required this.subsidyStatus,
    required this.id,
    this.feasibilityApprovalDate,
    this.agreementUploadDate,
    this.installationDate,
    this.commissioningDate,
    this.aeApprovalDate,
    this.bankDetailsSubmissionDate,
    this.projectCompletionDate,
    this.createdAt,
    this.lastUpdated,
  });

  // Factory method to create a ProjectModel from JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      inquiryId: json['inquiry_id'] ?? 0, // Default to 0 if null
      statusId: json['status_id'] ?? 0, // Default to 0 if null
      latestStatus:
          json['latest_status'] ?? '', // Default to empty string if null
      amountCollected: json['amount_collected']?.toString() ??
          '0.00', // Convert to string if null
      amountPending: json['amount_pending']?.toString() ??
          '0.00', // Convert to string if null
      subsidyStatus:
          json['subsidy_status'] ?? false, // Default to false if null
      id: json['id'] ?? 0, // Default to 0 if null
      feasibilityApprovalDate: json['feasibility_approval_date'] != null
          ? DateTime.parse(json['feasibility_approval_date'])
          : null,
      agreementUploadDate: json['agreement_upload_date'] != null
          ? DateTime.parse(json['agreement_upload_date'])
          : null,
      installationDate: json['installation_date'] != null
          ? DateTime.parse(json['installation_date'])
          : null,
      commissioningDate: json['commissioning_date'] != null
          ? DateTime.parse(json['commissioning_date'])
          : null,
      aeApprovalDate: json['ae_approval_date'] != null
          ? DateTime.parse(json['ae_approval_date'])
          : null,
      bankDetailsSubmissionDate: json['bank_details_submission_date'] != null
          ? DateTime.parse(json['bank_details_submission_date'])
          : null,
      projectCompletionDate: json['project_completion_date'] != null
          ? DateTime.parse(json['project_completion_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : null,
    );
  }

  // Method to convert the ProjectModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'inquiry_id': inquiryId,
      'status_id': statusId,
      'latest_status': latestStatus,
      'amount_collected': amountCollected,
      'amount_pending': amountPending,
      'subsidy_status': subsidyStatus,
      'id': id,
      'feasibility_approval_date': feasibilityApprovalDate?.toIso8601String(),
      'agreement_upload_date': agreementUploadDate?.toIso8601String(),
      'installation_date': installationDate?.toIso8601String(),
      'commissioning_date': commissioningDate?.toIso8601String(),
      'ae_approval_date': aeApprovalDate?.toIso8601String(),
      'bank_details_submission_date':
          bankDetailsSubmissionDate?.toIso8601String(),
      'project_completion_date': projectCompletionDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }
}
