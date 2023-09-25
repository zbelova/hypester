// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subreddit_local_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubredditLocalDtoAdapter extends TypeAdapter<SubredditLocalDto> {
  @override
  final int typeId = 1;

  @override
  SubredditLocalDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubredditLocalDto(
      title: fields[0] as String,
      icon: fields[1] as String,
      displayName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubredditLocalDto obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.displayName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubredditLocalDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
