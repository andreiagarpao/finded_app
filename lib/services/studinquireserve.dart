import '../models/studin.dart';
import '../storage/local_storage.dart';
import 'dart:convert';

class StudentInquiryService {
  // SINGLETON PATTERN - This ensures only ONE instance exists
  static final StudentInquiryService _instance = StudentInquiryService._internal();
  
  // Factory constructor returns the same instance every time
  factory StudentInquiryService() {
    return _instance;
  }
  
  // Private constructor
  StudentInquiryService._internal();
  
  // The single shared list of inquiries
  final List<StudentInquiry> _inquiries = [];

  // NEW: Load inquiries from local storage
  Future<void> loadInquiries() async {
    print('📂 Loading inquiries from storage...');
    List<String>? savedInquiries = LocalStorageService.getStringList('inquiries');
    
    if (savedInquiries != null && savedInquiries.isNotEmpty) {
      _inquiries.clear();
      for (String jsonStr in savedInquiries) {
        try {
          Map<String, dynamic> json = jsonDecode(jsonStr);
          _inquiries.add(StudentInquiry.fromJson(json));
        } catch (e) {
          print('❌ Error loading inquiry: $e');
        }
      }
      print('✅ Loaded ${_inquiries.length} inquiries from storage');
    } else {
      print('ℹ️ No saved inquiries found in storage');
    }
  }

  // NEW: Save inquiries to local storage
  Future<void> _saveInquiries() async {
    List<String> jsonList = _inquiries.map((inquiry) {
      return jsonEncode(inquiry.toJson());
    }).toList();
    
    await LocalStorageService.saveStringList('inquiries', jsonList);
    print('💾 Saved ${jsonList.length} inquiries to storage');
  }

  // MODIFIED: Add inquiry and save to storage
  void addInquiry(StudentInquiry inquiry) {
    _inquiries.add(inquiry);
    _saveInquiries(); // Save immediately
    print('✅ Inquiry added! Total inquiries: ${_inquiries.length}');
    print('📝 Student: ${inquiry.studentName}');
    print('🏫 School: ${inquiry.school}');
  }

  List<StudentInquiry> getAllInquiries() {
    print('📊 Getting all inquiries. Total: ${_inquiries.length}');
    return List.unmodifiable(_inquiries);
  }

  List<StudentInquiry> getInquiriesBySchool(String school) {
    print('🔍 Filtering inquiries for school: $school');
    if (school == 'All Schools') {
      print('   → Returning all ${_inquiries.length} inquiries');
      return getAllInquiries();
    }
    final filtered = _inquiries.where((inquiry) => inquiry.school == school).toList();
    print('   → Found ${filtered.length} inquiries for $school');
    return filtered;
  }

  Map<String, int> getStatistics({String? school}) {
    List<StudentInquiry> inquiriesToCount;
    
    if (school == null || school == 'All Schools') {
      inquiriesToCount = _inquiries;
    } else {
      inquiriesToCount = _inquiries.where((i) => i.school == school).toList();
    }

    int total = inquiriesToCount.length;
    int pending = inquiriesToCount.where((i) => i.status == 'Pending').length;
    int responded = inquiriesToCount.where((i) => i.status == 'Responded').length;

    print('📈 Statistics for ${school ?? "All Schools"}: Total=$total, Pending=$pending, Responded=$responded');

    return {
      'total': total,
      'pending': pending,
      'responded': responded,
    };
  }

  // MODIFIED: Update status and save to storage
  void updateInquiryStatus(String id, String newStatus) {
    final index = _inquiries.indexWhere((inquiry) => inquiry.id == id);
    if (index != -1) {
      _inquiries[index] = StudentInquiry(
        id: _inquiries[index].id,
        studentName: _inquiries[index].studentName,
        email: _inquiries[index].email,
        phone: _inquiries[index].phone,
        school: _inquiries[index].school,
        inquiry: _inquiries[index].inquiry,
        date: _inquiries[index].date,
        status: newStatus,
        personalInfo: _inquiries[index].personalInfo,
        contactInfo: _inquiries[index].contactInfo,
        academicInfo: _inquiries[index].academicInfo,
      );
      _saveInquiries(); // Save immediately after update
      print('✅ Status updated for inquiry $id to $newStatus');
    } else {
      print('❌ Could not find inquiry with id $id');
    }
  }

  String generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'APP-$timestamp';
  }

  // Debug method to check service instance
  void debugPrintInstance() {
    print('🔧 Service instance hashCode: ${hashCode}');
    print('🔧 Total inquiries in this instance: ${_inquiries.length}');
  }
}