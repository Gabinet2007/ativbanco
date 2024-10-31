class User {
  final int? id;
  final String carne;
  final int slider;
  final String data;
  final String hora;
  final String? ponto;

  User(
      {this.id,
      required this.carne,
      required this.slider,
      required this.data,
      required this.hora,
      this.ponto});

  User.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        carne = res["carne"],
        slider = res["slider"],
        data = res["data"],
        hora = res["hora"],
        ponto = res["ponto"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'carne': carne,
      'slider': slider,
      'data': data,
      'hora': hora,
      'ponto': ponto
    };
  }
}