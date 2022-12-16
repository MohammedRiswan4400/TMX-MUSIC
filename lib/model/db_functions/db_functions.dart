import 'package:hive_flutter/hive_flutter.dart';

import '../tmx_plater.dart';

Box<Songs> getSongBox() {
  return Hive.box<Songs>("AllSongs");
}

Box<List> getPlaylitBox() {
  return Hive.box<List>("Playlist");
}
