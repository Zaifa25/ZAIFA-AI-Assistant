import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'webhook_config.dart';

void main() {
  runApp(const ZaifaApp());
}

class ZaifaApp extends StatelessWidget {
  const ZaifaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ZAIFA",
      theme: ThemeData.dark(),
      home: const ZaifaScreen(),
    );
  }
}

class ZaifaScreen extends StatefulWidget {
  const ZaifaScreen({super.key});

  @override
  State<ZaifaScreen> createState() => _ZaifaScreenState();
}

class _ZaifaScreenState extends State<ZaifaScreen> {
  /// SPEECH
  final SpeechToText _speech = SpeechToText();

  bool _isListening = false;
  bool _speechReady = false;

  /// TEXT
  final TextEditingController _controller = TextEditingController();

  String _output = "Speak or Type Command";

  bool _loading = false;

  String _error = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  /// INIT SPEECH
  Future initSpeech() async {
    _speechReady = await _speech.initialize();

    setState(() {});
  }

  /// START MIC
  void startListening() async {
    if (!_speechReady) {
      setState(() {
        _error = "Speech not ready";
      });

      return;
    }

    setState(() {
      _isListening = true;

      _error = "";

      _output = "Listening...";
    });

    await _speech.listen(
      onResult: onSpeechResult,
      partialResults: true,
    );
  }

  /// STOP MIC
  void stopListening() async {
    await _speech.stop();

    setState(() {
      _isListening = false;
    });
  }

  /// RESULT
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _output = result.recognizedWords;
    });

    if (result.finalResult) {
      sendCommand(result.recognizedWords);
    }
  }

  /// SEND TEXT
  void sendText() {
    String text = _controller.text.trim();

    if (text.isEmpty) return;

    _output = text;

    sendCommand(text);

    _controller.clear();
  }

  /// SEND TO N8N
  Future sendCommand(String command) async {
    setState(() {
      _loading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(webhookUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"command": command}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _output = "Sent Successfully";
        });
      } else {
        setState(() {
          _error = "Webhook Error";
        });
      }
    } catch (e) {
      setState(() {
        _error = "Connection Failed";
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Text(
                "ZAIFA",
                style: GoogleFonts.inter(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text("Voice Assistant"),

              const SizedBox(height: 40),

              /// OUTPUT

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      _output,
                      textAlign: TextAlign.center,
                    ),
                    if (_loading)
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(),
                      ),
                    if (_error.isNotEmpty)
                      Text(
                        _error,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// TEXT BOX

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Type command",
                      ),
                      onSubmitted: (v) {
                        sendText();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendText,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// MIC

              GestureDetector(
                onTap: () {
                  if (_isListening)
                    stopListening();
                  else
                    startListening();
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: _isListening ? Colors.blue : Colors.grey,
                  child: const Icon(
                    Icons.mic,
                    size: 40,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                _isListening ? "Listening..." : "Tap Mic",
              ),

              const SizedBox(height: 20),

              /// TEST BUTTON

              ElevatedButton(
                onPressed: () {
                  sendCommand("test");
                },
                child: const Text("Test Webhook"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
