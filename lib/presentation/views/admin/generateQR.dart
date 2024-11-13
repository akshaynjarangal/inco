import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/state/qrProvider.dart';
import 'package:provider/provider.dart';

class QrGenerationScreen extends StatelessWidget {
  const QrGenerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        backgroundColor: appThemeColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Generate QR',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
        actions: [
          IconButton(
            icon: const Text('Clear All'),
            onPressed: () async {
              // Example action

              _confirmDelete(context, () async {
                Provider.of<QrProvider>(context, listen: false)
                    .deleteteAllQrcode(context);
              }, 'Are you sure you want to delete All PDF?');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<QrProvider>(context, listen: false).getpdf();
        },
        child: Consumer<QrProvider>(
          builder: (context, value, child) {
            return Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: value.isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: appThemeColor,
                          ),
                        )
                      : value.qrPdfs.isEmpty
                          ? const Center(child: Text('NO PDF'))
                          : ListView.builder(
                              itemCount: value.qrPdfs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading:
                                        Image.asset('assets/images/pdfimg.png'),
                                    title: Text(value.qrPdfs[index]['pdf_path']
                                        .split('/')
                                        .last),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () async {
                                            _confirmDelete(context, () async {
                                              await value.deleteteQrcode(
                                                  value.qrPdfs[index]['id'],
                                                  context);
                                            }, 'Are you sure you want to delete this PDF ?');
                                          },
                                        ),
                                        value.isDownloading &&
                                                value.generetingIndex == index
                                            ? const SizedBox(
                                                height: 30,
                                                width: 30,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 1.0,
                                                ),
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  value.generetingIndex = index;
                                                  value.downloadqrcodepdf(
                                                      value.qrPdfs[index]
                                                          ['pdf_path'],
                                                      value.qrPdfs[index]
                                                              ['pdf_path']
                                                          .split('/')
                                                          .last,
                                                      context);
                                                },
                                                icon: const Icon(
                                                    Icons.download_rounded),
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Consumer<QrProvider>(
        builder: (context, value, child) {
          return CustomeButton(
            ontap: () async {
              _confirmDelete(context, () {
                value.generateQrcode(context);
              }, 'Do you want create More PDF?');
            },
            height: 40,
            width: mediaQuery.width / 2,
            text: 'Generate QR',
          );
        },
      ),
    );
  }
}

void _confirmDelete(BuildContext context, onpressed, text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('CONFIRM'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onpressed,
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
