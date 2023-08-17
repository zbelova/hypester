import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hypester/telegram_only/telegram_categorydata.dart';
import 'package:hypester/telegram_only/telegram_categorymodel.dart';
import 'package:hypester/telegram_only/telegram_newsdata.dart';
import 'package:hypester/telegram_only/telegram_newsmodel.dart';

class TelegramNews extends StatefulWidget {
  const TelegramNews({Key? key}) : super(key: key);

  @override
  State<TelegramNews> createState() => _TelegramNewsState();
}

class _TelegramNewsState extends State<TelegramNews> {
  List<CategoryModel> categories = [];
  List<ArticleModel> articles = [];

  getNews() async {
    News newsdata = News();
    await newsdata.getNews();
    articles = newsdata.datatobesavein;
  }

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Telegram',
              style: TextStyle(color: Colors.blue),
            ),
            Text(
              'News',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                height: 70,
                padding: EdgeInsets.only(right: 16),
                child: ListView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoryTile(
                      imageUrl: categories[index].imageUrl,
                      categoryName: categories[index].categoryName,
                    );
                  },
                ),
              ),
              Container(
                child: ListView.builder(
                  itemCount: articles.length,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return NewsTemplate(
                      urlToImage: articles[index].urlToImage.toString(),
                      title: articles[index].title.toString(),
                      description: articles[index].description.toString(),
                      url: '',
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String categoryName, imageUrl;

  CategoryTile({required this.categoryName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: 170,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        
        Container(
          alignment: Alignment.center,
          width: 170,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            categoryName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}

class NewsTemplate extends StatelessWidget {
  String title, description, url, urlToImage;
  NewsTemplate(
      {required this.title,
      required this.description,
      required this.url,
      required this.urlToImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: urlToImage,
            width: 380,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          '$title',
          style: TextStyle (fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          '$description',
          style: TextStyle(fontSize: 15, color: Colors.grey[800]),
        ),
      ],),
    );
  }
}
