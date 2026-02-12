import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/studin.dart';

class StudentInquiryService {
  static final StudentInquiryService _instance = StudentInquiryService._internal();
  factory StudentInquiryService() => _instance;
  StudentInquiryService._internal();

  final _supabase = Supabase.instance.client;

  Future<void> loadInquiries() async {
    print('📂 Loading inquiries from Supabase...');
    // No local cache needed — fetch when needed
  }

  Future<void> addInquiry(StudentInquiry inquiry) async {
    try {
      // Parse the date string to DateTime, then convert to ISO string for PostgreSQL timestamp
      DateTime dateTime;
      try {
        dateTime = DateTime.parse(inquiry.date);
      } catch (e) {
        print('⚠️ Could not parse date, using current time: $e');
        dateTime = DateTime.now();
      }

      await _supabase.from('student_inquiries').insert({
        'id': inquiry.id,
        'student_name': inquiry.studentName,
        'email': inquiry.email,
        'phone': inquiry.phone,
        'school': inquiry.school,
        'inquiry': inquiry.inquiry,
        'date': dateTime.toIso8601String(), // Convert to proper timestamp format
        'status': inquiry.status,
        'personal_info': inquiry.personalInfo?.toJson(),
        'contact_info': inquiry.contactInfo?.toJson(),
        'academic_info': inquiry.academicInfo?.toJson(),
      });
      print('✅ Inquiry saved to Supabase!');
      print('📅 Date saved: ${dateTime.toIso8601String()}');
    } catch (e) {
      print('❌ Error saving inquiry: $e');
      rethrow;
    }
  }

  Future<List<StudentInquiry>> getAllInquiries() async {
    final response = await _supabase
        .from('student_inquiries')
        .select()
        .order('date', ascending: false);

    return response.map<StudentInquiry>((json) {
      return StudentInquiry.fromJson(json);
    }).toList();
  }

  Future<List<StudentInquiry>> getInquiriesBySchool(String school) async {
    final response = await _supabase
        .from('student_inquiries')
        .select()
        .eq('school', school)
        .order('date', ascending: false);

    return response.map<StudentInquiry>((json) {
      return StudentInquiry.fromJson(json);
    }).toList();
  }

  Future<Map<String, int>> getStatistics({String? school}) async {
    final List<dynamic> data;

    if (school == null || school == 'All Schools') {
      data = await _supabase.from('student_inquiries').select('status');
    } else {
      data = await _supabase
          .from('student_inquiries')
          .select('status')
          .eq('school', school);
    }

    int total = data.length;
    int pending = data.where((i) => i['status'] == 'Pending').length;
    int responded = data.where((i) => i['status'] == 'Responded').length;

    return {
      'total': total,
      'pending': pending,
      'responded': responded,
    };
  }

  Future<void> updateInquiryStatus(String id, String newStatus) async {
    try {
      await _supabase
          .from('student_inquiries')
          .update({'status': newStatus})
          .eq('id', id);
      print('✅ Status updated in Supabase!');
    } catch (e) {
      print('❌ Error updating status: $e');
      rethrow;
    }
  }

  String generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'APP-$timestamp';
  }
}