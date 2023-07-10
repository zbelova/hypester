import 'package:hypester/telegram_only/telegram_categorymodel.dart';


List<CategoryModel> getCategories() {

  List<CategoryModel> categories = [];
  CategoryModel category = CategoryModel();

  category.categoryName = 'IT';
  category.imageUrl = 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png';
  categories.add(category);

  category = CategoryModel();
  category.categoryName = 'Трейдинг';
  category.imageUrl = 'https://trendup.pro/wp-content/uploads/2022/08/volchok.jpg';
  categories.add(category);

  category = CategoryModel();
  category.categoryName = 'Бизнес';
  category.imageUrl = 'https://cdnn21.img.ria.ru/images/07e6/02/0a/1772160446_0:322:3068:2048_1920x0_80_0_0_863dcd2722477df941cfc3f88849cc2e.jpg';
  categories.add(category);

  return categories;

}



