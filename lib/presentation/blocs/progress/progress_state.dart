part of 'progress_cubit.dart';

class ProgressState extends Equatable {
  final UserProgress progress;
  const ProgressState(this.progress);

  @override
  List<Object?> get props => [progress];
}
