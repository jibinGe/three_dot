import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/project/data/model/project_state.dart';
import 'package:three_dot/features/project/data/model/project_timeline_state.dart';
import 'package:three_dot/features/project/data/repositories/project_repository.dart';

final projectRepositoryProvider = Provider((ref) => ProjectRepository());

final projectStateProvider =
    StateNotifierProvider<ProjectNotifier, ProjectState>((ref) {
  return ProjectNotifier(ref.watch(projectRepositoryProvider));
});
final projectTimelineProvider =
    StateNotifierProvider<ProjectTimelineNotifier, ProjectTimelineState>((ref) {
  return ProjectTimelineNotifier(ref.watch(projectRepositoryProvider));
});

class ProjectNotifier extends StateNotifier<ProjectState> {
  final ProjectRepository _repository;

  ProjectNotifier(this._repository) : super(const ProjectState());

  Future<void> loadProjects() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final projects = await _repository.getAllProjects();
      state = state.copyWith(
        isLoading: false,
        projects: projects,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> getProject(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final project = await _repository.getProject(id);
      state = state.copyWith(
        isLoading: false,
        selectedProject: project,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> createProject({
    required int inquiryId,
    required int statusId,
    required double amountCollected,
    required double balenceAmount,
    required bool subsidyStatus,
    required String latestStatus,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final project = await _repository.createProject(
        inquiryId: inquiryId,
        statusId: statusId,
        amountCollected: amountCollected.toInt(),
        balenceAmount: balenceAmount.toInt(),
        subsidyStatus: subsidyStatus,
        latestStatus: latestStatus,
      );

      if (project != null) {
        // Refresh projects list after successful creation
        state = state.copyWith(
            isLoading: false, error: null, selectedProject: project);
        loadProjects();
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
}

class ProjectTimelineNotifier extends StateNotifier<ProjectTimelineState> {
  final ProjectRepository _repository;

  ProjectTimelineNotifier(this._repository)
      : super(const ProjectTimelineState());

  Future<void> getTimeline(int projectId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final timeline = await _repository.getProjectTimeline(projectId);
      state = state.copyWith(
        isLoading: false,
        timeline: timeline,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateWorkFlow(
      int projectId, int stageId, String remarks) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print("projectId : $projectId");
      print("stageId : $stageId");
      print("remarks : $remarks");
      await _repository.updateWorkFlow(projectId, stageId, remarks);
      getTimeline(projectId);
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
