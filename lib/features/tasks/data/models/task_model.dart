import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

/// Persistence/transport DTO. Enums are stored as their `name` strings so the
/// shape matches what a future sync API would exchange.
@freezed
abstract class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String title,
    String? description,
    required String priority,
    required bool completed,
    required DateTime createdAt,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}
