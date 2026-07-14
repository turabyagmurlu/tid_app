part of 'srs_cubit.dart';

class SrsState extends Equatable {
  final List<WordModel> dueWords;
  final int index;
  final bool finished;

  const SrsState({
    required this.dueWords,
    required this.index,
    required this.finished,
  });

  const SrsState.initial()
      : dueWords = const [],
        index = 0,
        finished = false;

  WordModel? get current =>
      dueWords.isEmpty || index >= dueWords.length ? null : dueWords[index];
  int get total => dueWords.length;

  SrsState copyWith({
    List<WordModel>? dueWords,
    int? index,
    bool? finished,
  }) {
    return SrsState(
      dueWords: dueWords ?? this.dueWords,
      index: index ?? this.index,
      finished: finished ?? this.finished,
    );
  }

  @override
  List<Object?> get props => [dueWords, index, finished];
}
