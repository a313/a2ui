import 'package:a2ui/prompts/system.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import 'package:meta/meta.dart';

part 'agent_event.dart';
part 'agent_state.dart';

class AgentBloc extends Bloc<AgentEvent, AgentState> {
  late final GenUiConversation conversation;

  AgentBloc() : super(const AgentInitial()) {
    _initializeConversation();

    on<AgentSendMessage>(_onSendMessage);
    on<AgentSurfaceAdded>(_onSurfaceAdded);
    on<AgentSurfaceDeleted>(_onSurfaceDeleted);
    on<AgentSurfaceUpdated>(_onSurfaceUpdated);
    on<AgentTextResponse>(_onTextResponse);
    on<AgentError>(_onError);
  }

  void _initializeConversation() {
    final catalog = CoreCatalogItems.asCatalog();
    final generator = FirebaseAiContentGenerator(
      modelCreator:
          ({required configuration, systemInstruction, toolConfig, tools}) =>
              GeminiGenerativeModel(
                FirebaseAI.googleAI().generativeModel(
                  model: 'gemini-2.5-pro',
                  systemInstruction: systemInstruction,
                  tools: tools,
                  toolConfig: toolConfig,
                ),
              ),
      catalog: catalog,
      systemInstruction: systemInstruction,
    );
    conversation = GenUiConversation(
      contentGenerator: generator,
      a2uiMessageProcessor: A2uiMessageProcessor(catalogs: [catalog]),
      onSurfaceAdded: (value) => add(AgentSurfaceAdded(value.surfaceId)),
      onSurfaceDeleted: (value) => add(AgentSurfaceDeleted(value.surfaceId)),
      onSurfaceUpdated: (value) => add(AgentSurfaceUpdated()),
      onTextResponse: (value) => add(AgentTextResponse(value)),
      onError: (value) => add(AgentError(value.error.toString())),
    );
  }

  Future<void> _onSendMessage(
    AgentSendMessage event,
    Emitter<AgentState> emit,
  ) async {
    final content = event.message.trim();
    if (content.isEmpty) return;

    emit(AgentLoading(surfaceIds: state.surfaceIds));

    try {
      print('Send Msg: $content');
      await conversation.sendRequest(UserMessage.text(content));
      emit(AgentUpdated(surfaceIds: state.surfaceIds, isLoading: false));
    } catch (e) {
      emit(
        AgentErrorState(
          surfaceIds: state.surfaceIds,
          errorMessage: 'Error sending message: $e',
        ),
      );
    }
  }

  void _onSurfaceAdded(AgentSurfaceAdded event, Emitter<AgentState> emit) {
    print("onSurfaceAdded ${event.surfaceId}");
    final updatedList = List<String>.from(state.surfaceIds)
      ..add(event.surfaceId);
    emit(AgentUpdated(surfaceIds: updatedList, isLoading: state.isLoading));
  }

  void _onSurfaceDeleted(AgentSurfaceDeleted event, Emitter<AgentState> emit) {
    print("onSurfaceDeleted ${event.surfaceId}");
    final updatedList = List<String>.from(state.surfaceIds)
      ..remove(event.surfaceId);
    emit(AgentUpdated(surfaceIds: updatedList, isLoading: state.isLoading));
  }

  void _onSurfaceUpdated(AgentSurfaceUpdated event, Emitter<AgentState> emit) {
    print("onSurfaceUpdated");
    emit(
      AgentUpdated(surfaceIds: state.surfaceIds, isLoading: state.isLoading),
    );
  }

  void _onTextResponse(AgentTextResponse event, Emitter<AgentState> emit) {
    print("onTextResponse ${event.text}");
    emit(
      AgentUpdated(
        surfaceIds: state.surfaceIds,
        isLoading: state.isLoading,
        textResponse: event.text,
      ),
    );
  }

  void _onError(AgentError event, Emitter<AgentState> emit) {
    print('onError: ${event.error}');
    emit(
      AgentErrorState(surfaceIds: state.surfaceIds, errorMessage: event.error),
    );
  }
}
