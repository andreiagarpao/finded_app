import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/studin.dart';
import '../services/studinquireserve.dart';
import '../models/studin.dart';
import '../services/studinquireserve.dart';

class DLSHSIApplicationForm extends StatefulWidget {
  const DLSHSIApplicationForm({super.key});

  @override
  State<DLSHSIApplicationForm> createState() => _DLSHSIApplicationFormState();
}

class _DLSHSIApplicationFormState extends State<DLSHSIApplicationForm> {
  int _currentStep = 0;
  final StudentInquiryService _service = StudentInquiryService();

  // Controllers for form fields
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _highSchoolController = TextEditingController();
  final _graduationYearController = TextEditingController();
  final _gpaController = TextEditingController();
  final _inquiryController = TextEditingController(); // New field for inquiry

  String? _selectedProgram;
  String? _selectedGender;
  String? _selectedCivilStatus;
  DateTime? _birthDate;

  final List<String> _programs = [
    'Doctor of Medicine (MD)',
    'Bachelor of Science in Nursing (BSN)',
    'Bachelor of Science in Physical Therapy (BSPT)',
    'Bachelor of Science in Medical Technology (BSMT)',
    'Bachelor of Science in Pharmacy (BSPharma)',
  ];

  final List<String> _genders = ['Male', 'Female', 'Prefer not to say'];
  final List<String> _civilStatus = ['Single', 'Married', 'Widowed', 'Separated'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _highSchoolController.dispose();
    _graduationYearController.dispose();
    _gpaController.dispose();
    _inquiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'DLSHSI Application',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(_currentStep == 3 ? 'Submit' : 'Continue'),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          // Step 1: Personal Information
          Step(
            title: const Text('Personal Information'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                _buildTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _middleNameController,
                  label: 'Middle Name (Optional)',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  label: 'Date of Birth',
                  icon: Icons.calendar_today,
                  selectedDate: _birthDate,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF1565C0),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        _birthDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Gender',
                  icon: Icons.wc,
                  value: _selectedGender,
                  items: _genders,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Civil Status',
                  icon: Icons.family_restroom,
                  value: _selectedCivilStatus,
                  items: _civilStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedCivilStatus = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // Step 2: Contact Information
          Step(
            title: const Text('Contact Information'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _addressController,
                  label: 'Street Address',
                  icon: Icons.home,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _cityController,
                  label: 'City/Municipality',
                  icon: Icons.location_city,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _zipCodeController,
                  label: 'Zip Code',
                  icon: Icons.pin_drop,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
              ],
            ),
          ),
          // Step 3: Academic Information
          Step(
            title: const Text('Academic Information'),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                _buildDropdown(
                  label: 'Program of Interest',
                  icon: Icons.school,
                  value: _selectedProgram,
                  items: _programs,
                  onChanged: (value) {
                    setState(() {
                      _selectedProgram = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _highSchoolController,
                  label: 'High School Attended',
                  icon: Icons.school_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _graduationYearController,
                  label: 'Year Graduated',
                  icon: Icons.calendar_month,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _gpaController,
                  label: 'General Average / GPA',
                  icon: Icons.grade,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          // Step 4: Inquiry/Additional Information
          Step(
            title: const Text('Inquiry & Questions'),
            isActive: _currentStep >= 3,
            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.help_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Do you have any questions or concerns about your application?',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _inquiryController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Your Questions or Concerns',
                    hintText: 'e.g., What are the scholarship opportunities? When is the enrollment period?',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 80),
                      child: Icon(Icons.message, color: Color(0xFF1565C0)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.green[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Please ensure all information is accurate before submitting. We will review your application and respond to your inquiry within 5-7 business days.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      // Validate Step 1
      if (_firstNameController.text.trim().isEmpty) {
        _showError('Please enter your first name');
        return;
      }
      if (_lastNameController.text.trim().isEmpty) {
        _showError('Please enter your last name');
        return;
      }
      if (_birthDate == null) {
        _showError('Please select your date of birth');
        return;
      }
      if (_selectedGender == null) {
        _showError('Please select your gender');
        return;
      }
      if (_selectedCivilStatus == null) {
        _showError('Please select your civil status');
        return;
      }
      setState(() {
        _currentStep = 1;
      });
    } else if (_currentStep == 1) {
      // Validate Step 2
      if (_emailController.text.trim().isEmpty) {
        _showError('Please enter your email address');
        return;
      }
      if (!_emailController.text.contains('@')) {
        _showError('Please enter a valid email address');
        return;
      }
      if (_phoneController.text.trim().isEmpty) {
        _showError('Please enter your phone number');
        return;
      }
      if (_phoneController.text.length < 10) {
        _showError('Please enter a valid phone number');
        return;
      }
      if (_addressController.text.trim().isEmpty) {
        _showError('Please enter your address');
        return;
      }
      if (_cityController.text.trim().isEmpty) {
        _showError('Please enter your city');
        return;
      }
      if (_zipCodeController.text.trim().isEmpty) {
        _showError('Please enter your zip code');
        return;
      }
      setState(() {
        _currentStep = 2;
      });
    } else if (_currentStep == 2) {
      // Validate Step 3
      if (_selectedProgram == null) {
        _showError('Please select a program');
        return;
      }
      if (_highSchoolController.text.trim().isEmpty) {
        _showError('Please enter your high school');
        return;
      }
      if (_graduationYearController.text.trim().isEmpty) {
        _showError('Please enter your graduation year');
        return;
      }
      final year = int.tryParse(_graduationYearController.text);
      if (year == null || year < 1950 || year > DateTime.now().year) {
        _showError('Please enter a valid graduation year');
        return;
      }
      if (_gpaController.text.trim().isEmpty) {
        _showError('Please enter your GPA');
        return;
      }
      final gpa = double.tryParse(_gpaController.text);
      if (gpa == null || gpa < 0 || gpa > 100) {
        _showError('Please enter a valid GPA (0-100)');
        return;
      }
      setState(() {
        _currentStep = 3;
      });
    } else if (_currentStep == 3) {
      // Step 4 - Inquiry is optional, but we can validate if needed
      // For now, we'll allow empty inquiry
      _submitApplication();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1565C0)),
            const SizedBox(width: 12),
            Text(
              selectedDate != null
                  ? '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'
                  : label,
              style: TextStyle(
                color: selectedDate != null ? Colors.black : Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitApplication() {
    // DEBUG: Print before anything
    print('🎯 ========== DLSHSI SUBMIT APPLICATION START ==========');
    _service.debugPrintInstance();
    
    // Generate a unique ID for this application
    final String applicationId = _service.generateId();
    
    // Get the full name
    String fullName = _firstNameController.text.trim();
    if (_middleNameController.text.trim().isNotEmpty) {
      fullName += ' ${_middleNameController.text.trim()}';
    }
    fullName += ' ${_lastNameController.text.trim()}';
    
    // Get current date in YYYY-MM-DD format
    final now = DateTime.now();
    final String currentDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    // Create the inquiry object using the model
    // KEY DIFFERENCE: school is set to 'DLSHSI' instead of 'CVSU'
    final inquiry = StudentInquiry(
      id: applicationId,
      studentName: fullName,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      school: 'DLSHSI',  // <-- This is the critical identifier
      inquiry: _inquiryController.text.trim().isEmpty 
          ? 'Application for ${_selectedProgram ?? "program"}'
          : _inquiryController.text.trim(),
      date: currentDate,
      status: 'Pending',
      personalInfo: PersonalInfo(
        firstName: _firstNameController.text.trim(),
        middleName: _middleNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        birthDate: _birthDate?.toIso8601String(),
        gender: _selectedGender,
        civilStatus: _selectedCivilStatus,
      ),
      contactInfo: ContactInfo(
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
      ),
      academicInfo: AcademicInfo(
        program: _selectedProgram ?? '',
        highSchool: _highSchoolController.text.trim(),
        graduationYear: _graduationYearController.text.trim(),
        gpa: _gpaController.text.trim(),
      ),
    );

    print('📝 Created inquiry object for: $fullName');
    print('📝 School: DLSHSI');
    print('📝 Email: ${_emailController.text.trim()}');
    
    // Add to service (this makes it available to admin dashboard)
    print('➡️ Adding inquiry to service...');
    _service.addInquiry(inquiry);
    
    // DEBUG: Print after adding
    print('🎯 After adding inquiry - Service instance check:');
    _service.debugPrintInstance();
    print('🎯 ========== DLSHSI SUBMIT APPLICATION COMPLETED ==========');

    // Print for debugging
    print('Application submitted:');
    print(inquiry.toJson());

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green, size: 32),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Application Submitted!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your application has been successfully submitted.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.confirmation_number, size: 16),
                      const SizedBox(width: 8),
                      const Text('Application ID: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(applicationId, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _emailController.text.trim(),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'We will review your application and respond to your inquiry within 5-7 business days via email.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}