// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_local_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RedditPostLocalDtoAdapter extends TypeAdapter<RedditPostLocalDto> {
  @override
  final int typeId = 0;

  @override
  RedditPostLocalDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RedditPostLocalDto(
      title: fields[0] as String,
      id: fields[4] as String,
      likes: fields[3] as int,
      author: fields[5] as String,
      url: fields[6] as String,
      subreddit: fields[7] as String,
      date: fields[8] as DateTime,
      image: fields[1] as String?,
      body: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RedditPostLocalDto obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.likes)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.author)
      ..writeByte(6)
      ..write(obj.url)
      ..writeByte(7)
      ..write(obj.subreddit)
      ..writeByte(8)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RedditPostLocalDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
