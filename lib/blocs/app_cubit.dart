import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_state.dart';
import '../services/gemini_tools.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required this.geminiTools}) : super(const AppState());

  final GeminiTools geminiTools;

  Future<void> initialize() async {
    try {
      emit(state.copyWith(isLoading: true));
      final systemPrompt = await rootBundle.loadString(
        'assets/system_prompt.md',
      );
      final geminiModel = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-1.5-pro',
        systemInstruction: Content.system(systemPrompt),
        tools: geminiTools.tools,
      );
      final chatSession = geminiModel.startChat();
      emit(
        state.copyWith(
          systemPrompt: systemPrompt,
          geminiModel: geminiModel,
          chatSession: chatSession,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> sendMessage(String message) async {
    if (state.chatSession == null) return;
    final updatedMessages = List<String>.from(state.messages)
      ..add('User: $message');
    emit(state.copyWith(messages: updatedMessages, isLoading: true));
    try {
      final responseStream = state.chatSession!.sendMessageStream(
        Content.text(message),
      );

      await for (final block in responseStream) {
        await _processBlock(block);
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _processBlock(GenerateContentResponse block) async {
    if (state.chatSession == null) return;
    final blockText = block.text;
    if (blockText != null) {
      // Add AI response to messages
      final updatedMessages = List<String>.from(state.messages)
        ..add('AI: $blockText');
      emit(state.copyWith(messages: updatedMessages));
    }
    if (block.functionCalls.isNotEmpty) {
      final responseStream = state.chatSession!.sendMessageStream(
        Content.functionResponses([
          for (final functionCall in block.functionCalls)
            FunctionResponse(
              functionCall.name,
              geminiTools.handleFunctionCall(
                functionCall.name,
                functionCall.args,

                updateBackgroundColor,
              ),
            ),
        ]),
      );

      await for (final response in responseStream) {
        final responseText = response.text;
        if (responseText != null) {
          final updatedMessages = List<String>.from(state.messages)
            ..add('AI: $responseText');
          emit(state.copyWith(messages: updatedMessages));
        }
      }
    }
  }

  void updateBackgroundColor(Color color) {
    emit(state.copyWith(backgroundColor: color));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
