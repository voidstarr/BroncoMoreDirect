import 'package:broncomoredirect_app/models/degree_path.dart';
import 'package:broncomoredirect_app/models/section.dart';
import 'package:broncomoredirect_app/models/semester.dart';
import 'package:flutter/material.dart';
import 'api/bmd_api.dart';
import 'section.dart';

class CourseSectionsPage extends StatefulWidget {
  CourseSectionsPage({
    Key? key,
    required this.course,
    required this.semester,
    required this.sections,
    required this.degreePath,
  }) : super(key: key);

  final String course;
  final Semester semester;
  final DegreePath degreePath;
  Future<List<CourseSection>> sections;

  @override
  _CourseSectionsState createState() => _CourseSectionsState();
}

class _CourseSectionsState extends State<CourseSectionsPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CourseSection>>(
        future: widget.sections,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final sections = snapshot.data;
            if (sections == null) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('${widget.course} Sections'),
                ),
                body: Center(
                  child: Text('Something went wrong'),
                ),
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(
                    '${widget.course} Sections ${widget.semester.term} ${widget.semester.year}'),
              ),
              body: ListView(children: [
                for (var section in sections)
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
                                section.instructorFirst),
                            semester: widget.semester,
                            degreePath: widget.degreePath,
                          ),
                        ),
                      );
                    },
                  ),
              ]),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('${widget.course} Sections'),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
