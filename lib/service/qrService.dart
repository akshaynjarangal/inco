import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/core/widgets/snackbar.dart';
import 'package:inco/service/auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QrService {
  Dio dio = Dio();
  static Database? _database;

  // Singleton pattern
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'qr_codes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE qr_codes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filePath TEXT UNIQUE
          )
        ''');
      },
    );
  }

  Future<int> addQrCode(String filePath) async {
    final db = await database;
    try {
      return await db.insert('qr_codes', {'filePath': filePath},
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      print('Error inserting QR code: $e');
      return -1; // Return an error code or handle as needed
    }
  }

  Future<List<Map<String, dynamic>>> getAllQrCodes() async {
    final db = await database;
    return await db.query('qr_codes');
  }

  Future<int> deleteQrCode(int id) async {
    final db = await database;
    return await db.delete('qr_codes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<String>?> fetchQrCode() async {
    String? token = await AuthService.getToken();
    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $token';
        Response response = await dio.post(Api.createQr);

        if (response.statusCode == 200 &&
            response.data['message'] == 'success') {
          List<dynamic> alllinks = response.data['pdf_links'];
          Set<String> stringLinks =
              alllinks.map((item) => item.toString()).toSet();
          print('Data fetched successfully: ${response.data}');
          return stringLinks.toList();
        } else {
          print('Failed to fetch data: ${response.statusCode}');
          return null;
        }
      } catch (e) {
        print('Error occurred while fetching QR codes: $e');
        return null;
      }
    }
    return null;
  }

  // download
  Future<void> downloadPdf(String url, String fileName, context) async {
    // Check for storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      print('Storage permission denied');
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
        print('PDF downloaded to: $filePath');
        snackbarWidget(context, 'PDF Downloaded', Colors.black);
        final result = await Share.shareXFiles([XFile(filePath)], text: 'Great picture');

if (result.status == ShareResultStatus.success) {
    print('Thank you for sharing the picture!');
}
      } else {
        print('Failed to download PDF: ${response.statusCode}');
        snackbarWidget(context, 'Download failed', Colors.red);
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      snackbarWidget(context, 'Download failed', Colors.red);
    }
  }
}
