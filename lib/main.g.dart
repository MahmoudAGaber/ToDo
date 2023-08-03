
part of 'main.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = 0; // You can use any unique positive integer here.

  @override
  Color read(BinaryReader reader) {
    int value = reader.readInt();
    return Color(value);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.value);
  }
}

class ToDoListModelAdapter extends TypeAdapter<ToDoListModel> {
  @override
  final int typeId = 1;

  @override
  ToDoListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDoListModel(
      id: fields[0] as String,
      color: Color(fields[1] as int),
      taskName: fields[2] as String,
      taskDesc: fields[3] as String,
      date:fields[4] as String,
      time: fields[5] as String,
    );
  }



  @override
  void write(BinaryWriter writer, ToDoListModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.color.value)
      ..writeByte(2)
      ..write(obj.taskName)
      ..writeByte(3)
      ..write(obj.taskDesc)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.time);

  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ToDoListModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}