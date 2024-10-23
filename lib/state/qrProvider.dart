import 'package:flutter/material.dart';
import 'package:inco/service/qrService.dart';

class QrProvider extends ChangeNotifier {
  QrService qrservice = QrService();
  List<String>? _qrPdfs = [];
  List<String> get qrPdfs => _qrPdfs!;

  List<Map<String, dynamic>>? allQrPdfs = [];
  bool isGenerating = false;
  bool isloading = false;
  bool isDownloading = false;
  int? generetingIndex;

  void notify() {
    notifyListeners();
  }

  Future<void> removeQr(int index) async {
    int id = allQrPdfs![index]['id']; // Get the ID of the QR code
    await qrservice.deleteQrCode(id); // Delete the QR code from the database

    // Remove the item from the list and notify listeners
    allQrPdfs = List.from(allQrPdfs!);
    allQrPdfs!.removeAt(index);
    notifyListeners();
  }

  Future<void> getpdf() async {
    print('getting pdf');
    isGenerating = true;
    notifyListeners();

    // Fetch QR PDFs from API
    _qrPdfs = await qrservice.fetchQrCode();

    isGenerating = false;
    notifyListeners();
    loadQrCodesFromDatabase(); // Load existing QR codes from DB

    // Add new QR PDFs to the database if not already present
    for (var qr in _qrPdfs!) {
      if (!allQrPdfs!.any((element) => element['filePath'] == qr)) {
        await qrservice.addQrCode(qr);
      }
    }

    notifyListeners();
  }

  void downloadqrcodepdf(
      String url, String fileName, BuildContext context) async {
    isDownloading = true;
    notifyListeners();

    // Call the download method in the service
    await qrservice.downloadPdf(url, fileName, context);

    isDownloading = false;
    notifyListeners();
  }

  Future<void> loadQrCodesFromDatabase() async {
    isloading = true;
    notifyListeners();

    allQrPdfs = await qrservice.getAllQrCodes();
    print(allQrPdfs);

    isloading = false;
    notifyListeners();
  }
}
