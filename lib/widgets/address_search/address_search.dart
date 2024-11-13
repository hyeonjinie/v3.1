import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

class AddressSearch {
  static Future<String?> searchAddress(BuildContext context) async {
    if (!kIsWeb) {
      Kpostal result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => KpostalView()),
      );
      return result.address;
        }
    return null;
  }
}
