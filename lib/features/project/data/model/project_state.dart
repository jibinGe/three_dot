import 'package:three_dot/features/project/data/model/projectModel.dart';

class ProjectState {
  final bool isLoading;
  final List<ProjectModel> projects;
  final ProjectModel? selectedProject;
  final String? error;

  const ProjectState({
    this.isLoading = false,
    this.projects = const [],
    this.selectedProject,
    this.error,
  });

  ProjectState copyWith({
    bool? isLoading,
    List<ProjectModel>? projects,
    ProjectModel? selectedProject,
    String? error,
  }) {
    return ProjectState(
      isLoading: isLoading ?? this.isLoading,
      projects: projects ?? this.projects,
      selectedProject: selectedProject ?? this.selectedProject,
      error: error ?? this.error,
    );
  }
}
