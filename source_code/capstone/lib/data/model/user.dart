class Usera {
  String name;
  String images;
  String minat;
  String email;

  Usera({
    required this.email,
    required this.name,
    required this.minat,
    required this.images,
  });

  factory Usera.fromData(Map<String, dynamic> data) {
    return Usera(
      email: data['email'],
      images: data['images'],
      minat: data['minat'],
      name: data['name'],
    );
  }
}
