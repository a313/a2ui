import 'package:a2ui/blocs/bloc/agent_bloc.dart';
import 'package:a2ui/ds/ds_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';

class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  final _input = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton.small(
      //   child: Icon(Icons.telegram),
      //   onPressed: () {
      //     context.go('/test');
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<AgentBloc, AgentState>(
                listener: (context, state) {
                  _scrollToBottom();
                },
                listenWhen: (previous, current) {
                  return previous.isLoading != current.isLoading;
                },
                builder: (context, state) {
                  return ListView.builder(
                    keyboardDismissBehavior: .onDrag,
                    controller: _scrollController,
                    padding: EdgeInsets.all(12),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      switch (message) {
                        case UserMessage():
                          return ChatMessageWidget(
                            text: message.text,
                            icon: Icons.person_3,
                            alignment: .end,
                          );
                        case AiTextMessage():
                          return ChatMessageWidget(
                            text: message.text,
                            icon: Icons.smart_toy_rounded,
                            alignment: .start,
                          );
                        case AiUiMessage():
                          return GenUiSurface(
                            key: message.uiKey,
                            host: context.read<AgentBloc>().conversation.host,
                            surfaceId: message.surfaceId,
                          );
                        default:
                          return Text(message.runtimeType.toString());
                      }
                    },
                  );
                },
              ),
            ),
            BlocBuilder<AgentBloc, AgentState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DsInput(
                          hintText: 'How can I help you',
                          textInputAction: TextInputAction.send,
                          controller: _input,
                          onSubmitted: (value) {
                            if (!state.isLoading) {
                              _sendMessage(context, value);
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: state.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send),
                        onPressed: state.isLoading
                            ? null
                            : () {
                                _sendMessage(context, _input.text);
                              },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(BuildContext context, String text) {
    if (text.trim().isNotEmpty) {
      _scrollToBottom();
      context.read<AgentBloc>().add(AgentSendMessage(text));
      _input.clear();
    }
  }
}
