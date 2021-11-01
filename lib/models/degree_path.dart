import 'dart:convert';
import 'dart:io';

import 'package:broncomoredirect_app/models/section.dart';
import 'package:broncomoredirect_app/models/semester.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'degree_path.g.dart';

@JsonSerializable(explicitToJson: true)
class DegreePath {
  String major;
  String degree;
  List<String> unfulfilledAreas = [];
  Map<String, Semester> semesters = Map();
  int? _unitsCompleted;
  int? _unitsRequired;
  double? gpa;

  int get unitsCompleted {
    return _unitsCompleted ?? 0;
  }

  int get unitsRequired {
    return _unitsRequired ?? 0;
  }

  DegreePath(
      {required this.major,
      required this.degree,
      required this.unfulfilledAreas,
      required this.semesters});

  DegreePath.withoutAreas({required this.major, required this.degree}) {
    rootBundle
        .loadString(
            'assets/degree_requirements/${major.toLowerCase().replaceAll(" ", "_")}_${degree.toLowerCase()}.json')
        .then((str) {
      Map<String, dynamic> json = jsonDecode(str);
      List<String> reqd =
          (json['required'] as List<dynamic>).map((e) => e as String).toList();
      for (var req in reqd) {
        bool found = false;
        for (var semester in semesters.values) {
          for (var section in semester.sections) {
            if ('${section.subject} ${section.catalogNumber}'.toLowerCase() ==
                req) {
              found = true;
              break;
            }
          }
          if (found) break;
        }
        if (!found) unfulfilledAreas.add(req.toLowerCase());
      }
      //TODO: electives
    });
  }

  factory DegreePath.fromJson(Map<String, dynamic> json) =>
      _$DegreePathFromJson(json);

  Map<String, dynamic> toJson() => _$DegreePathToJson(this);

  static Future<DegreePath> load(String major, String degree) async {
    final directory = await getApplicationDocumentsDirectory();
    File degreePathFile = new File(
        '${directory.path}/${major.toLowerCase().replaceAll(" ", "_")}_${degree.toLowerCase()}.json');
    if (!await degreePathFile.exists()) {
      return DegreePath.withoutAreas(major: 'Computer Science', degree: 'BS');
    } else {
      return DegreePath.fromJson(
          jsonDecode(await degreePathFile.readAsString()));
    }
  }

  void save() {
    getApplicationDocumentsDirectory().then((dir) {
      File degreePathFile = new File(
          '${dir.path}/${major.toLowerCase().replaceAll(" ", "_")}_${degree.toLowerCase()}.json');
      degreePathFile.writeAsString(jsonEncode(toJson()));
    });
  }

  bool contains(CourseSection section) {
    return semesters.values
            .where((semester) => semester.contains(section))
            .length !=
        0;
  }

  Semester getSemester(String term, int year) {
    if (semesters['${term.toLowerCase()}$year'] == null)
      semesters['${term.toLowerCase()}$year'] =
          Semester.withoutSections(term: term, year: year);

    return semesters['${term.toLowerCase()}$year'] ??
        Semester.withoutSections(term: term, year: year);
  }

  void add(Semester semester, CourseSection section) {
    semester.sections.add(section);
    // TODO: if GE remove GE area
    unfulfilledAreas.remove(
        '${section.subject.toLowerCase()} ${section.catalogNumber.toLowerCase()}');
    save();
  }

  void remove(Semester semester, CourseSection section) {
    if (semester.sections.remove(section)) {
      // TODO: if GE add GE area
      unfulfilledAreas.add(
          '${section.subject.toLowerCase()} ${section.catalogNumber.toLowerCase()}');
      save();
    }
  }
}
