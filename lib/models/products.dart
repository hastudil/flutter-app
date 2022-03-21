class ProducstImported {
  final String id;
  final String comp;
  final String description;
  final String qty;

  /*ProducstImported.fromMap(Map<String, dynamic> data){
    id = data['id'];
    comp = data['comp'];
    description = data['description'];
    qty = data['qty'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name':comp,
      'categories': description,
      'qty': qty
    };
  }*/

  ProducstImported(this.id, this.comp, this.description, this.qty);

  /*ProducstImported.fromJson(Map<String, dynamic> json) : 
    id = json['id'],
    comp = json['comp'],
    description = json['description'],
    qty = json['qty'];*/

  //factory ProducstImported.fromJson(dynamic json) {
  factory ProducstImported.fromJson(Map<String, dynamic> json) {
    return ProducstImported(
        "${json['id']}",
        "${json['comp']}",
        "${json['descrition']}",
        "${json['qty']}"
    );
  }

  // Method to make GET parameters.
  /*Map toJson() => {
    'name': id,
    'email': comp,
    'mobileNo': description,
    'feedback': qty
  };*/

  Map<String,dynamic> toMap() => {
    "id": id,
    "comp": comp,
    "description": description,
    "qty": qty
  };
}