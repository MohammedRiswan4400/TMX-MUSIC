import 'package:hive_flutter/adapters.dart';

part 'tmx_plater.g.dart';

@HiveType(typeId: 1)
class Songs {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String songname;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String uri;

  @HiveField(4)
  int count;

  Songs({
    required this.id,
    required this.songname,
    required this.artist,
    required this.uri,
    this.count = 0,
  });
}
