import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_sql/splash.dart';

import 'Task/view.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseHelper = DatabaseHelper();
  await databaseHelper.initializeDatabase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splash(),
  ));
}
