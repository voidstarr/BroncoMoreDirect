import 'dart:async';

import 'package:broncomoredirect_app/models/degree_path.dart';
import 'package:broncomoredirect_app/models/semester.dart';
import 'package:flutter/material.dart';

import 'models/section.dart';
import 'models/professor_rating.dart';

class SectionPage extends StatefulWidget {
  SectionPage({
    Key? key,
    required this.section,
    required this.professorRating,
    required this.semester,
    required this.degreePath,
  }) : super(key: key);

  final DegreePath degreePath;
  final Semester semester;
  final CourseSection section;
  final Future<ProfessorRating> professorRating;

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<SectionPage> {
  @override
  void initState() {
    super.initState();
    print(widget.degreePath.toJson().toString());
  }

  void _addSection() {
    widget.degreePath.add(widget.semester, widget.section);
    Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
  }

  void _removeSection() {
    widget.degreePath.remove(widget.semester, widget.section);
    Navigator.pop(context);
  }

  Widget actionButton() {
    if (widget.degreePath.contains(widget.section)) {
      return FloatingActionButton(
        onPressed: _removeSection,
        tooltip: 'Remove from Semester',
        child: Icon(Icons.remove),
      );
    } else {
      return FloatingActionButton(
        onPressed: _addSection,
        tooltip: 'Add to Semester',
        child: Icon(Icons.add),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfessorRating>(
      future: widget.professorRating,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final professorRating = snapshot.data;
          if (professorRating == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text('${widget.section.title}'),
              ),
              body: Center(
                child: Text('Something went wrong'),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('${widget.section.title}'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      '${widget.section.subject} ${widget.section.catalogNumber}.${widget.section.sectionNumber}'),
                  Text('${widget.section.title}'),
                  if (widget.section.generalEducationArea != null)
                    Text('GE Area: ${widget.section.generalEducationArea}'),
                  Text('Class number: ${widget.section.classNumber}'),
                  Text('Units: ${widget.section.units}'),
                  Text('Time: ${widget.section.time}'),
                  Text(
                      'Location: ${widget.section.location == "" ? widget.section.location : "TBA"}'),
                  Text('Mode: ${widget.section.mode}'),
                  Text('Component: ${widget.section.component}'),
                  Text(
                      '${widget.section.instructorLast}, ${widget.section.instructorFirst}: ${professorRating.professorRating}/5'),
                  Text('Average GradeTier GPA: Coming soon!'),
                ],
              ),
            ),
            floatingActionButton: actionButton(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('${widget.section.title}'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
