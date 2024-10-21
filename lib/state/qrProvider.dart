import 'package:flutter/material.dart';
import 'package:inco/service/qrService.dart';

class QrProvider extends ChangeNotifier {
  QrService qrservice = QrService();
  List<String>? _qrPdfs = [];
  List<String> get qrPdfs => _qrPdfs!;

  List<Map<String,dynamic>>? allQrPdfs = [];
  bool isGenerating = false;
  bool isDownloading = false;
  int? generetingIndex;

  void notify() {
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
      if (!allQrPdfs!.contains(qr)) {
       
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
    isGenerating = true;
    notifyListeners();

     allQrPdfs = await qrservice.getAllQrCodes();
    // allQrPdfs = savedQrCodes.map((e) => e['filePath'] as String).toList();

    isGenerating = false;
    notifyListeners();
  }
}
