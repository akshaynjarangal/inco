import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/core/widgets/snackbar.dart';
import 'package:inco/service/auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class QrService {
  Dio dio = Dio();

  Future<void> generateQrCode(ctxt) async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $token';
        Response response = await dio.post(Api.createQr);

        if (response.statusCode == 200 &&
            response.data['status'] == 'success') {
          snackbarWidget(ctxt, response.data['message'], Colors.green);
          Navigator.pop(ctxt);
        } else {
          // print('Failed to fetch data: ${response.statusCode}');
          return;
        }
      } catch (e) {
        // print('Error occurred while fetching QR codes: $e');
        return;
      }
    }
    return;
  }

  Future<void> deleteQrCode(id, context) async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $token';
        Response response = await dio.delete('${Api.deleteQr}/$id');

        if (response.statusCode == 200 &&
            response.data['status'] == 'success') {
          // List<dynamic> alllinks = response.data['pdf_links'];
          // Set<String> stringLinks =
          //     alllinks.map((item) => item.toString()).toSet();
          Navigator.pop(context);
          // print('Datadeleted successfully: ${response.data}');
        } else {
          // print('Failed to fetch data: ${response.statusCode}');
          return;
        }
      } catch (e) {
        // print('Error occurred while fetching QR codes: $e');
        return;
      }
    }
    return;
  }

  Future<void> deleteAllQrCode(context) async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $token';
        Response response = await dio.delete(Api.deleteAllQr);

        if (response.statusCode == 200 &&
            response.data['status'] == 'success') {
          // print('Datadeleted successfully: ${response.data}');
          Navigator.pop(context);
        } else {
          // print('Failed to fetch data: ${response.statusCode}');
          return;
        }
      } catch (e) {
        // print('Error occurred while fetching QR codes: $e');
        return;
      }
    }
    return;
  }

  Future<List<Map<String, dynamic>>?> fetchQrCode() async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $token';
        Response response = await dio.get(Api.getQr);
        // print(response.data);
        if (response.statusCode == 200 &&
            response.data['status'] == 'success') {
          List<dynamic> alllinks = response.data['pdf_data'];
          Set<Map<String, dynamic>> uniqueLinks =
              alllinks.cast<Map<String, dynamic>>().toSet();

          // print('Data fetched successfully: ${response.data}');
          return uniqueLinks.toList();
        } else {
          // print('Failed to fetch data: ${response.statusCode}');
          return [];
        }
      } catch (e) {
        // print('Error occurred while fetching QR codes: $e');
        return [];
      }
    }
    return [];
  }

  // download
  Future<void> downloadPdf(String url, String fileName, context) async {
    // Check for storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // print('Storage permission denied');
      snackbarWidget(context, 'storage permission denied!', Colors.black);
      return;
    }

    // Get the directory for the documents folder outside of the app's storage
    Directory? externalDir = await getExternalStorageDirectory();
    String folderPath = '${externalDir!.path}/INCO';

    // Create a new directory for PDFs if it doesn't exist
    Directory folder = Directory(folderPath);
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    // Create the file path
    String filePath = '$folderPath/$fileName';

    // Download the PDF file using Dio
    try {
      final response = await Dio().download(url, filePath);
      if (response.statusCode == 200) {
        // print('PDF downloaded to: $filePath');
        snackbarWidget(context, 'PDF Downloaded', Colors.black);
        final result =
            await Share.shareXFiles([XFile(filePath)], text: 'Great picture');

        if (result.status == ShareResultStatus.success) {
          // print('Thank you for sharing the picture!');
        }
      } else {
        // print('Failed to download PDF: ${response.statusCode}');
        snackbarWidget(context, 'Download failed', Colors.red);
      }
    } catch (e) {
      // print('Error downloading PDF: $e');
      snackbarWidget(context, 'Download failed', Colors.red);
    }
  }
}
