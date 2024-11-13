import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/project/data/model/projectModel.dart';
import 'package:three_dot/features/project/data/repositories/project_repository.dart';

final projectRepositoryProvider = Provider((ref) => ProjectRepository());
final projectsListProvider =
    FutureProvider.autoDispose<List<ProjectModel>>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getAllProjects();
});
