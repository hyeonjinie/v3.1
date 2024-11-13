import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../domain/models/product.dart';

class ProductDetailsDisclosure extends StatelessWidget {
  final Product product;
  final bool showProductInfo;
  final VoidCallback toggleProductInfo;

  const ProductDetailsDisclosure({
    Key? key,
    required this.product,
    required this.showProductInfo,
    required this.toggleProductInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        // width: screenWidth < 600 ? double.infinity : screenWidth * 0.5,
        width: kIsWeb && screenWidth > 1200 ? 1200 : screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: toggleProductInfo,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(showProductInfo ? '상품 정보 제공 고시 접기' : '상품 정보 제공 고시 펼치기'),
                  Icon(showProductInfo ? Icons.expand_less : Icons.expand_more),
                ],
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0xFFF6F6F6),
                elevation: 0,
                side: BorderSide(color: Colors.white),
              ),
            ),
            if (showProductInfo)
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: product.productInfoLaw.isNotEmpty
                        ? Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.grey),
                        verticalInside: BorderSide(color: Colors.grey),
                      ),
                      children: product.productInfoLaw
                          .map<TableRow>((detail) => TableRow(
                        children: [
                          Container(
                            color: Color(0xFFF6F6F6),
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              detail['key']!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(detail['value']!),
                          ),
                        ],
                      ))
                          .toList(),
                    )
                        : const Text('상품 정보가 없습니다.'),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            SizedBox(height: 50.0),
            Divider(),
            SizedBox(height: 50.0),
            // if (product.productImageUrl.isEmpty)
            //   Container(
            //     width: double.infinity,
            //     child: Image.network(
            //       product.productImageUrl,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
