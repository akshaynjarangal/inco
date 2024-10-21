import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inco/core/constent/colors.dart';
import 'package:inco/core/constent/endpoints.dart';
import 'package:inco/core/widgets/customeButton.dart';
import 'package:inco/core/widgets/customeSlider.dart';
import 'package:inco/state/bannerProvider.dart';
import 'package:provider/provider.dart';

class ManegeBannerScreen extends StatelessWidget {
  ManegeBannerScreen({super.key});
  final ValueNotifier<int> _current = ValueNotifier(0);
  final CarouselSliderController _controller = CarouselSliderController();
 

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
        title: const Text('Update Banner',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<BannerProvider>(
          builder: (context, value, child) => Column(
            children: [
              CustomCarousel(
                  items: value.bannerImages,
                  carouselController: _controller,
                  current: _current),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  itemCount: value.bannerDatas!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        // Instead of Expanded, use a SizedBox or Container with fixed size
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.network(
                            '${Api.baseUrl}storage/${value.bannerDatas![index].bannerImage}'
                                .replaceAll('api', ''),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  XFile? pickedimg = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (pickedimg != null) {
                                    await value.editBannerfun(
                                        File(pickedimg.path),
                                        value.bannerDatas![index].id);
                                  }
                                },
                                icon: Icon(
                                  Icons.edit_square,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  final snackBar = SnackBar(
                                    content: const Text(
                                        'Are you sure you want to delete this banner?'),
                                    action: SnackBarAction(
                                      label: 'DELETE',
                                      textColor: Colors.red,
                                      onPressed: () async {
                                        await value.deleteBannerfun(
                                            value.bannerDatas![index].id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Banner deleted successfully!'),
                                          ),
                                        );
                                      },
                                    ),
                                    duration: Duration(
                                        seconds:
                                            5), // Duration the SnackBar will be displayed
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomeButton(
                  ontap: () async {
                    final ImagePicker picker = ImagePicker();
                    XFile? pickedimg =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedimg != null) {
                      await value.addBannerfun(File(pickedimg.path));
                    }
                  },
                  height: 40,
                  width: mediaqry.width / 2,
                  text: 'Add more'),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
