import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'api/bmd_api.dart';
import 'course_sections.dart';
import 'models/degree_path.dart';
import 'models/semester.dart';

class AreaCoursesPage extends StatefulWidget {
  AreaCoursesPage({
    Key? key,
    required this.area,
    required this.semester,
    required this.degreePath,
  }) : super(key: key);

  final String area;
  final Semester semester;
  final DegreePath degreePath;

  @override
  _AreaCoursesState createState() => _AreaCoursesState();
}

class _AreaCoursesState extends State<AreaCoursesPage> {
  List<String> courses = [];

  void _loadGEs() async {
    rootBundle.loadString('assets/degree_requirements/ge.json').then((str) {
      Map<String, dynamic> json = jsonDecode(str);
      setState(() {
        courses = (json[widget.area] as List<dynamic>)
            .map((e) => (e as String).toUpperCase())
            .toList();
      });
    });
  }

  @override
  initState() {
    _loadGEs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.area} Courses'),
      ),
      body: ListView(
        children: [
          for (var course in courses)
            ListTile(
              title: Text(course),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseSectionsPage(
                      course: widget.area,
                      semester: widget.semester,
                      sections: fetchSections(
                        course.split(" ")[0].toUpperCase(),
                        course.split(" ")[1],
                        widget.area,
                        widget.semester,
                      ),
                      degreePath: widget.degreePath,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
