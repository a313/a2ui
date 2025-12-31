import 'package:a2ui/genui/comparison_schema.dart';
import 'package:a2ui/genui/counting_operation_schema.dart';
import 'package:a2ui/genui/exercise_type.dart';
import 'package:a2ui/genui/math_type.dart';
import 'package:a2ui/genui/operation_schema.dart';
import 'package:a2ui/prompts/system_vi.dart';
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
    on<AgentProcessingChanged>(_onProcessingChanged);
  }

  void _initializeConversation() {
    final catalog = CoreCatalogItems.asCatalog().copyWith([
      exerciseTypeSelector,
      mathTypeSelector,
      exerciseComparisonWidgetCatalogItem,
      exerciseCountingOperationWidgetCatalogItem,
      exerciseOperationWidgetCatalogItem,
    ]);
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
      systemInstruction: systemInstructionVI,
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
    conversation.isProcessing.addListener(() {
      add(AgentProcessingChanged(conversation.isProcessing.value));
    });
  }

  Future<void> _onSendMessage(
    AgentSendMessage event,
    Emitter<AgentState> emit,
  ) async {
    final content = event.message.trim();
    if (content.isEmpty) return;
    emit(
      AgentUpdated(
        messages: [
          ...conversation.conversation.value,
          UserMessage.text(content),
        ],
        isLoading: true,
      ),
    );
    await conversation.sendRequest(UserMessage.text(content));
    emit(
      AgentUpdated(messages: conversation.conversation.value, isLoading: false),
    );
  }

  void _onSurfaceAdded(AgentSurfaceAdded event, Emitter<AgentState> emit) {
    emit(
      AgentUpdated(messages: conversation.conversation.value, isLoading: false),
    );
  }

  void _onSurfaceDeleted(AgentSurfaceDeleted event, Emitter<AgentState> emit) {
    emit(
      AgentUpdated(messages: conversation.conversation.value, isLoading: false),
    );
  }

  void _onSurfaceUpdated(AgentSurfaceUpdated event, Emitter<AgentState> emit) {
    emit(
      AgentUpdated(messages: conversation.conversation.value, isLoading: false),
    );
  }

  void _onTextResponse(AgentTextResponse event, Emitter<AgentState> emit) {
    emit(
      AgentUpdated(messages: conversation.conversation.value, isLoading: false),
    );
  }

  void _onError(AgentError event, Emitter<AgentState> emit) {
    print('onError: ${event.error}');
  }

  void _onProcessingChanged(
    AgentProcessingChanged event,
    Emitter<AgentState> emit,
  ) {
    emit(
      AgentUpdated(
        messages: conversation.conversation.value,
        isLoading: event.isProcessing,
      ),
    );
  }
}
