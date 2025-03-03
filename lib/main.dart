import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

import 'app/routes/app_pages.dart';

void main() {
  // checkDebugMode();
  runApp(MyApp());
}

void checkDebugMode() {
  bool isDebug = false;
  assert(isDebug = true);
  if (isDebug) {
    developer.log("Debug mode detected! Exiting...");
    exit(0);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }
Future<void> _checkForUpdate() async {
  try{
    AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable){
      InAppUpdate.performImmediateUpdate();
    }
  } catch (e){
    print("Update check failed: $e");
  }
}
  
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}