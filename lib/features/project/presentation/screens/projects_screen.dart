import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/project/data/model/projectModel.dart';
import 'package:three_dot/features/project/data/providers/projects_list_provider.dart';
import 'package:three_dot/features/project/presentation/screens/project_details_screen.dart';

class ProjectsListScreen extends ConsumerWidget {
  const ProjectsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: projectsAsync.when(
        // data: (products) => ProductGrid(products: products),
        data: (projects) => projects.isEmpty
            ? const Center(child: Text('No products found'))
            : projectList(projects: projects),
        loading: () => Center(
            child: LoadingAnimationWidget.threeArchedCircle(
          color: AppColors.textPrimary,
          size: 24,
        )),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectModel project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text(project.id.toString()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.latestStatus),
            Text(DateFormat("dd/MM/yyyy")
                .format(project.createdAt ?? DateTime.now())),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailScreen(projectId: project.id),
            ),
          );
        },
      ),
    );
  }

  projectList({required List<ProjectModel> projects}) {
    return ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) =>
            _buildProjectCard(context, projects[index]));
  }
}
