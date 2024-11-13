import 'package:v3_mvp/domain/models/sd_sub_order.dart';

class SdOrder {
  final String uid;
  final String documentId;
  final String title;
  final String itemName;
  final String variety;
  int orderCount;
  final int totalCount;
  int volume;
  final int totalVolume;
  final String origin;
  final String startDate;
  final String endDate;
  final String grade;
  final int price;
  final List<SubOrder> subOrders;
  final String assignedAdmin;

  SdOrder({
    required this.uid,
    required this.documentId,
    required this.title,
    required this.itemName,
    required this.variety,
    required this.orderCount,
    required this.totalCount,
    required this.volume,
    required this.totalVolume,
    required this.origin,
    required this.startDate,
    required this.endDate,
    required this.grade,
    required this.price,
    required this.subOrders,
    required this.assignedAdmin,
  });

  factory SdOrder.fromMap(Map<String, dynamic> map, String documentId) {
    return SdOrder(
      uid: map['uid'] ?? '',
      documentId: documentId, // Update this line to use the passed documentId
      title: map['title'] ?? '',
      itemName: map['itemName'] ?? '',
      variety: map['variety'] ?? '',
      orderCount: map['orderCount'] ?? 0,
      totalCount: map['totalCount'] ?? 0,
      volume: map['volume'] ?? 0,
      totalVolume: map['totalVolume'] ?? 0,
      origin: map['origin'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      grade: map['grade'] ?? '',
      price: map['price'] ?? 0,
      subOrders: (map['subOrders'] as List<dynamic>?)
          ?.map((e) => SubOrder.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      assignedAdmin: map['assignedAdmin'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'documentId': documentId,
      'title': title,
      'itemName': itemName,
      'variety': variety,
      'orderCount': orderCount,
      'totalCount': totalCount,
      'volume': volume,
      'totalVolume': totalVolume,
      'origin': origin,
      'startDate': startDate,
      'endDate': endDate,
      'grade': grade,
      'price': price,
      'subOrders': subOrders.map((e) => e.toMap()).toList(),
      'assignedAdmin': assignedAdmin,
    };
  }
}
