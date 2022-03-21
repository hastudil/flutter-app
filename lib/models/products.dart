class ProducstImported {
  final String id;
  final String comp;
  final String description;
  final String qty;

  ProducstImported(this.id, this.comp, this.description, this.qty);
  
  factory ProducstImported.fromJson(Map<String, dynamic> json) {
    return ProducstImported(
        "${json['id']}",
        "${json['comp']}",
        "${json['descrition']}",
        "${json['qty']}"
    );
  }

  Map<String,dynamic> toMap() => {
    "id": id,
    "comp": comp,
    "description": description,
    "qty": qty
  };
}