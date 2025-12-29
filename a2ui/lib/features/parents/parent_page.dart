import 'package:a2ui/blocs/bloc/agent_bloc.dart';
import 'package:a2ui/ds/ds_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:go_router/go_router.dart';

class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  final _input = TextEditingController();

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
      appBar: AppBar(title: const Text("Parent Page")),
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.telegram),
        onPressed: () {
          context.go('/test');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<AgentBloc, AgentState>(
                listener: (context, state) {
                  if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage!)),
                    );
                  }
                  if (state.textResponse != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.textResponse!)),
                    );
                  }
                },
                builder: (context, state) {
                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: state.surfaceIds.length,
                    itemBuilder: (context, index) {
                      final id = state.surfaceIds[index];
                      final bloc = context.read<AgentBloc>();
                      return GenUiSurface(
                        host: bloc.conversation.host,
                        surfaceId: id,
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: DsInput(
                      hintText: 'How can I help you',
                      textInputAction: TextInputAction.send,
                      controller: _input,
                      onSubmitted: (value) {
                        _sendMessage(context, value);
                      },
                    ),
                  ),
                  BlocBuilder<AgentBloc, AgentState>(
                    builder: (context, state) {
                      return IconButton(
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context, String text) {
    if (text.trim().isNotEmpty) {
      context.read<AgentBloc>().add(AgentSendMessage(text));
      _input.clear();
    }
  }
}
