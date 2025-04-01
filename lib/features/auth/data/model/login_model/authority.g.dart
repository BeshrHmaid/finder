// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authority.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthorityAdapter extends TypeAdapter<Authority> {
  @override
  final int typeId = 3;

  @override
  Authority read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Authority(
      authority: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Authority obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.authority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
