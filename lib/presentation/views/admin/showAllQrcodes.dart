import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inco/service/qrService.dart';
import 'package:inco/state/qrProvider.dart';

class AllQrCodesScreen extends StatelessWidget {
  const AllQrCodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Generated QR Codes'),
      ),
      body: Consumer<QrProvider>(
        builder: (context, qrProvider, child) {
          // Show loading indicator while loading data
          if (qrProvider.isGenerating) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show empty screen if no QR PDFs are found
          if (qrProvider.allQrPdfs!.isEmpty) {
            return const Center(child: Text('No QR codes found.'));
          }
          print(qrProvider.allQrPdfs!.length);
          // Display the list of QR PDFs
          return ListView.builder(
            itemCount: qrProvider.allQrPdfs!.length,
            itemBuilder: (context, index) {
              String qrPdfPath = qrProvider.allQrPdfs![index]['filename'];
              int id = qrProvider.allQrPdfs![index]['id'];
              String fileName = qrPdfPath.split('/').last;

              return ListTile(
                leading: Image.asset('assets/images/pdfimg.png'),
                title: Text(fileName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        // Trigger the download method in the provider
                        qrProvider.downloadqrcodepdf(
                            qrPdfPath, // Assuming this is the URL
                            fileName,
                            context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _confirmDelete(context, qrProvider, index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, QrProvider provider, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this QR code?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                QrService qrService = QrService();
                int id = provider.allQrPdfs![index]
                    ['id']; // You should get the actual id from the database
                qrService.deleteQrCode(id);
                provider.allQrPdfs!.removeAt(index);
                provider.notify();
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
