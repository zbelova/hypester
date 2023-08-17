import 'package:hypester/telegram_only/telegram_categorymodel.dart';


List<CategoryModel> getCategories() {

  List<CategoryModel> categories = [
  CategoryModel(
    categoryName: 'IT',
    imageUrl: 'https://blog.planview.com/wp-content/uploads/2020/01/Top-6-Software-Development-Methodologies.jpg',
  ),

  CategoryModel(
    categoryName: 'Трейдинг',
    imageUrl: 'https://www.invest-rating.ru/wp-content/uploads/2021/11/onlajn-trejding.jpg',
  ),

  CategoryModel(
    categoryName: 'Бизнес',
    imageUrl: 'https://www.imemo.ru/files/Image/COMMENTS_PICS/2020/16042020-ARPIC-010A.jpg',
  ),
  ];

  return categories;

}



