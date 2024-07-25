class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? dob;

  Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.dob,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      dob: json['dob'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dob': dob,
    };
  }
}
