import 'dart:convert';

import 'package:hypester/telegram_only/telegram_newsmodel.dart';
import 'package:http/http.dart';

class News {

  List<ArticleModel> datatobesavein = [];

  Future<void> getNews() async{


    var response =  await get (Uri.parse('http://newsapi.org/v2/top-headlines?country=us&apiKey=d25659b7288d44b0b3f8763c0042fe52'));

   
    var jsonData = jsonDecode(response.body);


    if(jsonData['status'] == 'ok') {

      jsonData['articles'].forEach((element){

        if(element['urlToImage']!=null && element['description']!=null){
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            url: element['url'],
          );

          datatobesavein.add(articleModel);
        }
      });
    }
  }


}


class CategoryNews {

  List<ArticleModel> datatobesavein = [];

  Future<void> getNews (String category) async{

    var response =  await get('http://newsapi.org/v2/top-headlines?country=$category&apiKey=52489cf346804f2eb180b8e34528aa26' as Uri);
    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == 'ok') {

      jsonData['articles'].forEach((element){

        if(element['urlToImage']!=null && element['description']!=null){
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            url: element['url'],
          );

          datatobesavein.add(articleModel);
        }
      });
    }
  }


}