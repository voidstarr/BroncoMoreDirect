import 'package:broncomoredirect_app/models/degree_path.dart';
import 'package:broncomoredirect_app/models/semester.dart';
import 'package:flutter/material.dart';
import 'api/bmd_api.dart';
import 'section.dart';

class SemesterPage extends StatefulWidget {
  SemesterPage({
    Key? key,
    required this.semester,
    required this.degreePath,
  }) : super(key: key);

  final Semester semester;
  final DegreePath degreePath;

  @override
  _SemesterState createState() => _SemesterState();
}

class _SemesterState extends State<SemesterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.semester.term} ${widget.semester.year}'),
      ),
      body: ListView(
        children: [
          Center(
            child: Text('${widget.semester.units} units'),
          ),
          for (var section in widget.semester.sections)
            ListTile(
              title: Text(section.title),
              subtitle: Text(
                  '${section.subject} ${section.catalogNumber}.${section.sectionNumber}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SectionPage(
                      section: section,
                      professorRating: fetchProfessorRating(
                        section.instructorLast,
                        section.instructorFirst,
                      ),
                      semester: widget.semester,
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
