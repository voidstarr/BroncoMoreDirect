import 'package:broncomoredirect_app/models/section.dart';
import 'package:broncomoredirect_app/models/professor_rating.dart';
import 'package:broncomoredirect_app/models/semester.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

final String API_BASE = 'http://bmd.voidstar.tv:8080/api/v1';

Future<List<CourseSection>> fetchSections(
  String subject,
  String catalogNumber,
  String? generalEducationArea,
  Semester semester,
) async {
  final response = await http.get(Uri.parse(
      '$API_BASE/sections/$subject/$catalogNumber/${semester.shortId}'));
  print(
      'request to $API_BASE/sections/$subject/$catalogNumber/${semester.shortId}');
  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<CourseSection>((json) {
      var course = CourseSection.fromJson(json);
      course.generalEducationArea = generalEducationArea;
      return course;
    }).toList();
  } else {
    return [
      CourseSection(
        subject: "Unable to fetch section information from API",
        catalogNumber: "",
        sectionNumber: "",
        classNumber: "",
        title: "",
        units: 0,
        time: "",
        capacity: 0,
        location: "",
        date: "",
        instructorLast: "",
        instructorFirst: "",
        mode: "",
        session: "",
        component: "",
      ),
    ];
  }
}

Future<ProfessorRating> fetchProfessorRating(
  String professorLast,
  String professorFirst,
) async {
  final response = await http.get(
      Uri.parse('$API_BASE/rating/professor/$professorLast/$professorFirst'));
  print('request to $API_BASE/rating/professor/$professorLast/$professorFirst');
  if (response.statusCode == 200) {
    return ProfessorRating.fromJson(jsonDecode(response.body));
  } else {
    return ProfessorRating(
      professorFirst: "",
      professorLast: "",
      id: "",
      legacyId: "",
      professorRating: "",
    );
  }
}
