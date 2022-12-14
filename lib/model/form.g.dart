// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormAdapter extends TypeAdapter<Form> {
  @override
  final int typeId = 1;

  @override
  Form read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Form(
      fields[0] as String,
      fields[1] as DateTime,
      fields[2] as DateTime,
      (fields[3] as List).cast<Question>(),
    );
  }

  @override
  void write(BinaryWriter writer, Form obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.start)
      ..writeByte(2)
      ..write(obj.end)
      ..writeByte(3)
      ..write(obj.questions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
