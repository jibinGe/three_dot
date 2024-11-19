// lib/features/project/presentation/widgets/project_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:three_dot/features/project/data/model/projectModel.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectCard({
    Key? key,
    required this.project,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(project.customerName ?? project.id.toString()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.latestStatus),
            Text(
              DateFormat("dd/MM/yyyy")
                  .format(project.createdAt ?? DateTime.now()),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
