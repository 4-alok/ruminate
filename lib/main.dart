import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'models/data_model.dart';
import 'screens/home/home_page.dart';
import 'screens/home/search_page.dart';
import 'screens/intro_page/intro.dart';

Box settingBox;
LazyBox thumb;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final doc = await getApplicationDocumentsDirectory();
  Hive.init(doc.path);
  Hive.registerAdapter(DataModelAdapter());
  settingBox = await Hive.openBox("setting");
  await Hive.openBox<DataModel>("data");
  thumb = await Hive.openLazyBox('thumbnail');
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
          primaryColor: Colors.black),
      initialRoute: settingBox.isEmpty ? '/intro' : '/home',
      // home: TestPage(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => HomePage(),
        '/setting': (context) => Scaffold(),
        '/intro': (context) => IntroPage(),
        '/search': (context) => SearchPage()
      },
    );
  }
}
