// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:agentic_app_demo/firebase_options.dart';
import 'package:agentic_app_demo/screens/email_screen.dart';
import 'package:agentic_app_demo/screens/error_screen.dart';
import 'package:agentic_app_demo/screens/loading_screen.dart';
import 'package:agentic_app_demo/services/gemini_tools.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/app_cubit.dart';
import 'blocs/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => GeminiTools(),
      child: BlocProvider(
        create:
            (context) =>
                AppCubit(geminiTools: context.read<GeminiTools>())
                  ..initialize(),
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const MainScreenWrapper(),
        ),
      ),
    );
  }
}

class MainScreenWrapper extends StatelessWidget {
  const MainScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state.isLoading && state.messages.isEmpty) {
          return const LoadingScreen(message: 'Initializing Gemini Model');
        }

        if (state.error != null) {
          return ErrorScreen(error: state.error!);
        }

        if (state.geminiModel == null) {
          return const LoadingScreen(message: 'Loading...');
        }

        return EmailScreen(
          themeColor: state.backgroundColor,
          messages: state.messages,
          isLoading: state.isLoading,
          onSendMessage: (text) {
            context.read<AppCubit>().sendMessage(text);
          },
        );
      },
    );
  }
}
