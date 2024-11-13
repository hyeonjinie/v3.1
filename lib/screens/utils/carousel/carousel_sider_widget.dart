import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselBannerSliderWidget extends StatelessWidget {
  final Duration interval;
  final Function(int) onBannerTap;
  final List<String> imagePaths;

  const CarouselBannerSliderWidget({
    Key? key,
    required this.interval,
    required this.onBannerTap,
    required this.imagePaths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            autoPlayInterval: interval,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
          ),
          items: imagePaths.map((path) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () => onBannerTap(imagePaths.indexOf(path)),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2.0,
                          spreadRadius: 1,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        path,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imagePaths.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
