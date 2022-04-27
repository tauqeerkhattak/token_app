import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:token_app/models/category_data.dart';
import 'package:token_app/screens/dashboard.dart';
import 'package:token_app/screens/login.dart';
import 'package:token_app/utils/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DashboardController extends GetxController {
  Rx<bool> loading = false.obs;
  Rx<int> length = 0.obs;
  Rx<String> tokenNumber = '__'.obs;
  Rx<Datum> category = Datum().obs;
  Rx<CategoryData?> data = CategoryData().obs;

  @override
  void onInit() async {
    loading.value = true;
    data.value = await Services.getCategories();
    length.value = data.value!.data!.length;
    loading.value = false;
    super.onInit();
  }

  void getToken(String categoryId) async {
    loading.value = true;
    String token = await Services.getTokenNumber(categoryId);
    if (token != 'null') {
      tokenNumber.value = token;
    }
    loading.value = false;
  }

  void logout() {
    Services.logout().then((value) {
      Get.offAll(() => Login());
    });
  }

  void generateToken(String categoryId,String categoryName) async {
    loading.value = true;
    await Services.generateToken(
        categoryId: categoryId, tokenNumber: tokenNumber.value).then((value) {
          print(categoryName, tokenNumber.value,);
    });
    loading.value = false;
  }

  void print(String categoryName,String tokenNumber) async {
    final doc = pw.Document();
    final image = await imageFromAssetBundle('assets/images/logo.png');
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('dd-MM-yyyy hh:mm a');
    doc.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(
          2.25 * PdfPageFormat.inch,
          3.125 * PdfPageFormat.inch,
        ),
        build: (pw.Context context) {
          return pw.Container(
            width: double.infinity,
            height: double.infinity,
            child: pw.Column(
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                    margin: const pw.EdgeInsets.all(
                      10,
                    ),
                    child: pw.Image(image),
                  ),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    margin: const pw.EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: pw.Text(
                      format.format(now),
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(left: 10,right: 10,),
                  child: pw.Divider(),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Text(
                      'Category: $categoryName',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Text(
                      'Token Number',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Center(
                    child: pw.Text(
                      tokenNumber,
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(left: 10,right: 10,),
                  child: pw.Divider(),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Text(
                      'Some Other Text',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      return doc.save();
    });
  }
}
