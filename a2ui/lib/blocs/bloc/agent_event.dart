part of 'agent_bloc.dart';

@immutable
sealed class AgentEvent {}

final class AgentSendMessage extends AgentEvent {
  final String message;
  AgentSendMessage(this.message);
}

final class AgentSurfaceAdded extends AgentEvent {
  final String surfaceId;
  AgentSurfaceAdded(this.surfaceId);
}

final class AgentSurfaceDeleted extends AgentEvent {
  final String surfaceId;
  AgentSurfaceDeleted(this.surfaceId);
}

final class AgentSurfaceUpdated extends AgentEvent {
  AgentSurfaceUpdated();
}

final class AgentTextResponse extends AgentEvent {
  final String text;
  AgentTextResponse(this.text);
}

final class AgentError extends AgentEvent {
  final String error;
  AgentError(this.error);
}

final class AgentProcessingChanged extends AgentEvent {
  final bool isProcessing;
  AgentProcessingChanged(this.isProcessing);
}
