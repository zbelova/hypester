import 'package:freezed_annotation/freezed_annotation.dart';

part 'posts_response.g.dart';
part 'posts_response.freezed.dart';

@freezed
class RedditPostsResponse with _$RedditPostsResponse {
  const factory RedditPostsResponse({required List<RedditPostDto> posts}) =
      _RedditPostsResponse;

  factory RedditPostsResponse.fromJson(Map<String, dynamic> json) =>
      _$RedditPostsResponseFromJson(json);
}

@freezed
class RedditPostRemoteDto {
  const factory RedditPostRemoteDto({
    String? thumbnail,
    required String title,
    String? ups,
    required String selftext,
  }) = _RedditPostRemoteDto;

  factory RedditPostRemoteDto.fromJson(Map<String, dynamic> json) =>
      _$RedditPostRemoteDtoFromJson(json);
}
