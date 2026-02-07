import 'package:flutter/material.dart';
import '../models/university.dart';

class ComparingUnivScreen extends StatefulWidget {
  final List<University> universities;

  const ComparingUnivScreen({
    super.key,
    required this.universities,
  });

  @override
  State<ComparingUnivScreen> createState() => _ComparingUnivScreenState();
}

class _ComparingUnivScreenState extends State<ComparingUnivScreen> {
  // Sample comparison data - you can modify this based on your University model
  final Map<String, Map<String, dynamic>> _comparisonData = {
    'Tuition Fee': {
      'icon': Icons.attach_money,
      'values': ['₱45,000/sem', '₱48,000/sem'],
    },
    'Acceptance Rate': {
      'icon': Icons.people_outline,
      'values': ['75%', '68%'],
    },
    'Student Population': {
      'icon': Icons.groups,
      'values': ['15,000', '12,500'],
    },
    'Programs Offered': {
      'icon': Icons.school,
      'values': ['45 Programs', '38 Programs'],
    },
    'Accreditation': {
      'icon': Icons.verified,
      'values': ['CHED, PAASCU', 'CHED, AACCUP'],
    },
    'Campus Size': {
      'icon': Icons.landscape,
      'values': ['25 hectares', '18 hectares'],
    },
    'Facilities': {
      'icon': Icons.domain,
      'values': ['Library, Lab, Gym', 'Library, Lab, Pool'],
    },
    'Scholarship': {
      'icon': Icons.card_giftcard,
      'values': ['Available', 'Available'],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C4A7C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Compare Universities',
          style: TextStyle(
            color: Color(0xFF2C4A7C),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Change Selection',
              style: TextStyle(
                color: Color(0xFF2C4A7C),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // University Cards Header
            _buildUniversityCards(),
            
            const SizedBox(height: 20),
            
            // Comparison Table
            _buildComparisonSection(),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildUniversityCards() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _buildUniversityCard(widget.universities[0], 0),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildUniversityCard(widget.universities[1], 1),
          ),
        ],
      ),
    );
  }

  Widget _buildUniversityCard(University university, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              university.imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.school, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  university.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C4A7C),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        university.location,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
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
    );
  }

  Widget _buildComparisonSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF2C4A7C).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color(0xFF2C4A7C),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Comparison Criteria',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'University 1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'University 2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          // Comparison Rows
          ..._comparisonData.entries.map((entry) {
            return _buildComparisonRow(
              entry.key,
              entry.value['icon'] as IconData,
              entry.value['values'] as List<String>,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String label, IconData icon, List<String> values) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC107).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: const Color(0xFFFFC107),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C4A7C),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                values[0],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                values[1],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}