import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/inquiry/data/models/location_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_providers.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_detail_screen.dart';
import 'package:three_dot/shared/services/location_service.dart';

class InquiryFormScreen extends ConsumerStatefulWidget {
  const InquiryFormScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<InquiryFormScreen> createState() => _InquiryFormScreenState();
}

class _InquiryFormScreenState extends ConsumerState<InquiryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _consumerNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _emailController = TextEditingController();
  double? _latitude;
  double? _longitude;
  bool _loacationLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _consumerNumberController.dispose();
    _addressController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inquiryState = ref.watch(inquiryNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Inquiry'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _consumerNumberController,
              decoration: const InputDecoration(
                labelText: 'Consumer Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter consumer number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _mobileNumberController,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mobile number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                return !emailRegex.hasMatch(value)
                    ? 'Enter a valid email'
                    : null;
              },
            ),
            const SizedBox(height: 16),
            _buildLocationPicker(),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: inquiryState.isLoading
                    ? LoadingAnimationWidget.threeRotatingDots(
                        color: Colors.white, size: 30)
                    : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationPicker() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _latitude != null
                        ? 'Lat: $_latitude,\nLong: $_longitude'
                        : 'No location selected',
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _pickLocation,
                  icon:
                      _loacationLoading ? null : const Icon(Icons.my_location),
                  label: _loacationLoading
                      ? SizedBox(
                          width: 150,
                          child: Center(
                            child: LoadingAnimationWidget.waveDots(
                                color: AppColors.surface, size: 20),
                          ),
                        )
                      : const Text('Pick Location'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _pickLocation() async {
    // Implement location picking functionality
    // You can use a map picker or get current location
    try {
      setState(() {
        _loacationLoading = true;
      });
      final position = await LocationService.getLocation();
      if (position != null) {
        setState(() {
          _latitude = position.latitude; // Replace with actual picked location
          _longitude =
              position.longitude; // Replace with actual picked location
        });
      }
    } catch (e) {
      debugPrint("Error getting Location");
    } finally {
      setState(() {
        _loacationLoading = false;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_latitude == null || _longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick a location')),
        );
        return;
      }

      try {
        await ref.read(inquiryNotifierProvider.notifier).createInquiryStage1(
              name: _nameController.text,
              consumerNumber: _consumerNumberController.text,
              address: _addressController.text,
              mobileNumber: _mobileNumberController.text,
              email: _emailController.text,
              location: LocationModel(
                lat: _latitude!,
                lng: _longitude!,
              ),
            );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const InquiryDetailScreen(
                inquiryId: 1,
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
