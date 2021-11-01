import 'dart:io';
import 'dart:convert';

import 'package:broncomoredirect_app/models/section.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'semester.g.dart';

@JsonSerializable(explicitToJson: true)
class Semester {
  List<CourseSection> sections = [];
  String term;
  int year;

  String get shortId {
    return '${term.substring(0, 2)}${year.toString().substring(2, 4)}';
  }

  int get units {
    return this.sections.fold(0, (int p, c) => p + c.units);
  }

  Semester.withoutSections({
    required this.term,
    required this.year,
  });

  Semester({
    required this.term,
    required this.year,
    required this.sections,
  });

  factory Semester.fromJson(Map<String, dynamic> json) =>
      _$SemesterFromJson(json);

  Map<String, dynamic> toJson() => _$SemesterToJson(this);

  static Semester nextSemester(Semester semester) {
    String nextTerm = 'FALL';
    int nextYear = semester.year;
    switch (semester.term.toUpperCase()) {
      case 'SPRING':
        nextTerm = 'SUMMER';
        break;
      case 'SUMMER':
        nextTerm = 'FALL';
        break;
      case 'FALL':
        nextTerm = 'WINTER';
        nextYear = 1;
        break;
      case 'WINTER':
        nextTerm = 'SPRING';
        break;
    }
    return Semester.withoutSections(term: nextTerm, year: nextYear);
  }

  bool contains(CourseSection section) {
    return sections.contains(section);
  }
}
