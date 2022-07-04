import 'package:flutter/material.dart';
import 'package:ruminate/core/di/di.dart';
import 'package:ruminate/core/services/hive_database/hive_database_impl.dart';

import 'base/action_icon.dart';

enum RefreshState { idle, scanning, fetchingMetadata }

class RefreshWidget extends StatelessWidget {
  const RefreshWidget({Key? key}) : super(key: key);

  HiveDatabase get hiveDatabase => locator.get<HiveDatabase>();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ValueListenableBuilder<RefreshState>(
          valueListenable: hiveDatabase.refreshState,
          builder: (context, value, child) {
            switch (value) {
              case RefreshState.idle:
                return refreshIcon;
              case RefreshState.scanning:
                return scanningWidget;
              case RefreshState.fetchingMetadata:
                return fetchingWidget;
            }
          },
        ),
      );

  Widget get fetchingWidget => ValueListenableBuilder<String?>(
      valueListenable: hiveDatabase.songScanned,
      builder: (context, value, child) => SizedBox(
          width: 200,
          child: Text(
            value ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          )));

  Widget get scanningWidget => SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Scanning..."),
            LinearProgressIndicator(backgroundColor: Colors.transparent),
          ],
        ),
      );

  Widget get refreshIcon => ActionIcon(
        child: const Icon(Icons.refresh),
        onTap: () => locator<HiveDatabase>().updateDatabase,
      );
}
