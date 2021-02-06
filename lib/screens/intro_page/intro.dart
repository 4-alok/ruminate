import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 200,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Text(
              'Ruminate',
              style: Theme.of(context).textTheme.headline2,
            )),
          ),
          RaisedButton(
            color: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () async {
              var status = await Permission.storage.status;
              if (status.isUndetermined || status.isDenied) {
                await Permission.storage.request();
                if (await Permission.storage.status.isGranted) {
                  Box settingBox = Hive.box("setting");
                  settingBox.put('intro', 0);
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  Navigator.pop(context);
                }
              }
            },
            child: Icon(
              Icons.navigate_next,
              size: 100,
            ),
          )
        ],
      ),
    );
  }
}
