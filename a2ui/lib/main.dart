import 'package:a2ui/blocs/bloc/agent_bloc.dart';
import 'package:a2ui/features/test_widgets.dart';
import 'package:a2ui/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AgentBloc>(create: (BuildContext context) => AgentBloc()),
      ],

      child: const MaterialApp(home: TestWidgets()),
    );
  }
}
