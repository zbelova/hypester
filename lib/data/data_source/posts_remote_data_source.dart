import 'package:hypester/data/dto/posts_response.dart';

class PostRemoteDatasource {
  //final Dio _dio; ? Будем ли dio использовать?

  PostRemoteDatasource(this._dio);
  Future<List<RedditPostRemoteDto>> getAll() {
    //какой у нас метод для получения постов?
    final response = _dio.get('ссылка на получение постов');
  }
}
