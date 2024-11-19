import 'package:three_dot/features/project/data/model/project_timeline_model.dart';

class ProjectTimelineState {
  final bool isLoading;
  final ProjectTimelineModel? timeline;
  final String? error;

  const ProjectTimelineState({
    this.isLoading = false,
    this.timeline,
    this.error,
  });

  ProjectTimelineState copyWith({
    bool? isLoading,
    ProjectTimelineModel? timeline,
    String? error,
  }) {
    return ProjectTimelineState(
      isLoading: isLoading ?? this.isLoading,
      timeline: timeline ?? this.timeline,
      error: error ?? this.error,
    );
  }
}
