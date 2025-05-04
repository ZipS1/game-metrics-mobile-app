class Activity {
  final int id;
  final String name;

  Activity(this.id, this.name);

  static Activity fromJson(json) {
    return Activity(json["id"], json["name"]);
  }
}
