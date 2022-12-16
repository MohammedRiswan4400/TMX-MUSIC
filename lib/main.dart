import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmx_player/screen/splash_screen.dart';
import 'model/tmx_plater.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(SongsAdapter().typeId)) {
    Hive.registerAdapter(SongsAdapter());
  }
  await Hive.openBox<Songs>("AllSongs");
  await Hive.openBox<List>("Playlist");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TMX Music",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // textTheme: TextTheme(headline6: TextStyle(color: tmxWhite)),
        primaryColor: const Color.fromARGB(255, 21, 55, 77),
      ),
      home: const Spalash_screen(),
    );
  }
}
