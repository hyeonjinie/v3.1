abstract class PriceRepository {
  Future<Map<String, dynamic>> fetchPriceData(String item, String pumNm);
}
