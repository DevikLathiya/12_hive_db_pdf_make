import 'dart:io';
import 'dart:math';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfDataPage extends StatefulWidget {
  const PdfDataPage({Key? key}) : super(key: key);

  @override
  State<PdfDataPage> createState() => _PdfDataPageState();
}

class _PdfDataPageState extends State<PdfDataPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _couse = TextEditingController();
  TextEditingController _fees = TextEditingController();

  Uint8List? exImage;
  DateTime? pickedDate;
  String date="";

  SignatureController _sign = SignatureController(penStrokeWidth: 5, penColor: Colors.black);

  permition() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
    }
  }

  @override
  void initState() {
    super.initState();
    permition();
    pickedDate= DateTime.now();
    date = "${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Pdf Generate"),
      ),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(margin: EdgeInsets.symmetric(vertical: 3,horizontal: 5),child: Text("$date")),
            ],
          ),
          Card(margin: EdgeInsets.all(10),
            child: TextField(
              controller: _name,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(),
                labelText: "Enter Student Name"
              ),
            ),
          ),
          Card(margin: EdgeInsets.all(10),
            child: TextField(
              controller: _couse,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(),
                  labelText: "Enter Couse Name"
              ),
            ),
          ),
          Card(margin: EdgeInsets.all(10),
            child: TextField(
              controller: _fees,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(),
                  labelText: "Enter Fees"
              ),
            ),
          ),
          Card(margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Text("Student Signature : "),
                IconButton(onPressed: () {
                  showModalBottomSheet(context: context,
                    builder: (context) {
                          return Container(margin: EdgeInsets.all(10),
                            height: 270,width: double.infinity,padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Signature(
                                  controller: _sign,
                                  height: 200,
                                  width: double.infinity,
                                  backgroundColor: Colors.cyan,
                                ),
                                Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(onPressed: () {
                                      Navigator.pop(context);
                                      _sign.clear();
                                    }, icon: Icon(Icons.arrow_back)),
                                    IconButton(onPressed: () {
                                      _sign.clear();
                                    }, icon: Icon(Icons.close)),

                                    IconButton(onPressed: () async {
                                      exImage = await _sign.toPngBytes();
                                      Navigator.pop(context);
                                      setState(() {});
                                    }, icon: Icon(Icons.done)),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }, icon: Icon(Icons.mode_edit_outline_outlined))
              ],
            ),
          ),
          
          ElevatedButton(onPressed: () async {
            PdfDocument document = PdfDocument();
            PdfPage page = document.pages.add();

            var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)+"/Devik";
            Directory dir = Directory(path);
            if(! await dir.exists())
            {
              dir.create();
            }
            _sign.clear();
            final byteData = await rootBundle.load("lib/Pdf Generate/img.png");
            final img = File("${dir.path}/img.png");
            await img.create(recursive: true);
            await img.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes,byteData.lengthInBytes));

            page.graphics.drawRectangle(pen: PdfPen(PdfColor(0, 0, 0),width: 3),
             bounds: Rect.fromLTWH(0,0,515,700));

            page.graphics.drawImage(PdfBitmap(File(img.path).readAsBytesSync()), Rect.fromLTWH(0, 0, 300, 100));

            page.graphics.drawString("903331603", PdfStandardFont(PdfFontFamily.courier, 25),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(377, 30, 320, 30));
            page.graphics.drawString("info@cdmi.in", PdfStandardFont(PdfFontFamily.courier, 25),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(377, 60, 320, 30));

            page.graphics.drawString("Student Name :", PdfStandardFont(PdfFontFamily.courier, 25),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(40, 210, 220, 50));
            page.graphics.drawString("${_name.text}", PdfStandardFont(PdfFontFamily.courier, 25),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(280, 210, 300, 50));

            page.graphics.drawString("Course :", PdfStandardFont(PdfFontFamily.courier, 25),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(40, 250, 200, 50));
            page.graphics.drawString("${_couse.text}", PdfStandardFont(PdfFontFamily.courier, 25),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(280, 250, 300, 50));

            page.graphics.drawString("Amount :", PdfStandardFont(PdfFontFamily.courier, 25),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(40, 290, 200, 50));
            page.graphics.drawString("${_fees.text}", PdfStandardFont(PdfFontFamily.courier, 25),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(280, 290, 200, 50));

            page.graphics.drawString("Date :", PdfStandardFont(PdfFontFamily.courier, 25),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(40, 330, 250, 50));
            page.graphics.drawString("${date}", PdfStandardFont(PdfFontFamily.courier, 25),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(280, 330, 250, 50));

            page.graphics.drawImage(PdfBitmap(exImage!), Rect.fromLTWH(20, 550, 100, 100));
            page.graphics.drawString("Student Sign", PdfStandardFont(PdfFontFamily.courier, 20),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(20, 650, 300, 50));

            page.graphics.drawString(" Creative\nMultimedia", PdfStandardFont(PdfFontFamily.helvetica, 20,style: PdfFontStyle.bold),
                brush: PdfSolidBrush(PdfColor(0,0,205)),bounds: Rect.fromLTWH(370, 590, 320, 50));
            page.graphics.drawString("Reception Sign", PdfStandardFont(PdfFontFamily.courier, 20,style: PdfFontStyle.bold),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),bounds: Rect.fromLTWH(340, 650, 320, 30));

            File file = File("${dir.path}/${Random().nextInt(500)}MyPdf.pdf");
            file.writeAsBytes(await document.save());
            OpenFile.open(file.path);

          }, child: Text("Submit"))
        ],
      ),
    );
  }
}
