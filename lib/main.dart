import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:ruminate/screens/home/home_page.dart';
import 'package:ruminate/screens/intro_page/intro.dart';
import 'models/data_model.dart';

Box settingBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final doc = await getApplicationDocumentsDirectory();
  Hive.init(doc.path);
  Hive.registerAdapter(DataModelAdapter());
  await Hive.openBox("setting");
  settingBox = Hive.box("setting");
  await Hive.openBox<DataModel>("data");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
        primaryColor: Colors.black
        ),
      initialRoute: settingBox.isEmpty ? '/intro' : '/home',
      // home: TestPage(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => HomePage(),
        '/setting': (context) => Scaffold(),
        '/intro': (context) => IntroPage(),
      },
    );
  }
}

