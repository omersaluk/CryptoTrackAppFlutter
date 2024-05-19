import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_app_flutter/pages/home_page.dart';
import 'package:track_app_flutter/utils.dart';

void main() async {
  await registerService();
  await registerControllers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratAlternatesTextTheme(),
      ),
      routes: {
        "/home": (context) => HomePage(),
      },
      initialRoute: "/home",
    );
  }
}
