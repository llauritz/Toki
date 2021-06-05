// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Correction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CorrectionAdapter extends TypeAdapter<Correction> {
  @override
  final int typeId = 2;

  @override
  Correction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Correction(
      ab: fields[0] as int,
      um: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Correction obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ab)
      ..writeByte(1)
      ..write(obj.um);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CorrectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
