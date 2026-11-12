import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_activity_model.freezed.dart';
part 'task_activity_model.g.dart';

@freezed
abstract class TaskActivityModel with _$TaskActivityModel {
  const factory TaskActivityModel({
    required String id,
    required String taskId,
    required String type,
    String? oldValue,
    String? newValue,
    required DateTime createdAt,
  }) = _TaskActivityModel;

  factory TaskActivityModel.fromJson(Map<String, dynamic> json) =>
      _$TaskActivityModelFromJson(json);
}
