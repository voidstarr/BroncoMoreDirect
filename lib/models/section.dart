import 'package:json_annotation/json_annotation.dart';

part 'section.g.dart';

@JsonSerializable()
class CourseSection {
  String subject;
  String catalogNumber;
  String sectionNumber;
  String classNumber;
  int capacity;
  String title;
  int units;
  String time;
  String location;
  String date;
  String instructorLast;
  String instructorFirst;
  String mode;
  String session;
  String component;
  String? generalEducationArea;

  CourseSection({
    required this.subject,
    required this.catalogNumber,
    required this.sectionNumber,
    required this.classNumber,
    required this.title,
    required this.units,
    required this.time,
    required this.capacity,
    required this.location,
    required this.date,
    required this.instructorLast,
    required this.instructorFirst,
    required this.mode,
    required this.session,
    required this.component,
  });

  factory CourseSection.fromJson(Map<String, dynamic> json) =>
      _$CourseSectionFromJson(json);

  Map<String, dynamic> toJson() => _$CourseSectionToJson(this);
}
