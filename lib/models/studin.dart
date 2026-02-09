// studin.dart
// This model represents a student application/inquiry that will be used
// by both the application form and the admin dashboard

class StudentInquiry {
  final String id;
  final String studentName;
  final String email;
  final String phone;
  final String school;
  final String inquiry;
  final String date;
  String status; // 'Pending' or 'Responded'
  
  // Additional detailed information
  final PersonalInfo? personalInfo;
  final ContactInfo? contactInfo;
  final AcademicInfo? academicInfo;

  StudentInquiry({
    required this.id,
    required this.studentName,
    required this.email,
    required this.phone,
    required this.school,
    required this.inquiry,
    required this.date,
    this.status = 'Pending',
    this.personalInfo,
    this.contactInfo,
    this.academicInfo,
  });

  // Convert to JSON for storage/transmission
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentName': studentName,
      'email': email,
      'phone': phone,
      'school': school,
      'inquiry': inquiry,
      'date': date,
      'status': status,
      'personalInfo': personalInfo?.toJson(),
      'contactInfo': contactInfo?.toJson(),
      'academicInfo': academicInfo?.toJson(),
    };
  }

  // Create from JSON
  factory StudentInquiry.fromJson(Map<String, dynamic> json) {
    return StudentInquiry(
      id: json['id'] ?? '',
      studentName: json['studentName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      school: json['school'] ?? '',
      inquiry: json['inquiry'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'Pending',
      personalInfo: json['personalInfo'] != null 
          ? PersonalInfo.fromJson(json['personalInfo']) 
          : null,
      contactInfo: json['contactInfo'] != null 
          ? ContactInfo.fromJson(json['contactInfo']) 
          : null,
      academicInfo: json['academicInfo'] != null 
          ? AcademicInfo.fromJson(json['academicInfo']) 
          : null,
    );
  }

  // Create a copy with updated fields
  StudentInquiry copyWith({
    String? id,
    String? studentName,
    String? email,
    String? phone,
    String? school,
    String? inquiry,
    String? date,
    String? status,
    PersonalInfo? personalInfo,
    ContactInfo? contactInfo,
    AcademicInfo? academicInfo,
  }) {
    return StudentInquiry(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      school: school ?? this.school,
      inquiry: inquiry ?? this.inquiry,
      date: date ?? this.date,
      status: status ?? this.status,
      personalInfo: personalInfo ?? this.personalInfo,
      contactInfo: contactInfo ?? this.contactInfo,
      academicInfo: academicInfo ?? this.academicInfo,
    );
  }
}

class PersonalInfo {
  final String firstName;
  final String middleName;
  final String lastName;
  final String? birthDate;
  final String? gender;
  final String? civilStatus;

  PersonalInfo({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    this.birthDate,
    this.gender,
    this.civilStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'birthDate': birthDate,
      'gender': gender,
      'civilStatus': civilStatus,
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      birthDate: json['birthDate'],
      gender: json['gender'],
      civilStatus: json['civilStatus'],
    );
  }
}

class ContactInfo {
  final String address;
  final String city;
  final String zipCode;

  ContactInfo({
    required this.address,
    required this.city,
    required this.zipCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'zipCode': zipCode,
    };
  }

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      zipCode: json['zipCode'] ?? '',
    );
  }
}

class AcademicInfo {
  final String program;
  final String highSchool;
  final String graduationYear;
  final String gpa;

  AcademicInfo({
    required this.program,
    required this.highSchool,
    required this.graduationYear,
    required this.gpa,
  });

  Map<String, dynamic> toJson() {
    return {
      'program': program,
      'highSchool': highSchool,
      'graduationYear': graduationYear,
      'gpa': gpa,
    };
  }

  factory AcademicInfo.fromJson(Map<String, dynamic> json) {
    return AcademicInfo(
      program: json['program'] ?? '',
      highSchool: json['highSchool'] ?? '',
      graduationYear: json['graduationYear'] ?? '',
      gpa: json['gpa'] ?? '',
    );
  }
}