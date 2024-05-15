import "package:isar/isar.dart";


// this line is needed to generate the file
// then run: dart run build_runner build
part 'notes.g.dart'; 

@collection
class Note{
  Id id = Isar.autoIncrement;
  late String text;
} 