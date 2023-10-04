// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_filters.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedFiltersAdapter extends TypeAdapter<FeedFilters> {
  @override
  final int typeId = 2;

  @override
  FeedFilters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeedFilters(
      keyword: fields[0] as String,
      redditLikesFilter: fields[1] as int,
      searchInSubreddits: fields[2] as bool,
      vkLikesFilter: fields[3] as int,
      vkViewsFilter: fields[4] as int,
      youtubeLikesFilter: fields[5] as int,
      youtubeViewsFilter: fields[6] as int,
      searchInChannels: fields[7] as bool,
      telegramViewsFilter: fields[8] as int,
      instagramLikesFilter: fields[9] as int,
      instagramViewsFilter: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FeedFilters obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.keyword)
      ..writeByte(1)
      ..write(obj.redditLikesFilter)
      ..writeByte(2)
      ..write(obj.searchInSubreddits)
      ..writeByte(3)
      ..write(obj.vkLikesFilter)
      ..writeByte(4)
      ..write(obj.vkViewsFilter)
      ..writeByte(5)
      ..write(obj.youtubeLikesFilter)
      ..writeByte(6)
      ..write(obj.youtubeViewsFilter)
      ..writeByte(7)
      ..write(obj.searchInChannels)
      ..writeByte(8)
      ..write(obj.telegramViewsFilter)
      ..writeByte(9)
      ..write(obj.instagramLikesFilter)
      ..writeByte(10)
      ..write(obj.instagramViewsFilter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedFiltersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
