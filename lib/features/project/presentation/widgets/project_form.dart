import 'package:flutter/material.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';

class ProjectForm extends StatefulWidget {
  final InquiryModel inquiry;
  const ProjectForm({
    super.key,
    required this.inquiry,
  });

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _collectedAmountController = TextEditingController();
  final _balanceAmountController = TextEditingController();
  String _selectedStatus = 'status 1';
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
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              "Start Project",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: _collectedAmountController,
            onChanged: (value) {
              double balance =
                  widget.inquiry.proposedAmount - double.parse(value);
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
            onChanged: (value) {},
            // enabled: false,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'balance Amount',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
              prefixText: '₹ ',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter bal amount';
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
              child: const Text('Start Project'),
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
                  value: 'status 1',
                  child: Text('Status 1'),
                ),
                DropdownMenuItem(
                  value: 'status 2',
                  child: Text('Status 2'),
                ),
                DropdownMenuItem(
                  value: 'Status 3',
                  child: Text('Status 3'),
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

  void _submitForm() {}
}
