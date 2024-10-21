import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/core/widgets/customeTextfield.dart';
import 'package:inco/data/local/districtList.dart';
import 'package:inco/data/model/deliveryAddressModel.dart';
import 'package:inco/data/model/productModel.dart';
import 'package:inco/state/productProvider.dart';
import 'package:provider/provider.dart';

class ChangeAddressScreen extends StatefulWidget {
  const ChangeAddressScreen(
      {super.key, required this.address, required this.product});
  final DeliveryAddress address;
  final ProductModel product;

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  TextEditingController placeController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  TextEditingController pincodeController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  var formkey = GlobalKey<FormState>();

  ValueNotifier<String?> selectedDistrict = ValueNotifier<String?>(null);

  @override
  void initState() {
    placeController.text = widget.address.place!;
    cityController.text = widget.address.city!;
    phoneController.text =
        widget.address.phone!.toString().replaceAll('+91', '');
    pincodeController.text = widget.address.pincode!;
    selectedDistrict.value = widget.address.district;
    nameController.text = widget.address.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaqry = MediaQuery.of(context).size;

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
        title: const Text('Change Address',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomeTextfield(
                  prifixicon: Icons.person,
                  label: 'Name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your name";
                    }
                  },
                ),
                CustomeTextfield(
                  prifixicon: Icons.place,
                  label: 'Place',
                  controller: placeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your place";
                    }
                  },
                ),
                CustomeTextfield(
                  prifixicon: Icons.location_city,
                  label: 'City',
                  controller: cityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your city";
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder<String?>(
                    valueListenable: selectedDistrict,
                    builder: (context, value, _) {
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 23, 22,
                                    22)), // Red border when not focused
                          ),
                          labelText: 'District',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: appThemeColor), // Red border color
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color:
                                    appThemeColor), // Red border when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color:
                                    appThemeColor), // Red border when focused
                          ),
                        ),
                        value: value,
                        onChanged: (String? newValue) {
                          selectedDistrict.value =
                              newValue; // Update ValueNotifier when selected
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a district";
                          }
                          return null;
                        },
                        items: districts
                            .map<DropdownMenuItem<String>>((String district) {
                          return DropdownMenuItem<String>(
                            value: district,
                            child: Text(district),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                CustomeTextfield(
                  prifixicon: Icons.local_post_office_outlined,
                  label: 'Pin code',
                  controller: pincodeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your pin code";
                    } else if (value.toString().length != 6) {
                      return 'invalid pin code';
                    }
                  },
                ),
                CustomeTextfield(
                  pretext: '+91',
                  label: 'Phone',
                  prifixicon: Icons.phone,
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your phone";
                    } else if (value.toString().length != 10) {
                      return 'invalid phone Number';
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomeButton(
                  height: 40,
                  width: mediaqry.width / 2,
                  text: 'save',
                  ontap: () {
                    if (formkey.currentState!.validate()) {
                      DeliveryAddress newaddress = DeliveryAddress(
                          name: nameController.text,
                          place: placeController.text,
                          city: cityController.text,
                          district: selectedDistrict.value,
                          pincode: pincodeController.text,
                          phone: phoneController.text);

                      Provider.of<ProductProvider>(context, listen: false)
                          .setdeliveryaddress(newaddress);

                      Navigator.pop(context);
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (ctxt) => ConfirmOrderScreen(
                      //               product: widget.product,
                      //             )));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
