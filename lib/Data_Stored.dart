import 'package:hive/hive.dart';
part 'Data_Stored.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject
{
  @HiveField(0)
  String name;
  @HiveField(1)
  String contact;
  @HiveField(2)
  String email;

  Student(this.name,this.contact,this.email);

    @override
    String toString() {
    return 'Student{name:$name, contact: $contact, email: $email}';
  }
}