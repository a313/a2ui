part of 'agent_bloc.dart';

@immutable
sealed class AgentState {
  final List<ChatMessage> messages;
  final bool isLoading;

  const AgentState({this.messages = const [], this.isLoading = false});
}

final class AgentInitial extends AgentState {
  const AgentInitial() : super();
}

final class AgentUpdated extends AgentState {
  const AgentUpdated({required super.messages, super.isLoading});
}

final class AgentLoading extends AgentState {
  const AgentLoading({required super.messages}) : super(isLoading: true);
}
