import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'task_database.g.dart';

class TaskTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get userId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [TaskTable])
class TaskDriftDatabase extends _$TaskDriftDatabase {
  TaskDriftDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> upsertTask(TaskTableCompanion task) =>
      into(taskTable).insertOnConflictUpdate(task);

  Future<void> deleteTask(String id) =>
      (delete(taskTable)..where((t) => t.id.equals(id))).go();

  Future<TaskTableData?> getTask(String id) =>
      (select(taskTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<TaskTableData>> getAllTasksForUser(String userId) {
    return (select(taskTable)..where((t) => t.userId.equals(userId))).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'tasks.db');
    return NativeDatabase(File(dbPath));
  });
}
