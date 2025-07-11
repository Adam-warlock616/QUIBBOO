import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:t_store/checkin_success_screen.dart';

class BranchCheckInScreen extends StatefulWidget {
  final String employeeName;
  final String employeeId;

  const BranchCheckInScreen({
    super.key,
    required this.employeeName,
    required this.employeeId,
  });

  @override
  State<BranchCheckInScreen> createState() => _BranchCheckInScreenState();
}

class _BranchCheckInScreenState extends State<BranchCheckInScreen> {
  String? _selectedBranch;
  File? _capturedImage;
  DateTime? _checkInTime;
  String _locationStatus = "Not retrieved";
  bool _isLoadingLocation = false;

  final List<String> _branches = [
    "Head Office - New York",
    "Downtown Branch - Chicago",
    "Westside Branch - Los Angeles",
    "Central Branch - Dallas",
    "Northern Branch - Seattle"
  ];

  Future<void> _captureEmployeeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _capturedImage = File(pickedFile.path);
      });
    }
  }

  void _simulateLocationFetch() {
    setState(() {
      _isLoadingLocation = true;
      _locationStatus = "Fetching...";
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoadingLocation = false;
        _locationStatus = "37.7749° N, 122.4194° W"; // Sample coordinates
        _checkInTime = DateTime.now();
      });
    });
  }

  void _submitCheckIn() {
    if (_selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a branch")));
      return;
    }

    if (_capturedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please capture your image")));
      return;
    }

    if (_locationStatus == "Not retrieved") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please retrieve location")));
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CheckInSuccessScreen(
          employeeName: widget.employeeName,
          employeeId: widget.employeeId,
          branch: _selectedBranch!,
          time: _checkInTime!,
          location: _locationStatus,
          image: _capturedImage!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branch Check-In'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Employee Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.employeeName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "ID: ${widget.employeeId}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Branch Selection
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Select Your Branch",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              value: _selectedBranch,
              items: _branches
                  .map((branch) => DropdownMenuItem(
                        value: branch,
                        child: Text(branch),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedBranch = value),
            ),

            const SizedBox(height: 24),

            // Image Capture Section
            Text(
              "Employee Photo:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _captureEmployeeImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _capturedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt, size: 50),
                          Text("Tap to capture image"),
                        ],
                      )
                    : Image.file(_capturedImage!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 24),

            // Location Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 8),
                        Text(
                          "Location",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_locationStatus),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed:
                          _isLoadingLocation ? null : _simulateLocationFetch,
                      icon: _isLoadingLocation
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh, size: 18),
                      label: Text(
                          _isLoadingLocation ? "Fetching..." : "Get Location"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Check-In Button
            ElevatedButton(
              onPressed: _submitCheckIn,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("COMPLETE CHECK-IN"),
            ),
          ],
        ),
      ),
    );
  }
}
