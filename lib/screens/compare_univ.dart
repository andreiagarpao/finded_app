import 'package:flutter/material.dart';
import '../models/university.dart';
import 'comparing_univ.dart';

class CompareUnivScreen extends StatefulWidget {
  const CompareUnivScreen({super.key});

  @override
  State<CompareUnivScreen> createState() => _CompareUnivScreenState();
}

class _CompareUnivScreenState extends State<CompareUnivScreen> {
  final List<University> _selectedUniversities = [];
  final int _maxSelection = 2;

  final List<University> _universities = [
    University(
      name: 'De La Salle University - Dasmariñas',
      location: 'Dasmariñas, Cavite',
      imageUrl: 'assets/images/dlsu.jpg',
    ),
    University(
      name: 'De La Salle Medical and Health Sciences Institute',
      location: 'Dasmariñas, Cavite',
      imageUrl: 'assets/dlshsi.jpg',
    ),
    University(
      name: 'Cavite State University',
      location: 'Indang, Cavite',
      imageUrl: 'assets/cvsu.jpg',
    ),
    University(
      name: 'De La Salle University',
      location: 'Dasmariñas, Cavite',
      imageUrl: 'assets/images/dlsu.jpg',
    ),
    University(
      name: 'Emilio Aguinaldo College',
      location: 'Dasmariñas, Cavite',
      imageUrl: 'assets/images/dlshsi2.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select the first two universities
    if (_universities.length >= 2) {
      _selectedUniversities.add(_universities[0]);
      _selectedUniversities.add(_universities[1]);
    }
  }

  void _toggleSelection(University university) {
    setState(() {
      if (_selectedUniversities.contains(university)) {
        _selectedUniversities.remove(university);
      } else {
        if (_selectedUniversities.length < _maxSelection) {
          _selectedUniversities.add(university);
        }
      }
    });
  }

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
      ),
      body: Column(
        children: [
          // Selected Universities Display
          _buildSelectedUniversitiesSection(),
          
          const SizedBox(height: 20),
          
          // Universities List
          Expanded(
            child: _buildUniversitiesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedUniversitiesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Universities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C4A7C),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildSelectedUniversitySlot(0),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildSelectedUniversitySlot(1),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedUniversities.length == _maxSelection
                  ? () {
                      // Navigate to comparison screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComparingUnivScreen(
                            universities: _selectedUniversities,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107),
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                'Compare',
                style: TextStyle(
                  color: _selectedUniversities.length == _maxSelection
                      ? Colors.white
                      : Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedUniversitySlot(int index) {
    final hasUniversity = index < _selectedUniversities.length;
    
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: hasUniversity ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasUniversity ? const Color(0xFF2C4A7C) : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: hasUniversity
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    _selectedUniversities[index].imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.school, size: 40, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedUniversities.removeAt(index);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      _selectedUniversities[index].name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 40,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Select University',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildUniversitiesList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Text(
              'All Universities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _universities.length,
              itemBuilder: (context, index) {
                final university = _universities[index];
                final isSelected = _selectedUniversities.contains(university);
                final canSelect = _selectedUniversities.length < _maxSelection;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildUniversityListItem(
                    university,
                    isSelected,
                    canSelect || isSelected,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUniversityListItem(
    University university,
    bool isSelected,
    bool isEnabled,
  ) {
    return GestureDetector(
      onTap: isEnabled ? () => _toggleSelection(university) : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2C4A7C) : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                university.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.school, size: 30, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    university.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C4A7C),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          university.location,
                          style: TextStyle(
                            fontSize: 12,
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
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2C4A7C)
                      : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF2C4A7C) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}