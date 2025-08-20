import 'dart:convert';

GetLessons getLessonsFromJson(String str) => GetLessons.fromJson(json.decode(str));

String getLessonsToJson(GetLessons data) => json.encode(data.toJson());

class GetLessons {
  List<UnlockedLesson> unlockedLessons;

  GetLessons({
    required this.unlockedLessons,
  });

  factory GetLessons.fromJson(Map<String, dynamic> json) => GetLessons(
    unlockedLessons: List<UnlockedLesson>.from(json["unlockedLessons"].map((x) => UnlockedLesson.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "unlockedLessons": List<dynamic>.from(unlockedLessons.map((x) => x.toJson())),
  };
}

class UnlockedLesson {
  int id;
  String title;
  List<String> images;
  String videoUrl;
  dynamic pdfUrl;
  String description;
  bool isLocked;
  int courseId;
  DateTime createdAt;
  DateTime updatedAt;

  UnlockedLesson({
    required this.id,
    required this.title,
    required this.images,
    required this.videoUrl,
    required this.pdfUrl,
    required this.description,
    required this.isLocked,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UnlockedLesson.fromJson(Map<String, dynamic> json) => UnlockedLesson(
    id: json["id"],
    title: json["title"],
    images: List<String>.from(json["images"].map((x) => x)),
    videoUrl: json["videoUrl"],
    pdfUrl: json["pdfUrl"]??'',
    description: json["description"],
    isLocked: json["isLocked"],
    courseId: json["courseId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "images": List<dynamic>.from(images.map((x) => x)),
    "videoUrl": videoUrl,
    "pdfUrl": pdfUrl,
    "description": description,
    "isLocked": isLocked,
    "courseId": courseId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}



List<GetLessonsAdmin> getLessonsAdminFromJson(String str) => List<GetLessonsAdmin>.from(json.decode(str).map((x) => GetLessonsAdmin.fromJson(x)));

String getLessonsAdminToJson(List<GetLessonsAdmin> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetLessonsAdmin {
  int id;
  String title;
  List<String> images;
  String videoUrl;
  String pdfUrl;
  String description;
  int courseId;
  DateTime createdAt;
  DateTime updatedAt;

  GetLessonsAdmin({
    required this.id,
    required this.title,
    required this.images,
    required this.videoUrl,
    required this.pdfUrl,
    required this.description,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetLessonsAdmin.fromJson(Map<String, dynamic> json) => GetLessonsAdmin(
    id: json["id"],
    title: json["title"],
    images: List<String>.from(json["images"].map((x) => x)),
    videoUrl: json["videoUrl"],
    pdfUrl: json["pdfUrl"]??'',
    description: json["description"],
    courseId: json["courseId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "images": List<dynamic>.from(images.map((x) => x)),
    "videoUrl": videoUrl,
    "pdfUrl": pdfUrl,
    "description": description,
    "courseId": courseId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
