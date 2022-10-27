class TaskModel {
  TaskModel(
      {this.title,
      this.description,
      this.imageUrl,
      this.creationDate,
      this.docID});

  String? title;
  String? description;
  String? imageUrl;
  String? creationDate;
  String? docID;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        title: json["title"],
        docID: json["docID"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        creationDate: json["creationDate"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "docID": docID,
        "description": description,
        "imageUrl": imageUrl,
        "creationDate": creationDate,
      };
}
