// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tasksHash() => r'7d05401b2887795de32e0039f1797209fa2f137b';

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
