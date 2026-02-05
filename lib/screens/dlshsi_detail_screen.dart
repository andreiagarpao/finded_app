import 'package:flutter/material.dart';

class DLSHSIDetailScreen extends StatelessWidget {
  const DLSHSIDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with background image
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/dlshsi.jpg', // Replace with your image
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverList(
            delegate: SliverChildListDelegate([
              // Title and Description Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'De La Salle Medical and Health Sciences Institute',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.school,
                      'Bachelor\'s Degree and Master\'s Degree',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.location_on,
                      'Governor D. Mangubat Ave, Dasmariñas, Cavite',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.phone,
                      '+63(046)481-8000',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.public,
                      'www.dlshsi.edu.ph',
                    ),
                  ],
                ),
              ),

              // Divider
              const Divider(height: 1, thickness: 1),

              // Programs Section Header
              Container(
                padding: const EdgeInsets.all(20.0),
                child: const Text(
                  'Our Programs',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),

              // Program Cards
              _buildProgramCard(
                'assets/images/medicine.jpg',
                'College of Medicine',
                'The College of Medicine at DLSHSI offers a comprehensive medical education program designed to produce competent, compassionate, and ethical physicians.',
              ),

              _buildProgramCard(
                'assets/images/allied_science.jpg',
                'College of Allied Science',
                'Offering programs in Medical Technology, Physical Therapy, Occupational Therapy, and other allied health professions to support comprehensive patient care.',
              ),

              _buildProgramCard(
                'assets/images/dentistry.jpg',
                'College of Dentistry',
                'The College of Dentistry provides excellent training in oral health care, combining theoretical knowledge with extensive clinical practice.',
              ),

              _buildProgramCard(
                'assets/images/medical_imaging.jpg',
                'College of Medical Imaging and Therapy',
                'Specialized programs in Radiologic Technology and other imaging sciences, preparing students for careers in diagnostic imaging.',
              ),

              _buildProgramCard(
                'assets/images/medical_laboratory.jpg',
                'College of Medical Laboratory',
                'Training future medical laboratory scientists with state-of-the-art facilities and comprehensive laboratory education.',
              ),

              _buildProgramCard(
                'assets/images/nursing.jpg',
                'College of Nursing',
                'The College of Nursing develops highly skilled and compassionate nurses through rigorous academic and clinical training programs.',
              ),

              // Apply Button Section
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Ready to Apply?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start your journey at DLSHSI and become part of our community dedicated to excellence in healthcare education.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Add your apply logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Redirecting to application...'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'SUBMIT APPLICATION NOW',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF1B5E20),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgramCard(String imagePath, String title, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}