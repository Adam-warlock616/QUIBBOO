import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t_store/employee%20detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore example

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key, required employeeName});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _employeesStream;

  @override
  void initState() {
    super.initState();
    // Set up real-time listener for employee data
    _employeesStream = _firestore
        .collection('employees')
        .orderBy('lastLogin', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsOverview(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildEmployeeTable(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateReport,
        child: const Icon(Icons.insert_drive_file),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return StreamBuilder<QuerySnapshot>(
      stream: _employeesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final employees = snapshot.data!.docs;
        final activeEmployees = employees.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['lastLogout'] == null;
        }).length;

        final todayCheckIns = employees.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final checkIn = (data['lastCheckIn'] as Timestamp).toDate();
          return checkIn.day == DateTime.now().day;
        }).length;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Employees', '${employees.length}'),
                _buildStatItem('Currently Active', '$activeEmployees'),
                _buildStatItem('Today\'s Check-ins', '$todayCheckIns'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmployeeTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: _employeesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final employees = snapshot.data!.docs;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Employee')),
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Branch')),
              DataColumn(label: Text('Last Login')),
              DataColumn(label: Text('Last Logout')),
              DataColumn(label: Text('Last Check-In')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: employees.map((doc) {
              final employee = EmployeeRecord.fromFirestore(doc);
              return DataRow(cells: [
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(employee.imageUrl),
                        radius: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(employee.name),
                    ],
                  ),
                ),
                DataCell(Text(employee.id)),
                DataCell(Text(employee.branch)),
                DataCell(Text(_formatDateTime(employee.lastLogin))),
                DataCell(Text(employee.lastLogout != null
                    ? _formatDateTime(employee.lastLogout!)
                    : 'Active')),
                DataCell(Text(_formatDateTime(employee.lastCheckIn))),
                DataCell(
                  Tooltip(
                    message: employee.location,
                    child: const Icon(Icons.location_on, size: 20),
                  ),
                ),
                DataCell(
                  Chip(
                    label: Text(
                      employee.lastLogout == null ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: employee.lastLogout == null
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                    backgroundColor: employee.lastLogout == null
                        ? Colors.green.withAlpha((0.2 * 255).toInt())
                        : Colors.grey.withAlpha((0.2 * 255).toInt()),
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () => _viewEmployeeDetails(employee),
                  ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('MMM dd, hh:mm a').format(dateTime);
  }

  void _refreshData() {
    // Force a refresh of the stream
    setState(() {
      _employeesStream = _firestore
          .collection('employees')
          .orderBy('lastLogin', descending: true)
          .snapshots();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data refreshed')),
    );
  }

  void _showFilters() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Employees'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Show only active'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Show by branch'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Apply filters
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _viewEmployeeDetails(EmployeeRecord employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailScreen(employee: employee),
      ),
    );
  }

  void _generateReport() {
    // Implement report generation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report generated')),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

class EmployeeRecord {
  final String id;
  final String name;
  final String branch;
  final DateTime lastLogin;
  final DateTime? lastLogout;
  final DateTime lastCheckIn;
  final String location;
  final String imageUrl;

  EmployeeRecord({
    required this.id,
    required this.name,
    required this.branch,
    required this.lastLogin,
    this.lastLogout,
    required this.lastCheckIn,
    required this.location,
    required this.imageUrl,
  });

  factory EmployeeRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EmployeeRecord(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
      branch: data['branch'] ?? 'Unknown Branch',
      lastLogin: (data['lastLogin'] as Timestamp).toDate(),
      lastLogout: data['lastLogout'] != null
          ? (data['lastLogout'] as Timestamp).toDate()
          : null,
      lastCheckIn: (data['lastCheckIn'] as Timestamp).toDate(),
      location: data['location'] ?? 'Location not available',
      imageUrl: data['imageUrl'] ?? 'assets/avatars/default_avatar.jpg',
    );
  }
}
