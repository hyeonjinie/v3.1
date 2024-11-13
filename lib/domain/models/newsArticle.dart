// 뉴스 데이터 

class NewsArticle {
  final String title; 
  final String reporter;
  final String date;
  final String summary;
  final String imageurl;
  final String newsurl;

  NewsArticle({
    required this.title,
    required this.reporter,
    required this.date,
    required this.summary,
    required this.imageurl,
    required this.newsurl,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      reporter: json['reporter'] ?? '', 
      date: json['date'] ?? '', 
      summary: json['summary'] ?? '', 
      imageurl: json['imageurl'] ?? '', 
      newsurl: json['newsurl'] ?? '',
      );
  }

}

