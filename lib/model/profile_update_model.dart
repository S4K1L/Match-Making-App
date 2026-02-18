class ProfileUpdateModel {
  final String? fullName;
  final String? username;
  final String? phone;
  final String? bio;
  final String? gender;
  final String? city;
  final String? province;
  final String? location;
  final int? distance;
  final int? heightFeet;
  final int? heightInches;
  final String? dob;
  final List<String>? brings;
  final List<String>? that;
  final List<String>? lookingFor;
  final List<String>? professionalField;
  final List<String>? interests;
  final List<String>? lifestyle;
  final List<String>? hobbies;

  ProfileUpdateModel({
    this.fullName,
    this.username,
    this.phone,
    this.bio,
    this.gender,
    this.city,
    this.province,
    this.location,
    this.distance,
    this.heightFeet,
    this.heightInches,
    this.dob,
    this.brings,
    this.that,
    this.lookingFor,
    this.professionalField,
    this.interests,
    this.lifestyle,
    this.hobbies,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    // Add fields to the map only if they are non-null and non-empty
    if (fullName != null && fullName!.isNotEmpty) map['full_name'] = fullName;
    if (username != null && username!.isNotEmpty) map['username'] = username;
    if (phone != null && phone!.isNotEmpty) map['phone'] = phone;
    if (bio != null && bio!.isNotEmpty) map['bio'] = bio;
    if (gender != null && gender!.isNotEmpty) {
      map['gender'] = gender!.toUpperCase(); // Uppercase if required by the API
    }
    if (city != null && city!.isNotEmpty) map['city'] = city;
    if (province != null && province!.isNotEmpty) map['province'] = province;
    if (location != null && location!.isNotEmpty) map['location'] = location;
    if (distance != null) map['distance'] = distance;
    if (heightFeet != null) map['height_feet'] = heightFeet;
    if (heightInches != null) map['height_inches'] = heightInches;
    if (dob != null && dob!.isNotEmpty) map['dob'] = dob;

    // Convert lists to uppercase where necessary and add to the map
    if (brings != null && brings!.isNotEmpty) {
      map['brings'] = brings!.map((e) => e.toUpperCase()).toList();
    }
    if (that != null && that!.isNotEmpty) {
      map['that'] = that!
          .map((e) => e.toUpperCase().replaceAll(' ', '_'))
          .toList();
    }
    if (lookingFor != null && lookingFor!.isNotEmpty)
      map['looking_for'] = lookingFor;
    if (professionalField != null && professionalField!.isNotEmpty) {
      map['professional_field'] = professionalField;
    }
    if (interests != null && interests!.isNotEmpty)
      map['interests'] = interests;
    if (lifestyle != null && lifestyle!.isNotEmpty)
      map['lifestyle'] = lifestyle;
    if (hobbies != null && hobbies!.isNotEmpty) map['hobbies'] = hobbies;

    return map;
  }
}
