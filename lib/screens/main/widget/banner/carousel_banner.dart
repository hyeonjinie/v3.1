import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselBanner extends StatelessWidget {
  final Duration interval;
  final Function(int) onBannerTap;


  const CarouselBanner({
    Key? key,
    required this.interval,
    required this.onBannerTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double bannerWidth = screenWidth > 1200 ? 1200 : screenWidth;

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
          items: [1, 2, 3].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () => onBannerTap(i),
                  child: SizedBox(
                    width: bannerWidth,
                    child: Image.asset(
                      "assets/banner/banner0$i.png",
                      width: bannerWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 2, 3].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
