import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/core/widgets/customeTextfield.dart';
import 'package:inco/state/productProvider.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  TextEditingController itemNAmeController = TextEditingController();
  TextEditingController pointController = TextEditingController();
  var _formkey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  // XFile? image;
  @override
  Widget build(BuildContext context) {
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
        title: const Text('Products',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Consumer<ProductProvider>(
          builder: (context, value, child) => ListView.builder(
            itemCount: value.productList.length,
            itemBuilder: (context, index) {
              return Card(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                '${Api.baseUrl}storage/${value.productList[index].productImage!}'
                                    .replaceAll('api', '')),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black12,
                      ),
                      margin: EdgeInsets.all(5),
                      height: 100,
                      width: 150,
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          value.productList[index].point.toString(),
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(value.productList[index].productInfo!),
                        trailing:
                            value.isDeleting && value.deletingIndex == index
                                ? SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      value.deletingIndex = index;
                                      await value.deleteProduct(
                                          value.productList[index].id);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext contextt) {
              return Consumer<ProductProvider>(
                builder: (context, dialogvalue, child) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  content: SingleChildScrollView(
                    child: Form(
                      key: _formkey, // Assign the form key
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Item Name:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          CustomeTextfield(
                            prifixicon: Icons.card_giftcard_rounded,
                            label: '',
                            controller: itemNAmeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter item name";
                              }
                              return null;
                            },
                          ),
                          Text(
                            "Add Points:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          CustomeTextfield(
                            prifixicon: Icons.bolt,
                            label: '',
                            controller: pointController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter points";
                              }
                              return null;
                            },
                          ),
                          Text(
                            "Upload Photo:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          // Square TextField for uploading file without dotted border
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.red.withOpacity(0.2),
                                  width: 2.0), // Square border
                              borderRadius: BorderRadius.zero, // Square corners
                            ),
                            child: InkWell(
                              onTap: () async {
                                // Add file upload functionality here
                                var imageee = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (imageee != null) {
                                  dialogvalue.setImage(File(imageee.path));
                                }
                              },
                              child: Center(
                                child: dialogvalue.selectedImage != null
                                    ? Image.file(
                                        dialogvalue.selectedImage!,
                                        width: double.maxFinite,
                                        height: 100,
                                        fit: BoxFit
                                            .fill, // Fit the image in the box
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image_outlined,
                                              color: Colors.black),
                                          SizedBox(height: 8.0),
                                          Text("Upload File",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: dialogvalue.isLoading
                                ? CircularProgressIndicator(
                                    color: appThemeColor,
                                  )
                                : CustomeButton(
                                    ontap: () async {
                                      // Validate the form before proceeding
                                      if (_formkey.currentState!.validate()) {
                                        if (dialogvalue.selectedImage == null) {
                                          // Show a message if no image is selected
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Please select an image"),
                                            ),
                                          );
                                          return;
                                        }
                                        // If the form is valid and an image is selected, proceed
                                        dialogvalue.addProduct(
                                            await dialogvalue.selectedImage!,
                                            pointController.text,
                                            itemNAmeController.text,
                                            contextt);
                                        pointController.clear();
                                        itemNAmeController.clear();
                                      }
                                    },
                                    height: 40,
                                    width: 100,
                                    text: 'Add',
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: appThemeColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
