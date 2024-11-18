import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/project/data/model/projectModel.dart';
import 'package:three_dot/features/project/data/providers/projects_provider.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final int projectId;
  final bool? isJustCreated;

  const ProjectDetailScreen(
      {Key? key, required this.projectId, this.isJustCreated = false})
      : super(key: key);

  @override
  ConsumerState<ProjectDetailScreen> createState() =>
      _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (!widget.isJustCreated!) {
      Future.microtask(() =>
          ref.read(projectStateProvider.notifier).getProject(widget.projectId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text('Error: ${state.error}'))
              : state.selectedProject == null
                  ? const Center(child: Text('No data available'))
                  : _buildProjectDetails(state.selectedProject!),
    );
  }

  Widget _buildProjectDetails(ProjectModel project) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSection(
          'Project Overview',
          [
            _buildInfoRow('Status', project.latestStatus),
            _buildInfoRow(
                'Amount Collected', project.amountCollected.toStringAsFixed(2)),
            _buildInfoRow(
                'Amount Pending', project.amountPending.toStringAsFixed(2)),
            _buildInfoRow(
                'Subsidy Status', project.subsidyStatus ? 'Yes' : 'No'),
          ],
        ),
        const SizedBox(height: 16),
        _buildSection(
          'Dates & Milestones',
          [
            _buildInfoRow(
                'Feasibility Approval Date',
                project.feasibilityApprovalDate != null
                    ? project.feasibilityApprovalDate!.toLocal().toString()
                    : 'N/A'),
            _buildInfoRow(
                'Agreement Upload Date',
                project.agreementUploadDate != null
                    ? project.agreementUploadDate!.toLocal().toString()
                    : 'N/A'),
            _buildInfoRow(
                'Installation Date',
                project.installationDate != null
                    ? project.installationDate!.toLocal().toString()
                    : 'N/A'),
            _buildInfoRow(
                'Commissioning Date',
                project.commissioningDate != null
                    ? project.commissioningDate!.toLocal().toString()
                    : 'N/A'),
            _buildInfoRow(
                'AE Approval Date',
                project.aeApprovalDate != null
                    ? project.aeApprovalDate!.toLocal().toString()
                    : 'N/A'),
            _buildInfoRow(
                'Bank Details Submission Date',
                project.bankDetailsSubmissionDate != null
                    ? project.bankDetailsSubmissionDate!.toLocal().toString()
                    : 'N/A'),
            _buildInfoRow(
                'Project Completion Date',
                project.projectCompletionDate != null
                    ? project.projectCompletionDate!.toLocal().toString()
                    : 'N/A'),
          ],
        ),
        const SizedBox(height: 16),
        _buildSection(
          'Project Details',
          [
            _buildInfoRow('Created At', project.createdAt.toLocal().toString()),
            _buildInfoRow(
                'Last Updated', project.lastUpdated.toLocal().toString()),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
