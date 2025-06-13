// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';

class GeminiTools {
  FunctionDeclaration get setColorFuncDecl => FunctionDeclaration(
    'set_color',
    'Set the color of the display based on red, green, and blue values.',
    parameters: {
      'red': Schema.number(description: 'Red component value (0.0 - 1.0)'),
      'green': Schema.number(description: 'Green component value (0.0 - 1.0)'),
      'blue': Schema.number(description: 'Blue component value (0.0 - 1.0)'),
    },
  );

  List<Tool> get tools => [
    Tool.functionDeclarations([setColorFuncDecl]),
  ];

  Map<String, Object?> handleFunctionCall(
    String functionName,
    Map<String, Object?> arguments,
    Function(Color) updateColor,
  ) {
    // Log function call
    return switch (functionName) {
      'set_color' => handleSetColor(arguments, updateColor),
      _ => handleUnknownFunction(functionName),
    };
  }

  Map<String, Object?> handleSetColor(
    Map<String, Object?> arguments,
    Function(Color) updateColor,
  ) {
    final red = (arguments['red'] as num).toDouble();
    final green = (arguments['green'] as num).toDouble();
    final blue = (arguments['blue'] as num).toDouble();

    // Convert RGB values (0.0-1.0) to Color
    final color = Color.fromARGB(
      255,
      (red * 255).round(),
      (green * 255).round(),
      (blue * 255).round(),
    );

    updateColor(color);

    return {
      'success': true,
      'current_color': {'red': red, 'green': green, 'blue': blue},
    };
  }

  Map<String, Object?> handleUnknownFunction(String functionName) {
    return {
      'success': false,
      'reason': 'Unsupported function call $functionName',
    };
  }
}
