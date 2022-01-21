// GENERATED CODE - DO NOT MODIFY BY HAND

part of models;

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppAccountAdapter extends TypeAdapter<AppAccount> {
  @override
  final int typeId = 11;

  @override
  AppAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppAccount(
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      id: fields[0] as String?,
      accounts: (fields[3] as List).cast<SchoolAccount>(),
    );
  }

  @override
  void write(BinaryWriter writer, AppAccount obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.accounts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SchoolAccountAdapter extends TypeAdapter<SchoolAccount> {
  @override
  final int typeId = 12;

  @override
  SchoolAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolAccount(
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      className: fields[3] as String,
      id: fields[0] as String,
      profilePicture: fields[4] as String,
      school: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolAccount obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.className)
      ..writeByte(4)
      ..write(obj.profilePicture)
      ..writeByte(5)
      ..write(obj.school);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SchoolLifeSanctionAdapter extends TypeAdapter<SchoolLifeSanction> {
  @override
  final int typeId = 1;

  @override
  SchoolLifeSanction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolLifeSanction(
      type: fields[0] as String,
      registrationDate: fields[1] as String,
      reason: fields[2] as String,
      by: fields[3] as String,
      date: fields[4] as DateTime,
      sanction: fields[5] as String,
      work: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolLifeSanction obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.registrationDate)
      ..writeByte(2)
      ..write(obj.reason)
      ..writeByte(3)
      ..write(obj.by)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.sanction)
      ..writeByte(6)
      ..write(obj.work);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolLifeSanctionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SchoolLifeTicketAdapter extends TypeAdapter<SchoolLifeTicket> {
  @override
  final int typeId = 0;

  @override
  SchoolLifeTicket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolLifeTicket(
      duration: fields[0] as String,
      displayDate: fields[1] as String,
      reason: fields[2] as String,
      type: fields[3] as String,
      isJustified: fields[4] as bool,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SchoolLifeTicket obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.duration)
      ..writeByte(1)
      ..write(obj.displayDate)
      ..writeByte(2)
      ..write(obj.reason)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.isJustified)
      ..writeByte(5)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolLifeTicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PeriodAdapter extends TypeAdapter<Period> {
  @override
  final int typeId = 3;

  @override
  Period read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Period(
      id: fields[0] as String,
      name: fields[1] as String,
      startDate: fields[2] as DateTime,
      endDate: fields[3] as DateTime,
      headTeacher: fields[4] as String,
      overallAverage: fields[5] as double,
      classAverage: fields[6] as double,
      maxAverage: fields[7] as double,
      minAverage: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Period obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.headTeacher)
      ..writeByte(5)
      ..write(obj.overallAverage)
      ..writeByte(6)
      ..write(obj.classAverage)
      ..writeByte(7)
      ..write(obj.maxAverage)
      ..writeByte(8)
      ..write(obj.minAverage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmailAdapter extends TypeAdapter<Email> {
  @override
  final int typeId = 7;

  @override
  Email read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Email(
      id: fields[0] as String,
      read: fields[1] as bool,
      from: fields[2] as Recipient,
      subject: fields[3] as String,
      date: fields[4] as DateTime,
      content: fields[5] as String?,
      documentsIds: (fields[6] as List).cast<String>(),
      to: (fields[7] as List).cast<Recipient>(),
    );
  }

  @override
  void write(BinaryWriter writer, Email obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.read)
      ..writeByte(2)
      ..write(obj.from)
      ..writeByte(3)
      ..write(obj.subject)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.documentsIds)
      ..writeByte(7)
      ..write(obj.to);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecipientAdapter extends TypeAdapter<Recipient> {
  @override
  final int typeId = 8;

  @override
  Recipient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipient(
      id: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      civility: fields[3] as String,
      headTeacher: fields[4] as bool,
      subjects: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recipient obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.civility)
      ..writeByte(4)
      ..write(obj.headTeacher)
      ..writeByte(5)
      ..write(obj.subjects);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HomeworkAdapter extends TypeAdapter<Homework> {
  @override
  final int typeId = 9;

  @override
  Homework read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Homework(
      id: fields[0] as String,
      subjectId: fields[1] as String,
      content: fields[2] as String?,
      date: fields[3] as DateTime,
      entryDate: fields[4] as DateTime,
      done: fields[5] as bool,
      due: fields[6] as bool,
      assessment: fields[7] as bool,
      pinned: fields[8] as bool,
      documentsIds: (fields[9] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Homework obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subjectId)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.entryDate)
      ..writeByte(5)
      ..write(obj.done)
      ..writeByte(6)
      ..write(obj.due)
      ..writeByte(7)
      ..write(obj.assessment)
      ..writeByte(8)
      ..write(obj.pinned)
      ..writeByte(9)
      ..write(obj.documentsIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeworkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 10;

  @override
  Document read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Document(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      saved: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.saved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
