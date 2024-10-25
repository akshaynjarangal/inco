import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/data/model/pointRequestModel.dart';
import 'package:inco/state/productProvider.dart';
import 'package:provider/provider.dart';

class RequesteDetailsScreen extends StatelessWidget {
  RequesteDetailsScreen({super.key, required this.reqDetails});
  final PointRequestesModel reqDetails;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    // Get screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
        title: const Text('Request',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // 5% horizontal padding
          vertical: screenHeight * 0.02, // 2% vertical padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.01),
            // Report Request section title
            Text(
              'Report Request',
              style: TextStyle(
                fontSize: screenWidth * 0.039, // Dynamic font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
                height:
                    screenHeight * 0.01), // Space between title and container

            // Report Request section wrapped in a Container
            Expanded(
              flex: 3, // Adjust flex as needed
              child: Container(
                width: double.infinity, // Make container full width
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: _buildRow(
                            'Name', reqDetails.complainant.name, screenWidth)),
                    SizedBox(height: screenHeight * 0.01), // Dynamic spacing
                    Expanded(
                        child: _buildRow('Email', reqDetails.complainant.email,
                            screenWidth)),
                    SizedBox(height: screenHeight * 0.01), // Dynamic spacing
                    Expanded(
                        child: _buildRow(
                            'Phone',
                            reqDetails.complainant.phone.toString(),
                            screenWidth)),
                    SizedBox(height: screenHeight * 0.01), // Dynamic spacing
                    // Expanded(child: _buildRow('Point', '100', screenWidth)),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.03), // Space between containers

            // Redeemed User section title
            Text(
              'Redeemed User',
              style: TextStyle(
                fontSize: screenWidth * 0.038, // Dynamic font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
                height:
                    screenHeight * 0.01), // Space between title and container

            // Redeemed User section wrapped in a Container
            Expanded(
              flex: 3, // Adjust flex as needed
              child: Container(
                width: double.infinity, // Make container full width
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: _buildRedeemedRow(
                            'Name', reqDetails.defendant.name, screenWidth)),
                    SizedBox(height: screenHeight * 0.01), // Dynamic spacing
                    Expanded(
                        child: _buildRedeemedRow(
                            'Email', reqDetails.defendant.email, screenWidth)),
                    SizedBox(height: screenHeight * 0.01), // Dynamic spacing
                    Expanded(
                        child: _buildRedeemedRow(
                            'Phone',
                            reqDetails.defendant.phone.toString(),
                            screenWidth)),
                    SizedBox(height: screenHeight * 0.01), // Dynamic spacing
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.04), // Space before buttons

            // Accept/Reject buttons

            ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return isLoading.value
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: appThemeColor,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomeButton(
                                ontap: () async {
                                  isLoading.value = true;
                                  await Provider.of<ProductProvider>(context,
                                          listen: false)
                                      .acceptRequesst(reqDetails.complaintId);
                                  Navigator.pop(context);
                                   isLoading.value = false;
                                },
                                height: 40,
                                width: screenWidth / 4,
                                text: 'Accept'),
                            CustomeButton(
                                ontap: () async {
                                   isLoading.value = true;
                                  await Provider.of<ProductProvider>(context,
                                          listen: false)
                                      .rejectRequestes(reqDetails.complaintId);
                                  Navigator.pop(context);
                                   isLoading.value = false;
                                },
                                height: 40,
                                width: screenWidth / 4,
                                text: 'Reject')
                          ],
                        );
                }),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: screenWidth * 0.3, // Fixed width for label
          child: Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.04, // Dynamic font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.02), // Space between name and colon
        Text(
          ':', // Colon after label
          style: TextStyle(
            fontSize: screenWidth * 0.04, // Dynamic font size
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: screenWidth * 0.04), // Space between colon and value
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold, // Dynamic font size
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRedeemedRow(String label, String value, double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: screenWidth * 0.3, // Fixed width for label
          child: Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.04, // Dynamic font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.02), // Space between name and colon
        Text(
          ':', // Colon after label
          style: TextStyle(
            fontSize: screenWidth * 0.04, // Dynamic font size
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: screenWidth * 0.04), // Space between colon and value
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold, // Dynamic font size
            ),
          ),
        ),
      ],
    );
  }
}
