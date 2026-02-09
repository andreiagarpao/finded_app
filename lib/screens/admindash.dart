import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  final String selectedSchool;
  
  const AdminDashboard({
    super.key,
    required this.selectedSchool,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  late String _selectedSchool;

  // Available schools
  final List<String> _schools = [
    'All Schools',
    'CVSU',
    'DLSHSI',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with the school passed from login
    _selectedSchool = widget.selectedSchool;
  }

  // Mock data for student inquiries
  final List<Map<String, dynamic>> _studentInquiries = [
    {
      'id': '001',
      'studentName': 'Juan Dela Cruz',
      'email': 'juan.delacruz@email.com',
      'phone': '09123456789',
      'school': 'CVSU',
      'inquiry': 'What are the requirements for enrollment?',
      'date': '2024-02-08',
      'status': 'Pending',
    },
    {
      'id': '002',
      'studentName': 'Maria Santos',
      'email': 'maria.santos@email.com',
      'phone': '09234567890',
      'school': 'DLSHSI',
      'inquiry': 'Do you have scholarships available?',
      'date': '2024-02-07',
      'status': 'Responded',
    },
    {
      'id': '003',
      'studentName': 'Pedro Garcia',
      'email': 'pedro.garcia@email.com',
      'phone': '09345678901',
      'school': 'CVSU',
      'inquiry': 'What courses are offered for Senior High School?',
      'date': '2024-02-07',
      'status': 'Pending',
    },
    {
      'id': '004',
      'studentName': 'Ana Reyes',
      'email': 'ana.reyes@email.com',
      'phone': '09456789012',
      'school': 'DLSHSI',
      'inquiry': 'How much is the tuition fee for Grade 11?',
      'date': '2024-02-06',
      'status': 'Responded',
    },
    {
      'id': '005',
      'studentName': 'Jose Ramos',
      'email': 'jose.ramos@email.com',
      'phone': '09567890123',
      'school': 'CVSU',
      'inquiry': 'Is there an entrance exam?',
      'date': '2024-02-06',
      'status': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C4A7C),
        elevation: 0,
        title: Text(
          '$_selectedSchool Admin Dashboard',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
      body: _selectedIndex == 0 
          ? _buildInquiriesView() 
          : _buildOtherView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF2C4A7C),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Inquiries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            label: 'Schools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildInquiriesView() {
    // Filter inquiries by selected school
    List<Map<String, dynamic>> filteredInquiries = _selectedSchool == 'All Schools'
        ? _studentInquiries
        : _studentInquiries.where((inquiry) => inquiry['school'] == _selectedSchool).toList();

    // Filter inquiries by status
    int pendingCount = filteredInquiries.where((inquiry) => inquiry['status'] == 'Pending').length;
    int respondedCount = filteredInquiries.where((inquiry) => inquiry['status'] == 'Responded').length;

    return Column(
      children: [
        // Stats Cards
        Container(
          color: const Color(0xFF2C4A7C),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              // School Selector
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSchool,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2C4A7C)),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C4A7C),
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedSchool = newValue;
                        });
                      }
                    },
                    items: _schools.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(
                              value == 'All Schools' 
                                ? Icons.school 
                                : Icons.location_city,
                              size: 20,
                              color: const Color(0xFF2C4A7C),
                            ),
                            const SizedBox(width: 8),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total',
                      filteredInquiries.length.toString(),
                      Icons.inbox,
                      const Color(0xFFFFC107),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Pending',
                      pendingCount.toString(),
                      Icons.pending_outlined,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Responded',
                      respondedCount.toString(),
                      Icons.check_circle_outline,
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Inquiries List Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Inquiries',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C4A7C),
                    ),
                  ),
                  if (_selectedSchool != 'All Schools')
                    Text(
                      'Showing $_selectedSchool only',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  // Filter inquiries
                },
                icon: const Icon(Icons.filter_list, size: 18),
                label: const Text('Filter'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2C4A7C),
                ),
              ),
            ],
          ),
        ),

        // Inquiries List
        Expanded(
          child: filteredInquiries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No inquiries found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedSchool == 'All Schools'
                            ? 'No student inquiries yet'
                            : 'No inquiries from $_selectedSchool',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredInquiries.length,
                  itemBuilder: (context, index) {
                    final inquiry = filteredInquiries[index];
                    return _buildInquiryCard(inquiry);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C4A7C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryCard(Map<String, dynamic> inquiry) {
    bool isPending = inquiry['status'] == 'Pending';
    String studentName = inquiry['studentName'] ?? 'Unknown';
    String initial = studentName.isNotEmpty ? studentName[0].toUpperCase() : 'U';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showInquiryDetails(inquiry);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF2C4A7C).withOpacity(0.1),
                            child: Text(
                              initial,
                              style: const TextStyle(
                                color: Color(0xFF2C4A7C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  studentName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C4A7C),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFC107).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        inquiry['school'] ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2C4A7C),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        inquiry['email'] ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isPending 
                            ? Colors.orange.withOpacity(0.1) 
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        inquiry['status'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isPending ? Colors.orange : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Inquiry Text
                Text(
                  inquiry['inquiry'] ?? 'No inquiry text',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Footer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          inquiry['date'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.phone, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          inquiry['phone'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        _showInquiryDetails(inquiry);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF2C4A7C),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This feature is under development',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showInquiryDetails(Map<String, dynamic> inquiry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          inquiry['studentName'] ?? 'Unknown Student',
          style: const TextStyle(
            color: Color(0xFF2C4A7C),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(Icons.school, 'School', inquiry['school'] ?? 'N/A'),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.email, 'Email', inquiry['email'] ?? 'N/A'),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.phone, 'Phone', inquiry['phone'] ?? 'N/A'),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.calendar_today, 'Date', inquiry['date'] ?? 'N/A'),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.info_outline, 'Status', inquiry['status'] ?? 'N/A'),
              const Divider(height: 24),
              const Text(
                'Inquiry:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF2C4A7C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                inquiry['inquiry'] ?? 'No inquiry text',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          if (inquiry['status'] == 'Pending')
            TextButton(
              onPressed: () {
                setState(() {
                  inquiry['status'] = 'Responded';
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Marked as Responded')),
                );
              },
              child: const Text('Mark as Responded'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2C4A7C)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to login
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}