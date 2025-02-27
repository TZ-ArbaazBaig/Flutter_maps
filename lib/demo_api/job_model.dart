class JobM {
  String? name;
  String? job;
  String? id;
  String? createdAt;

  JobM({this.name, this.job, this.id, this.createdAt});

  JobM.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    job = json['job'];
    id = json['id'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['job'] = job;
    data['id'] = id;
    data['createdAt'] = createdAt;
    return data;
  }
}
