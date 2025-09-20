import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:myquiz/prefs/qz_model.dart';

class Parsering {
  static const TEXT = 'text';
  static const TEX_INLINE = 'tex_inline';
  static const TEX_DISPLAY = 'tex_display';

  static List<Map<String, String>> parseLatexText(String inputText) {
    // Expresión regular para tex display ($$...$$) - tiene prioridad
    final RegExp displayTexRegex = RegExp(r'\$\$(.*?)\$\$', dotAll: true);

    // Expresión regular para tex inline ($...$) que NO esté dentro de $$...$$
    final RegExp inlineTexRegex = RegExp(
      r'(?<!\$)\$(?!\$)(.*?)(?<!\$)\$(?!\$)',
      dotAll: true,
    );

    final List<Map<String, String>> result = [];
    int currentIndex = 0;

    // Primero procesamos los matches de display tex
    final displayMatches = displayTexRegex.allMatches(inputText);
    final List<_TexMatch> allMatches = [
      ...displayMatches.map(
        (match) =>
            _TexMatch(match.start, match.end, match.group(1)!, 'tex_display'),
      ),
    ];

    // Luego procesamos inline tex, evitando superposición con display tex
    final inlineMatches = inlineTexRegex.allMatches(inputText);
    for (final match in inlineMatches) {
      bool isInsideDisplay = allMatches.any(
        (displayMatch) =>
            match.start >= displayMatch.start && match.end <= displayMatch.end,
      );

      if (!isInsideDisplay) {
        allMatches.add(
          _TexMatch(match.start, match.end, match.group(1)!, 'tex_inline'),
        );
      }
    }

    // Ordenar todos los matches por posición
    allMatches.sort((a, b) => a.start.compareTo(b.start));

    for (final match in allMatches) {
      // Texto normal antes del match
      if (match.start > currentIndex) {
        final plainText = inputText.substring(currentIndex, match.start);
        // Eliminar solo saltos de línea, mantener espacios
        final cleanedText = plainText.replaceAll(RegExp(r'\n+'), ' ').trim();
        if (cleanedText.isNotEmpty) {
          result.add({'content': cleanedText, 'type': 'text'});
        }
      }

      // Contenido LaTeX
      final latexContent = match.content.trim();
      if (latexContent.isNotEmpty) {
        result.add({'content': latexContent, 'type': match.type});
      }

      currentIndex = match.end;
    }

    // Texto después del último match
    if (currentIndex < inputText.length) {
      final remainingText = inputText.substring(currentIndex);
      // Eliminar solo saltos de línea, mantener espacios
      final cleanedText = remainingText.replaceAll(RegExp(r'\n+'), ' ').trim();
      if (cleanedText.isNotEmpty) {
        result.add({'content': cleanedText, 'type': 'text'});
      }
    }

    return result;
  }

  static Widget renderParsedContent(
    List<Map<String, String>> parsedContent, {
    TextStyle? textStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildContentWidgets(parsedContent, textStyle: textStyle),
    );
  }

  static List<Widget> _buildContentWidgets(
    List<Map<String, String>> parsedContent, {
    TextStyle? textStyle,
  }) {
    final List<Widget> widgets = [];
    final List<Widget> currentTextLine = [];

    for (final element in parsedContent) {
      final String type = element['type']!;
      final String content = element['content']!;

      if (type == 'tex_display') {
        // Si hay elementos en la línea actual, los agregamos primero
        if (currentTextLine.isNotEmpty) {
          widgets.add(
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: currentTextLine.toList(),
            ),
          );
          currentTextLine.clear();
        }

        // Agregar la ecuación display
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Math.tex(
                content,
                mathStyle: MathStyle.display,
                textStyle: textStyle,
                onErrorFallback: (error) => Text(
                  'Error: $content',
                  style: textStyle?.copyWith(color: Colors.red),
                ),
              ),
            ),
          ),
        );
      } else {
        // Para texto e inline tex, agregar a la línea actual
        Widget widget;
        if (type == 'tex_inline') {
          widget = Math.tex(
            content,
            mathStyle: MathStyle.text,
            textStyle: textStyle,
            onErrorFallback: (error) => Text(
              'Error: $content',
              style: textStyle?.copyWith(color: Colors.red),
            ),
          );
        } else {
          widget = Text(content, style: textStyle);
        }
        currentTextLine.add(widget);

        // Agregar un espacio entre elementos inline (excepto después del último)
        if (currentTextLine.length > 1) {
          currentTextLine.insert(
            currentTextLine.length - 1,
            SizedBox(width: 4),
          );
        }
      }
    }

    // Agregar la última línea si existe
    if (currentTextLine.isNotEmpty) {
      widgets.add(
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: currentTextLine,
        ),
      );
    }

    return widgets;
  }

  static bool allElementsHaveContent(List<String> list) {
    for (final element in list) {
      final trimmed = element.trim();
      if (trimmed.isEmpty || !RegExp(r'[a-zA-Z0-9]').hasMatch(trimmed)) {
        return false;
      }
    }
    return true;
  }

  static List<T> shuffleList<T>(List<T> list) {
    final newList = List<T>.from(list); // Crear una copia
    newList.shuffle(); // Mezclar la copia
    return newList;
  }

  static List<T> addAndShuffleList<T>(
    List<T> list,
    T value,
    bool shouldShuffle,
  ) {
    if (!shouldShuffle) {
      // Solo añadir sin mezclar
      return List<T>.from(list)..add(value);
    }
    // Añadir y mezclar
    final newList = List<T>.from(list)..add(value);
    newList.shuffle();
    return newList;
  }

  static List<QzImport> parseQuizJson(String jsonString) {
    try {
      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList.map((item) {
        final map = item as Map<String, dynamic>;

        return QzImport(
          question: (map['question'] as String).trim(),
          answer: (map['answer'] as String).trim(),
          fake: (map['fake'] as List<dynamic>)
              .map((e) => e.toString().trim())
              .toList(),
        );
      }).toList();
    } on FormatException catch (e) {
      throw FormatException('Error en el formato JSON: $e');
    } on TypeError {
      throw TypeError();
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

// Clase auxiliar para manejar los matches
class _TexMatch {
  final int start;
  final int end;
  final String content;
  final String type;

  _TexMatch(this.start, this.end, this.content, this.type);
}
