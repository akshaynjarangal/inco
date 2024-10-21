import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomCarousel extends StatelessWidget {
  final List<String> items;
  final CarouselSliderController carouselController;
  final ValueNotifier<int> current;

  CustomCarousel({
    required this.items,
    required this.carouselController,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    var mediaqry = MediaQuery.of(context).size;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CarouselSlider(
            items: items
                .map(
                  (item) => Container(
                    width: mediaqry.width, // Full width of the screen
                    child: Image.network(
                      item,
                      fit: BoxFit.fill, // Ensures the image fills the container
                    ),
                  ),
                )
                .toList(),
            carouselController: carouselController,
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0, // Full width of the screen
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                current.value = index;
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
        Positioned(
          bottom: 3.0,
          right: mediaqry.width / 2 - (items.length * 8),
          child: ValueListenableBuilder(
            valueListenable: current,
            builder: (context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: items.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => carouselController.animateToPage(entry.key),
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(current.value == entry.key ? 0.9 : 0.4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
