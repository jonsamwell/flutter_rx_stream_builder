import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

/// Rx stream builder that will pre-populate the streams initial data if the
/// given stream is an rx observable that holds the streams current value such
/// as a `BehaviorSubject` or a `ReplaySubject`
class RxStreamBuilder<T> extends StatefulWidget {
  /// The asynchronous computation to which this builder is currently connected,
  /// possibly null. When changed, the current summary is updated using
  /// [afterDisconnected], if the previous stream was not null, followed by
  /// [afterConnected], if the new stream is not null.
  final Stream<T> stream;

  /// The build strategy currently used by this builder.
  final AsyncWidgetBuilder<T> builder;

  /// The data that will be used to create the initial snapshot.
  /// Note that the data held with a value / replay  stream (if is is not null)
  /// will take precedence over the data provided.
  final T? initialData;

  /// If the given stream is a ReplayObservable then this zero-based index
  /// will be used to pick the value to use as the initial data.
  /// Defaults to the last emitted value.
  final int? valuesSnapshotIndex;

  /// Creates a new [RxStreamBuilder] that builds itself based on the latest
  /// snapshot of interaction with the specified [stream] and whose build
  /// strategy is given by [builder].
  ///
  /// If the given stream is of a type that stores data like a BehaviorSubject,
  /// ReplaySubject or a variant it's stored data will be used for the inner
  /// StreamBuilder's initial data giving a measurable performance improvement.
  ///
  /// The [initialData] is used to create the initial snapshot.
  ///
  /// The [stream] must not be null.
  /// The [builder] must not be null.
  const RxStreamBuilder({
    required this.stream,
    required this.builder,
    this.initialData,
    this.valuesSnapshotIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RxStreamBuilderState<T>();
}

class _RxStreamBuilderState<T> extends State<RxStreamBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    final initialData = _getInitialData(widget.stream);
    return StreamBuilder(
      initialData: initialData,
      stream: widget.stream,
      builder: widget.builder,
    );
  }

  T? _getInitialData(Stream<T> stream) {
    T? initialData;
    if (widget.initialData != null) {
      initialData = widget.initialData!;
    } else if (stream is ValueStream<T> && stream.hasValue) {
      initialData = stream.value;
    } else if (stream is ReplayStream<T>) {
      if (widget.valuesSnapshotIndex != null &&
          stream.values.length >= widget.valuesSnapshotIndex!) {
        initialData = stream.values.elementAt(widget.valuesSnapshotIndex!);
      } else if (stream.values.isNotEmpty) {
        initialData = stream.values.last;
      }
    }

    return initialData;
  }
}
