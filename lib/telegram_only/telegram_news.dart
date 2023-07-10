import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hypester/telegram_only/telegram_categorydata.dart';
import 'package:hypester/telegram_only/telegram_categorymodel.dart';

class TelegramNews extends StatefulWidget {
  const TelegramNews({Key? key}) : super(key: key);

  @override
  State<TelegramNews> createState() => _TelegramNewsState();
}

class _TelegramNewsState extends State<TelegramNews> {
  List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    categories = getCategories();
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
      body: Container(
        color: Colors.white,
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
            )
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String? categoryName, imageUrl;

  CategoryTile({this.categoryName, this.imageUrl});

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
          width: 170,  height: 90, color: Colors.black,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            categoryName!,
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
