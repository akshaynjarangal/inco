// import 'package:flutter/material.dart';
// import 'package:inco/core/constent/colors.dart';
// import 'package:provider/provider.dart';
// import 'package:inco/state/qrProvider.dart';

// class AllQrCodesScreen extends StatelessWidget {
//   const AllQrCodesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: -5,
//         backgroundColor: appThemeColor,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text('PDF History',
//             style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 17)),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: () async {
//                 await Future.delayed(const Duration(seconds: 2));
//                 Provider.of<QrProvider>(context, listen: false)
//                     .loadQrCodesFromDatabase();
//               },
//               child: Consumer<QrProvider>(
//                 // Listening to QrProvider changes
//                 builder: (context, qrProvider, child) {
//                   // Show loading indicator while loading data
//                   if (qrProvider.isloading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   // Show empty screen if no QR PDFs are found
//                   if (qrProvider.allQrPdfs!.isEmpty) {
//                     return const Center(child: Text('No QR codes found.'));
//                   }

//                   // Display the list of QR PDFs
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ListView.builder(
//                       itemCount: qrProvider.allQrPdfs!.length,
//                       itemBuilder: (context, index) {
//                         String qrPdfPath =
//                             qrProvider.allQrPdfs![index]['filePath'];
//                         int id = qrProvider.allQrPdfs![index]['id'];
//                         String fileName = qrPdfPath.split('/').last;
//                         print(qrProvider.allQrPdfs);
//                         return ListTile(
//                           leading: Image.asset('assets/images/pdfimg.png'),
//                           title: Text(fileName),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               qrProvider.isDownloading &&
//                                       qrProvider.generetingIndex == index
//                                   ? const SizedBox(
//                                       height: 30,
//                                       width: 30,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 1.0,
//                                       ),
//                                     )
//                                   : IconButton(
//                                       icon: const Icon(Icons.download),
//                                       onPressed: () {
//                                         qrProvider.generetingIndex = index;
//                                         // Trigger the download method in the provider
//                                         qrProvider.downloadqrcodepdf(
//                                             qrPdfPath, fileName, context);
//                                       },
//                                     ),
//                               IconButton(
//                                 icon: const Icon(Icons.delete),
//                                 onPressed: () {
//                                   _confirmDelete(context, qrProvider, index);
//                                 },
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           // MaterialButton(
//           //     color: Colors.grey,
//           //     onPressed: () {},
//           //     child: Text('Clear All Pdf'))
//         ],
//       ),
//     );
//   }

//   void _confirmDelete(BuildContext context, QrProvider provider, int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('CONFIRM'),
//           content: const Text('Are you sure you want to delete this PDF?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 // QrService qrService = QrService();
//                 // int id = provider.allQrPdfs![index]['id'];
//                 // await qrService.deleteQrCode(id);
//                 provider.removeQr(index);

//                 // ignore: use_build_context_synchronously
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
