import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'screens/inicio_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MiApp()));
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(home: PantallaInicio());
}
