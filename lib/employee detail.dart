import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t_store/admin.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final EmployeeRecord employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(employee.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage(employee.imageUrl),
                radius: 50,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailItem('Employee ID', employee.id),
            _buildDetailItem('Branch', employee.branch),
            _buildDetailItem('Last Login', 
              DateFormat('MMM dd, yyyy - hh:mm a').format(employee.lastLogin)),
            _buildDetailItem('Last Logout', 
              employee.lastLogout != null 
                ? DateFormat('MMM dd, yyyy - hh:mm a').format(employee.lastLogout!) 
                : 'Currently active'),
            _buildDetailItem('Last Check-In', 
              DateFormat('MMM dd, yyyy - hh:mm a').format(employee.lastCheckIn)),
            _buildDetailItem('Location', employee.location),
            const SizedBox(height: 20),
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildActivityTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline() {
    // Sample activity data - replace with real data
    final activities = [
      {'time': DateTime.now().subtract(const Duration(hours: 1)), 'action': 'Checked in at ${employee.branch}'},
      {'time': DateTime.now().subtract(const Duration(hours: 2)), 'action': 'Logged in'},
      {'time': DateTime.now().subtract(const Duration(days: 1)), 'action': 'Checked out'},
      {'time': DateTime.now().subtract(const Duration(days: 1, hours: 2)), 'action': 'Checked in at East Branch'},
    ];

    return Column(
      children: activities.map((activity) {
        return ListTile(
          leading: const Icon(Icons.timeline),
          title: Text(activity['action'] as String),
          subtitle: Text(DateFormat('MMM dd, hh:mm a').format(activity['time'] as DateTime)),
        );
      }).toList(),
    );
  }
}