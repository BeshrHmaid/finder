// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      password: fields[3] as String?,
      roles: (fields[4] as List?)?.cast<Role>(),
      enabled: fields[5] as bool?,
      credentialsNonExpired: fields[6] as bool?,
      accountNonExpired: fields[7] as bool?,
      accountNonLocked: fields[8] as bool?,
      balance: fields[11] as dynamic,
      username: fields[9] as String?,
      authorities: (fields[10] as List?)?.cast<Authority>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.roles)
      ..writeByte(5)
      ..write(obj.enabled)
      ..writeByte(6)
      ..write(obj.credentialsNonExpired)
      ..writeByte(7)
      ..write(obj.accountNonExpired)
      ..writeByte(8)
      ..write(obj.accountNonLocked)
      ..writeByte(9)
      ..write(obj.username)
      ..writeByte(10)
      ..write(obj.authorities)
      ..writeByte(11)
      ..write(obj.balance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
