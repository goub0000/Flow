/// Testimonials data for the home page.
///
/// Contains expanded testimonials with specific outcomes,
/// photo placeholders, and university affiliations.
class TestimonialData {
  final String name;
  final String role;
  final String university;
  final String quote;
  final String outcome;
  final String? photoUrl;
  final String country;

  const TestimonialData({
    required this.name,
    required this.role,
    required this.university,
    required this.quote,
    required this.outcome,
    this.photoUrl,
    required this.country,
  });
}

/// Pre-defined testimonials for the home page
class Testimonials {
  Testimonials._();

  static const List<TestimonialData> all = [
    TestimonialData(
      name: 'Amara Okafor',
      role: 'Student',
      university: 'University of Ghana',
      quote:
          'Flow helped me discover universities I never knew existed. The personalized recommendations matched my academic profile perfectly.',
      outcome: 'Got accepted to 3 universities with scholarships',
      country: 'Ghana',
    ),
    TestimonialData(
      name: 'Dr. James Mwangi',
      role: 'Dean of Admissions',
      university: 'Kenyatta University',
      quote:
          'We\'ve streamlined our entire admissions process with Flow. The platform has reduced our processing time by 60% while improving applicant quality.',
      outcome: 'Processed 5,000+ applications seamlessly',
      country: 'Kenya',
    ),
    TestimonialData(
      name: 'Fatima Diallo',
      role: 'Parent',
      university: 'Parent of 2 students',
      quote:
          'Being able to track my children\'s educational journey in real-time gives me peace of mind. I can support them even from a distance.',
      outcome: 'Both children accepted to top programs',
      country: 'Senegal',
    ),
    TestimonialData(
      name: 'Kofi Mensah',
      role: 'High School Counselor',
      university: 'Accra Academy',
      quote:
          'Flow\'s counselor tools have transformed how I guide students. I can now provide data-driven recommendations that actually lead to admissions.',
      outcome: '85% student admission success rate',
      country: 'Ghana',
    ),
    TestimonialData(
      name: 'Zainab Ahmed',
      role: 'Student',
      university: 'University of Lagos',
      quote:
          'The offline feature was a game-changer. I could study my options and prepare my applications even without internet access.',
      outcome: 'Admitted to dream medical program',
      country: 'Nigeria',
    ),
    TestimonialData(
      name: 'Prof. Sarah Kimani',
      role: 'Director of Enrollment',
      university: 'Ashesi University',
      quote:
          'Flow has become essential to our recruitment strategy. We\'re reaching qualified students from across the continent like never before.',
      outcome: '40% increase in diverse applicants',
      country: 'Ghana',
    ),
    TestimonialData(
      name: 'Emmanuel Banda',
      role: 'Student',
      university: 'University of Cape Town',
      quote:
          'The Find Your Path quiz was incredibly accurate. It suggested programs I hadn\'t considered but turned out to be perfect for my career goals.',
      outcome: 'Full scholarship to engineering program',
      country: 'Zambia',
    ),
    TestimonialData(
      name: 'Grace Okonkwo',
      role: 'Career Counselor',
      university: 'Lagos Business School',
      quote:
          'I recommend Flow to all my clients. The platform provides comprehensive university data that helps make informed decisions.',
      outcome: 'Helped 200+ professionals find MBA programs',
      country: 'Nigeria',
    ),
  ];

  /// Get testimonials by role type
  static List<TestimonialData> byRole(String role) {
    return all.where((t) => t.role.toLowerCase() == role.toLowerCase()).toList();
  }

  /// Get testimonials from students only
  static List<TestimonialData> get students => byRole('Student');

  /// Get testimonials from institutions only
  static List<TestimonialData> get institutions =>
      all.where((t) => t.role.contains('Dean') || t.role.contains('Director')).toList();

  /// Get featured testimonials (first 3)
  static List<TestimonialData> get featured => all.take(3).toList();
}

/// University logos/partners data
class UniversityPartner {
  final String name;
  final String? logoUrl;
  final String country;

  const UniversityPartner({
    required this.name,
    this.logoUrl,
    required this.country,
  });
}

/// Partner universities for social proof
class PartnerUniversities {
  PartnerUniversities._();

  static const List<UniversityPartner> all = [
    UniversityPartner(
      name: 'University of Ghana',
      country: 'Ghana',
    ),
    UniversityPartner(
      name: 'Ashesi University',
      country: 'Ghana',
    ),
    UniversityPartner(
      name: 'Kenyatta University',
      country: 'Kenya',
    ),
    UniversityPartner(
      name: 'University of Lagos',
      country: 'Nigeria',
    ),
    UniversityPartner(
      name: 'University of Cape Town',
      country: 'South Africa',
    ),
    UniversityPartner(
      name: 'Makerere University',
      country: 'Uganda',
    ),
    UniversityPartner(
      name: 'University of Nairobi',
      country: 'Kenya',
    ),
    UniversityPartner(
      name: 'Covenant University',
      country: 'Nigeria',
    ),
  ];
}
