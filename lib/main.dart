import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_db/Data_Stored.dart';
import 'package:hive_db/SecondPage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'Pdf Generate/Pdf Detail.dart';

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentsDir.path);
  Hive.registerAdapter(StudentAdapter());
  var mybox = await Hive.openBox('HiveData');

  runApp( MaterialApp(home: PdfDataPage(),debugShowCheckedModeBanner: false,));
}

// 1. Hive : Home()
// 2. Pdf  : PdfDataPage()

class Home extends StatefulWidget {
    Student? s;
   Home([this.s]);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final TextEditingController _name = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _email = TextEditingController();
  Box mybox = Hive.box("HiveData");

  @override
  void initState() {
    super.initState();
    if(widget.s!=null)
      {
        _name.text=widget.s!.name;
        _contact.text=widget.s!.contact;
        _email.text=widget.s!.email;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.s!=null ? "Update Hive DB" :"Add Hive DB"),
        actions: [
          IconButton(onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SecondPage();
            },));
          }, icon: const Icon(Icons.arrow_circle_right))
        ],
      ),
     /* floatingActionButton: FloatingActionButton(onPressed: () {
        showform(context, null);
      },child: Icon(Icons.add)),*/

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(6, 6),
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: _name,
                  decoration:  const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Enter name")
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: _contact,
                  keyboardType: TextInputType.phone,
                  decoration:  const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Enter Contact")
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration:  const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Enter Email")
                  ),
                ),
              ),
              const SizedBox(height: 50,),

              ElevatedButton(onPressed: () {
                String name,contact,email;
                name=_name.text;
                contact =_contact.text;
                email=_email.text;

                if (widget.s!=null) {
                  widget.s!.name=name;
                  widget.s!.contact=contact;
                  widget.s!.email=email;
                  widget.s!.save();
                }
                else{
                  Student s = Student(name, contact, email);
                  mybox.add(s);
                  print("inserted");
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SecondPage();
                },));
              }, child: Text(widget.s!=null ? "Update" : "Add" )),

              // ListView.builder(
              //   itemCount: _data.length,
              //   itemBuilder: (context, index) {
              //     final currentData = _data[index];
              //   return ListTile(
              //     //title: Text(currentData['name']),
              //     subtitle: Text("we"),
              //   );
              // },)
            ],
          ),
        ),
      ),
    );
  }
}

/*  List <Map<String,dynamic>> _data = [];

  void _showData(){
    final data = mybox1.keys.map((key) {
      final item = mybox1.get(key);
      return {"key" : key,"name":item["name"],"contact" : item['contact'],"email": item['email']};
    }).toList();
    setState(() {
      _data = data.reversed.toList();
    });
  }
  Future<void>_StudentData(Map<String,dynamic> newData) async {
    await mybox1.add(newData);
    _showData();
  }

  void showform(BuildContext context , int? itemkey)
  {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) {
      return Container(height: 340,
        padding: EdgeInsets.all(15),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 10,
                offset: Offset(6, 6),
              )
            ],
          ),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(5),
                child: TextField(
                  controller: _name,
                  decoration:  const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Enter name")
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(5),
                child: TextField(
                  controller: _contact,
                  keyboardType: TextInputType.phone,
                  decoration:  const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Enter Contact")
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(5),
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration:  const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Enter Email")
                  ),
                ),
              ),
              SizedBox(height: 10,),

              ElevatedButton(onPressed: () {
                String name,contact,email;
                name=_name.text;
                contact =_contact.text;
                email=_email.text;

                _StudentData({
                  "name" : name,
                  "contact" : contact,
                  "email" : email,
                });
                print("Data inserted");
                Navigator.pop(context);
              }, child: Text("Add"))
            ],
          ),
        ),
      );
    },);
  }*/
