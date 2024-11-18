import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/project/data/providers/projects_provider.dart';
import 'package:three_dot/features/project/presentation/screens/project_details_screen.dart';

class ProjectForm extends ConsumerStatefulWidget {
  final InquiryModel inquiry;
  const ProjectForm({
    Key? key,
    required this.inquiry,
  }) : super(key: key);

  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _collectedAmountController = TextEditingController();
  final _balanceAmountController = TextEditingController();
  String _selectedStatus = 'waiting_for_confirmation';
  bool _isSubsisy = false;

  @override
  void initState() {
    super.initState();
    _loadInquiryData();
  }

  void _loadInquiryData() {
    setState(() {
      _balanceAmountController.text = widget.inquiry.proposedAmount.toString();
      _collectedAmountController.text = "0.00";
    });
  }

  @override
  void dispose() {
    _collectedAmountController.dispose();
    _balanceAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectStateProvider);

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 15),
          const Center(
            child: Text(
              "Start Project",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: _collectedAmountController,
            onChanged: (value) {
              double balance =
                  widget.inquiry.proposedAmount - (double.tryParse(value) ?? 0);
              setState(() {
                _balanceAmountController.text = balance.toString();
              });
            },
            decoration: const InputDecoration(
              labelText: 'Collected Amount',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
              prefixText: '₹ ',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter collected amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _balanceAmountController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Balance Amount',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
              prefixText: '₹ ',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter balance amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildStatusSelection(),
          const SizedBox(height: 20),
          _buildSubsidySelection(),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: state.isLoading
                  ? LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.white,
                      size: 24,
                    )
                  : const Text('Start Project'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Latest Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'waiting_for_confirmation',
                  child: Text('Waiting'),
                ),
                DropdownMenuItem(
                  value: 'not_started',
                  child: Text('Not Started'),
                ),
                DropdownMenuItem(
                  value: 'accepted',
                  child: Text('Accepted'),
                ),
                DropdownMenuItem(
                  value: 'rejected',
                  child: Text('Rejected'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubsidySelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subsidy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<bool>(
              value: _isSubsisy,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: true,
                  child: Text("Yes"),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text("No"),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _isSubsisy = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        bool isSuccess = await ref
            .read(projectStateProvider.notifier)
            .createProject(
              amountCollected: double.parse(_collectedAmountController.text),
              balenceAmount: double.parse(_balanceAmountController.text),
              inquiryId: widget.inquiry.id,
              latestStatus: _selectedStatus,
              statusId: 1,
              subsidyStatus: _isSubsisy,
            );

        if (isSuccess && mounted) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailScreen(
                projectId: widget.inquiry.id,
                isJustCreated: true,
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }
}
