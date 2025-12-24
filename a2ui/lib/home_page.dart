import 'package:a2ui/ds/ds_input.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GenUiConversation conversation;
  final _input = TextEditingController();
  final surfaceIds = <String>[];

  @override
  void initState() {
    super.initState();
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
      systemInstruction: "PROMPT",
    );
    conversation = GenUiConversation(
      contentGenerator: generator,
      a2uiMessageProcessor: A2uiMessageProcessor(catalogs: [catalog]),
      onSurfaceAdded: onSurfaceAdded,
      onSurfaceDeleted: onSurfaceDeleted,
      onSurfaceUpdated: onSurfaceUpdated,
      onTextResponse: onTextResponse,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: surfaceIds.length,
                itemBuilder: (context, index) {
                  final id = surfaceIds[index];
                  return GenUiSurface(host: conversation.host, surfaceId: id);
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DsInput(
                    hintText: 'How can I help you',
                    controller: _input,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_input.text);
                    _input.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onSurfaceAdded(SurfaceAdded value) {
    print("onSurfaceAdded $value");
    setState(() {
      surfaceIds.add(value.surfaceId);
    });
  }

  void onSurfaceDeleted(SurfaceRemoved value) {
    print("onSurfaceDeleted $value");
    setState(() {
      surfaceIds.remove(value.surfaceId);
    });
  }

  void onSurfaceUpdated(SurfaceUpdated value) {
    print("onSurfaceUpdated $value");
    setState(() {});
  }

  void onTextResponse(String value) {
    print("onTextResponse $value");
  }

  Future<void> sendMessage(String text) async {
    final content = text.trim();
    if (content.isNotEmpty) {
      return conversation.sendRequest(UserMessage.text(content));
    }
  }
}
