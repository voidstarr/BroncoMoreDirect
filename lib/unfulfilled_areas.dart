import 'package:broncomoredirect_app/models/degree_path.dart';
import 'package:flutter/material.dart';
import 'area_courses.dart';
import 'course_sections.dart';
import 'api/bmd_api.dart';
import 'models/semester.dart';

class UnfulfilledAreasPage extends StatefulWidget {
  UnfulfilledAreasPage({
    Key? key,
    required this.degreePath,
    required this.semester,
  }) : super(key: key);

  final DegreePath degreePath;
  final Semester semester;

  @override
  _UnfulfilledAreasState createState() => _UnfulfilledAreasState();
}

class _UnfulfilledAreasState extends State<UnfulfilledAreasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unfulfilled Areas'),
      ),
      body: ListView(
        children: [
          for (var area in widget.degreePath.unfulfilledAreas)
            ListTile(
              title: Text(area.toUpperCase()),
              onTap: () {
                if (area.contains('ge')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AreaCoursesPage(
                        area: area.toUpperCase().split(' ')[1],
                        semester: widget.semester,
                        degreePath: widget.degreePath,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseSectionsPage(
                        course: area,
                        semester: widget.semester,
                        sections: fetchSections(
                          area.split(" ")[0].toUpperCase(),
                          area.split(" ")[1],
                          null,
                          widget.semester,
                        ),
                        degreePath: widget.degreePath,
                      ),
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
