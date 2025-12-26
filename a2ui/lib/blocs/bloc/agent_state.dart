part of 'agent_bloc.dart';

@immutable
sealed class AgentState {
  final List<String> surfaceIds;
  final String? errorMessage;
  final String? textResponse;
  final bool isLoading;

  const AgentState({
    this.surfaceIds = const [],
    this.errorMessage,
    this.textResponse,
    this.isLoading = false,
  });
}

final class AgentInitial extends AgentState {
  const AgentInitial() : super();
}

final class AgentUpdated extends AgentState {
  const AgentUpdated({
    required super.surfaceIds,
    super.errorMessage,
    super.textResponse,
    super.isLoading,
  });
}

final class AgentLoading extends AgentState {
  const AgentLoading({required super.surfaceIds}) : super(isLoading: true);
}

final class AgentErrorState extends AgentState {
  const AgentErrorState({
    required super.surfaceIds,
    required super.errorMessage,
  });
}
