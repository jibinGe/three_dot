import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/project/data/model/project_state.dart';
import 'package:three_dot/features/project/data/repositories/project_repository.dart';

final projectRepositoryProvider = Provider((ref) => ProjectRepository());

final projectStateProvider =
    StateNotifierProvider<ProjectNotifier, ProjectState>((ref) {
  return ProjectNotifier(ref.watch(projectRepositoryProvider));
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
        await loadProjects();
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
