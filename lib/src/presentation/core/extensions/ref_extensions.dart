import 'package:facility_management_app/src/core/base/base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension InvalidateOnSuccess on Ref {
  /// Invalidates self whenever [targetProvider] emits a non-null success value.
  void invalidateProviderOnSuccess<T>(
    ProviderListenable<AsyncValue<T>> targetProvider,
  ) {
    listen(targetProvider, (_, next) {
      if (next.hasValue && next.value != null) {
        invalidateSelf();
      }
    });
  }
}

// WHY: Reusable function for manually updating state (mutations)
extension ResultToAsyncValue<T> on Result<T, Failure> {

  AsyncValue<T?> toAsyncValue(){

    return when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current)
    );
  }
}


// WHY: Resuable function for returning data directly (query)
extension ResultUnwrap<T> on Result<T, Failure> {

  T? getOrThrow(){
    return when(
      success: (data) => data,
      error: (error) => throw Exception(error.message)
    );
  }
}