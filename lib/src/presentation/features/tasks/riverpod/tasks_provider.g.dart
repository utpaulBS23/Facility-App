// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tasksHash() => r'64be5bc8d89d4353d6ad9e17cdcebeea562f871d';

/// See also [Tasks].
@ProviderFor(Tasks)
final tasksProvider =
    AutoDisposeNotifierProvider<Tasks, AsyncValue<List<TaskEntity>>>.internal(
      Tasks.new,
      name: r'tasksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tasksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Tasks = AutoDisposeNotifier<AsyncValue<List<TaskEntity>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
