import 'package:firebase_ai/firebase_ai.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppState extends Equatable {
  final GenerativeModel? geminiModel;
  final ChatSession? chatSession;
  final String? systemPrompt;
  final bool isLoading;
  final String? error;

  final Color backgroundColor;
  final List<String> messages;

  const AppState({
    this.geminiModel,
    this.chatSession,
    this.systemPrompt,
    this.isLoading = false,
    this.error,

    this.backgroundColor = Colors.white,
    this.messages = const [],
  });

  AppState copyWith({
    GenerativeModel? geminiModel,
    ChatSession? chatSession,
    String? systemPrompt,
    bool? isLoading,
    String? error,
    Color? backgroundColor,
    List<String>? messages,
  }) {
    return AppState(
      geminiModel: geminiModel ?? this.geminiModel,
      chatSession: chatSession ?? this.chatSession,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,

      backgroundColor: backgroundColor ?? this.backgroundColor,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
    geminiModel,
    chatSession,
    systemPrompt,
    isLoading,
    error,

    backgroundColor,
    messages,
  ];
}
