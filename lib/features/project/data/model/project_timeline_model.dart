class ProjectTimelineModel {
  final int projectId;
  final CurrentStatus currentStatus;
  final List<Stage> nextStages;
  final List<HistoryItem> history;
  final ImportantDates importantDates;

  ProjectTimelineModel({
    required this.projectId,
    required this.currentStatus,
    required this.nextStages,
    required this.history,
    required this.importantDates,
  });

  factory ProjectTimelineModel.fromJson(Map<String, dynamic> json) {
    return ProjectTimelineModel(
      projectId: json['project_id'],
      currentStatus: CurrentStatus.fromJson(json['current_status']),
      nextStages: (json['next_stages'] as List)
          .map((stage) => Stage.fromJson(stage))
          .toList(),
      history: (json['history'] as List)
          .map((item) => HistoryItem.fromJson(item))
          .toList(),
      importantDates: ImportantDates.fromJson(json['important_dates']),
    );
  }
}

class CurrentStatus {
  final int stageId;
  final String stageName;
  final String status;

  CurrentStatus({
    required this.stageId,
    required this.stageName,
    required this.status,
  });

  factory CurrentStatus.fromJson(Map<String, dynamic> json) {
    return CurrentStatus(
      stageId: json['stage_id'],
      stageName: json['stage_name'],
      status: json['status'],
    );
  }
}

class Stage {
  final int stageId;
  final String stageName;
  final String status;

  Stage({
    required this.stageId,
    required this.stageName,
    required this.status,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      stageId: json['stage_id'],
      stageName: json['stage_name'],
      status: json['status'],
    );
  }
}

class HistoryItem {
  final int stageId;
  final String stageName;
  final DateTime date;
  final String remarks;
  final int updatedBy;

  HistoryItem({
    required this.stageId,
    required this.stageName,
    required this.date,
    required this.remarks,
    required this.updatedBy,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      stageId: json['stage_id'],
      stageName: json['stage_name'],
      date: DateTime.parse(json['date']),
      remarks: json['remarks'],
      updatedBy: json['updated_by'],
    );
  }
}

class ImportantDates {
  final DateTime? feasibilityApproval;
  final DateTime? agreementUpload;
  final DateTime? installation;
  final DateTime? commissioning;
  final DateTime? completion;

  ImportantDates({
    this.feasibilityApproval,
    this.agreementUpload,
    this.installation,
    this.commissioning,
    this.completion,
  });

  factory ImportantDates.fromJson(Map<String, dynamic> json) {
    return ImportantDates(
      feasibilityApproval: json['feasibility_approval'] != null
          ? DateTime.parse(json['feasibility_approval'])
          : null,
      agreementUpload: json['agreement_upload'] != null
          ? DateTime.parse(json['agreement_upload'])
          : null,
      installation: json['installation'] != null
          ? DateTime.parse(json['installation'])
          : null,
      commissioning: json['commissioning'] != null
          ? DateTime.parse(json['commissioning'])
          : null,
      completion: json['completion'] != null
          ? DateTime.parse(json['completion'])
          : null,
    );
  }
}
