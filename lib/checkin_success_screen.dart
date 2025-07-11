import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:t_store/login.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class CheckInSuccessScreen extends StatelessWidget {
  final String employeeName;
  final String employeeId;
  final String branch;
  final DateTime time;
  final String location;
  final File image;

  const CheckInSuccessScreen({
    super.key,
    required this.employeeName,
    required this.employeeId,
    required this.branch,
    required this.time,
    required this.location,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime =
        DateFormat('MMM dd, yyyy - hh:mm a').format(time.toLocal());
    final isDarkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In Complete'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              Text(
                "CHECK-IN SUCCESSFUL",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? Colors.green.shade300
                      : Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 30),
              _buildDetailRow("Employee:", employeeName),
              _buildDetailRow("ID:", employeeId),
              _buildDetailRow("Branch:", branch),
              _buildDetailRow("Time:", formattedTime),
              _buildDetailRow("Location:", location),
              const SizedBox(height: 20),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.file(image, fit: BoxFit.cover),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(() => EmployeeDashboard(
                        employeeName: employeeName,
                        employeeId: employeeId,
                        branch: branch,
                      )),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("GO TO MY DASHBOARD"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// Add this new EmployeeDashboard widget
class EmployeeDashboard extends StatelessWidget {
  final String employeeName;
  final String employeeId;
  final String branch;

  const EmployeeDashboard({
    super.key,
    required this.employeeName,
    required this.employeeId,
    required this.branch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$employeeName\'s Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.offAll(() => const EmployeeLoginScreen()),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildTasksSection(),
            const SizedBox(height: 24),
            _buildWorkStatusSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employeeName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('ID: $employeeId'),
                const SizedBox(height: 4),
                Text('Branch: $branch'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Tasks',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTaskItem(
                    'Ongoing', 'Project X Development', 'Due: Today'),
                const Divider(),
                _buildTaskItem(
                    'Pending', 'Client Meeting Prep', 'Due: Tomorrow'),
                const Divider(),
                _buildTaskItem('Completed', 'Monthly Report', 'Submitted'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(String status, String title, String subtitle) {
    Color statusColor = Colors.grey;
    if (status == 'Ongoing') statusColor = Colors.blue;
    if (status == 'Pending') statusColor = Colors.orange;
    if (status == 'Completed') statusColor = Colors.green;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.work,
          color: statusColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Chip(
        label: Text(status),
        backgroundColor: statusColor.withOpacity(0.1),
        labelStyle: TextStyle(color: statusColor),
      ),
    );
  }

  Widget _buildWorkStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Work Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStatusCard('Hours Worked', '8.5', Icons.timer),
            _buildStatusCard('Tasks Due', '3', Icons.assignment),
            _buildStatusCard('Projects', '2', Icons.work),
            _buildStatusCard('Achievements', '5', Icons.star),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
