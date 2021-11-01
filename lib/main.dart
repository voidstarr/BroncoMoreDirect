import 'package:broncomoredirect_app/models/degree_path.dart';
import 'package:broncomoredirect_app/semester.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/semester.dart';
import 'unfulfilled_areas.dart';

void main() {
  runApp(BMDApp());
}

class BMDApp extends StatelessWidget {
  // "Global class"
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BroncoMoreDirect',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF129CAF, {
          50: Color.fromRGBO(18, 156, 175, .1),
          100: Color.fromRGBO(18, 156, 175, .2),
          200: Color.fromRGBO(18, 156, 175, .3),
          300: Color.fromRGBO(18, 156, 175, .4),
          400: Color.fromRGBO(18, 156, 175, .5),
          500: Color.fromRGBO(18, 156, 175, .6),
          600: Color.fromRGBO(18, 156, 175, .7),
          700: Color.fromRGBO(18, 156, 175, .8),
          800: Color.fromRGBO(18, 156, 175, .9),
          900: Color.fromRGBO(18, 156, 175, 1),
        }),
      ),
      home: BMDHomePage(title: 'BroncoMoreDirect'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BMDHomePage extends StatefulWidget {
  BMDHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _BMDHomePageState createState() => _BMDHomePageState();
}

class _BMDHomePageState extends State<BMDHomePage> {
  DegreePath _degreePath =
      DegreePath.withoutAreas(major: 'Computer Science', degree: 'BS');

  Semester _semester = Semester.withoutSections(term: 'PLACEHOLDER', year: 0);

  @override
  initState() {
    _loadDegree();
    super.initState();
  }

  void _loadDegree() async {
    final prefs = await SharedPreferences.getInstance();
    String major = prefs.getString('major') ?? 'Computer Science';
    String degree = prefs.getString('degree') ?? 'BS';

    DateTime now = DateTime.now();
    String nowTerm;
    int nowYear = now.year;
    if (now.month <= 5) {
      nowTerm = 'Spring';
    } else {
      nowTerm = 'Fall';
    }

    String term = prefs.getString('term') ?? nowTerm;
    int year = prefs.getInt('year') ?? nowYear;

    DegreePath.load(major, degree).then((degreePath) {
      setState(() {
        _degreePath = degreePath;
        prefs.setString('major', major);
        prefs.setString('degree', degree);

        _semester = _degreePath.getSemester(term, year);
        prefs.setString('term', term);
        prefs.setInt('year', year);
      });
    });
  }

  Future<void> _nextSemester() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String nowTerm;
    int nowYear = now.year;
    if (now.month <= 5) {
      nowTerm = 'Spring';
    } else {
      nowTerm = 'Fall';
    }

    String term = prefs.getString('term') ?? nowTerm;
    int year = prefs.getInt('year') ?? nowYear;
    String nextTerm = (term.toUpperCase() == 'FALL') ? 'Spring' : 'Fall';
    int nextYear = (term.toUpperCase() == 'FALL') ? year + 1 : year;
    print('_nextSemester:');
    print('term: $term, year: $year, nextTerm: $nextTerm, nextYear: $nextYear');

    setState(() {
      _semester = _degreePath.getSemester(nextTerm, nextYear);
      prefs.setString('term', nextTerm);
      prefs.setInt('year', nextYear);
    });
  }

  Future<void> _previousSemester() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String nowTerm;
    int nowYear = now.year;
    if (now.month <= 5) {
      nowTerm = 'Spring';
    } else {
      nowTerm = 'Fall';
    }

    String term = prefs.getString('term') ?? nowTerm;
    int year = prefs.getInt('year') ?? nowYear;
    String prevTerm = (term.toUpperCase() == 'FALL') ? 'Spring' : 'Fall';
    int prevYear = (term.toUpperCase() == 'FALL') ? year : year - 1;
    print('_previousSemester:');
    print('term: $term, year: $year, prevTerm: $prevTerm, prevYear: $prevYear');

    setState(() {
      _semester = _degreePath.getSemester(prevTerm, prevYear);
      prefs.setString('term', prevTerm);
      prefs.setInt('year', prevYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Degree Path'),
            Container(
              width: 300,
              height: 200,
              margin: EdgeInsets.all(10),
              child: Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UnfulfilledAreasPage(
                          degreePath: _degreePath,
                          semester: _semester,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${_degreePath.major} ${_degreePath.degree}'),
                      Text(
                          '${_degreePath.unitsCompleted}/${_degreePath.unitsRequired} units'),
                      Text('GPA: TBD'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
            Text('Schedule'),
            Container(
              width: 300,
              height: 200,
              margin: EdgeInsets.all(10),
              child: Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SemesterPage(
                          semester: _semester,
                          degreePath: _degreePath,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: _previousSemester,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${_semester.term} ${_semester.year}'),
                          Text('${_semester.units} units'),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: _nextSemester,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
