import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/project/data/providers/projects_provider.dart';
import 'package:three_dot/features/project/presentation/screens/project_details_screen.dart';
import 'package:three_dot/features/project/presentation/widgets/project_card.dart';

class ProjectsListScreen extends ConsumerStatefulWidget {
  const ProjectsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends ConsumerState<ProjectsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(projectStateProvider.notifier).loadProjects(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: state.isLoading
          ? Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.textPrimary,
                size: 24,
              ),
            )
          : state.error != null
              ? Center(child: Text('Error: ${state.error}'))
              : state.projects.isEmpty
                  ? const Center(child: Text('No projects found'))
                  : ListView.builder(
                      itemCount: state.projects.length,
                      itemBuilder: (context, index) => ProjectCard(
                        project: state.projects[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailScreen(
                              projectId: state.projects[index].id,
                            ),
                          ),
                        ),
                      ),
                    ),
    );
  }
}
