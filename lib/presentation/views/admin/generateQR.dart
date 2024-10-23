import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/presentation/views/admin/showAllQrcodes.dart';
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
            icon: const Icon(Icons.list, color: Colors.black),
            onPressed: () async {
              await Provider.of<QrProvider>(context, listen: false)
                  .loadQrCodesFromDatabase();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllQrCodesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
       await   Future.delayed(const Duration(seconds: 2));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Consumer<QrProvider>(
              builder: (context, value, child) {
                if (value.isGenerating) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: appThemeColor,
                  ));
                }

                if (value.qrPdfs.isEmpty) {
                  return const Center(child: Text('NO PDF'));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: value.qrPdfs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.asset('assets/images/pdfimg.png'),
                          title: Text(value.qrPdfs[index].split('/').last),
                          trailing: value.isDownloading &&
                                  value.generetingIndex == index
                              ? const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    value.generetingIndex = index;
                                    value.downloadqrcodepdf(
                                        value.qrPdfs[index],
                                        value.qrPdfs[index].split('/').last,
                                        context);
                                    // Add your download logic here
                                  },
                                  icon: const Icon(Icons.download_rounded),
                                ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Consumer<QrProvider>(
              builder: (context, value, child) {
                return CustomeButton(
                  ontap: () async {
                    value.getpdf();
                  },
                  height: 40,
                  width: mediaQuery.width / 2,
                  text: 'Generate Qr',
                );
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
