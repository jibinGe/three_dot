import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:three_dot/features/project/data/model/project_timeline_model.dart';
import 'package:three_dot/features/project/data/providers/projects_provider.dart';
import 'package:timelines/timelines.dart';

class ProjectTimelineScreen extends ConsumerStatefulWidget {
  final int projectId;

  const ProjectTimelineScreen({Key? key, required this.projectId})
      : super(key: key);

  @override
  ConsumerState<ProjectTimelineScreen> createState() =>
      _ProjectTimelineScreenState();
}

class _ProjectTimelineScreenState extends ConsumerState<ProjectTimelineScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(projectTimelineProvider.notifier)
        .getTimeline(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectTimelineProvider);

    return Scaffold(
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text('Error: ${state.error}'))
              : state.timeline == null
                  ? const Center(child: Text('No timeline data available'))
                  : _buildTimeline(state.timeline!),
    );
  }

  Widget _buildTimeline(ProjectTimelineModel timeline) {
    // Combine all stages in order: history (completed) -> current -> next
    final allStages = [
      ...timeline.history.map((h) => _TimelineItem(
            title: h.stageName,
            status: 'completed',
            date: h.date,
            remarks: h.remarks,
          )),
      _TimelineItem(
        title: timeline.currentStatus.stageName,
        status: timeline.currentStatus.status,
        date: null,
        remarks: '',
      ),
      ...timeline.nextStages.map((n) => _TimelineItem(
            title: n.stageName,
            status: 'upcoming',
            date: null,
            remarks: '',
          )),
    ];

    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0.9,
        connectorTheme: const ConnectorThemeData(
          thickness: 2.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      builder: TimelineTileBuilder.connected(
        contentsAlign: ContentsAlign.reverse,
        connectionDirection: ConnectionDirection.after,
        itemCount: allStages.length,
        contentsBuilder: (_, index) =>
            _buildTimelineCard(allStages[index], timeline),
        indicatorBuilder: (_, index) =>
            _buildIndicator(allStages[index].status),
        connectorBuilder: (_, index, connectorType) =>
            _buildConnector(allStages[index].status),
      ),
    );
  }

  Widget _buildTimelineCard(_TimelineItem item, ProjectTimelineModel timeline) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (item.date != null) ...[
                const SizedBox(height: 8),
                Text(
                  DateFormat('MMM dd, yyyy HH:mm').format(item.date!),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
              if (item.remarks.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Remarks: ${item.remarks}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
              if (item.status == timeline.currentStatus.status) ...[
                const SizedBox(height: 8),
                Text(
                  'Status: ${item.status.replaceAll('_', ' ').toUpperCase()}',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'completed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'upcoming':
        color = Colors.grey;
        icon = Icons.radio_button_unchecked;
        break;
      default:
        color = Colors.orange;
        icon = Icons.pending;
    }

    return DotIndicator(
      size: 30,
      color: color,
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildConnector(String status) {
    return SolidLineConnector(
      color: status == 'completed' ? Colors.green : Colors.grey[300],
    );
  }
}

class _TimelineItem {
  final String title;
  final String status;
  final DateTime? date;
  final String remarks;

  _TimelineItem({
    required this.title,
    required this.status,
    required this.date,
    required this.remarks,
  });
}
