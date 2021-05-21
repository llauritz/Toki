// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Zeitnahme.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZeitnahmeAdapter extends TypeAdapter<Zeitnahme> {
  @override
  final int typeId = 1;

  @override
  Zeitnahme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Zeitnahme(
      day: fields[0] as DateTime,
      state: fields[1] as String,
      endTimes: (fields[3] as List)?.cast<int>(),
      startTimes: (fields[2] as List)?.cast<int>(),
    )
      ..tag = fields[4] as String
      ..editMilli = fields[5] as int
      ..autoStoppedTime = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, Zeitnahme obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.state)
      ..writeByte(2)
      ..write(obj.startTimes)
      ..writeByte(3)
      ..write(obj.endTimes)
      ..writeByte(4)
      ..write(obj.tag)
      ..writeByte(5)
      ..write(obj.editMilli)
      ..writeByte(6)
      ..write(obj.autoStoppedTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZeitnahmeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
