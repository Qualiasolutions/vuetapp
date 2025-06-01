import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class ChatInputWidget extends ConsumerStatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;
  final List<String> quickSuggestions;
  final Function? onVoiceInputPressed;
  final bool isListening;

  const ChatInputWidget({
    super.key,
    required this.onSendMessage,
    this.isLoading = false,
    this.quickSuggestions = const [],
    this.onVoiceInputPressed,
    this.isListening = false,
  });

  @override
  ConsumerState<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends ConsumerState<ChatInputWidget>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  late AnimationController _suggestionsController;
  late Animation<double> _suggestionsAnimation;
  
  // Voice functionality
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _speechEnabled = false;
  late AnimationController _voiceAnimationController;

  @override
  void initState() {
    super.initState();
    _suggestionsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _suggestionsAnimation = CurvedAnimation(
      parent: _suggestionsController,
      curve: Curves.easeInOut,
    );
    
    _voiceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _voiceAnimationController.repeat(reverse: true);
    
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
    _initSpeech();
    _initTts();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _suggestionsController.dispose();
    _voiceAnimationController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    _speech = stt.SpeechToText();
    _speechEnabled = await _speech.initialize();
    setState(() {});
  }

  void _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _controller.text.isEmpty) {
      _showSuggestions = true;
      _suggestionsController.forward();
    } else if (!_focusNode.hasFocus) {
      _showSuggestions = false;
      _suggestionsController.reverse();
    }
    setState(() {});
  }

  void _onTextChange() {
    if (_controller.text.isEmpty && _focusNode.hasFocus) {
      if (!_showSuggestions) {
        _showSuggestions = true;
        _suggestionsController.forward();
      }
    } else if (_controller.text.isNotEmpty && _showSuggestions) {
      _showSuggestions = false;
      _suggestionsController.reverse();
    }
    setState(() {});
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isLoading) {
      widget.onSendMessage(text);
      _controller.clear();
      _focusNode.unfocus();
    }
  }

  void _useSuggestion(String suggestion) {
    _controller.text = suggestion;
    _focusNode.unfocus();
    _sendMessage();
  }
  
  void _handleVoiceInput() {
    if (widget.onVoiceInputPressed != null) {
      widget.onVoiceInputPressed!();
    } else {
      // Fallback if no handler provided
      if (_isListening) {
        _speech.stop();
        setState(() {
          _isListening = false;
        });
      } else {
        if (_speechEnabled) {
          setState(() {
            _isListening = true;
          });
          _speech.listen(
            onResult: (result) {
              setState(() {
                _controller.text = result.recognizedWords;
              });
            },
            listenFor: const Duration(seconds: 30),
            pauseFor: const Duration(seconds: 5),
            listenOptions: stt.SpeechListenOptions(
              partialResults: true,
              cancelOnError: true,
            ),
            onSoundLevelChange: (level) {
              // Could use this for visual feedback
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isListening = widget.isListening || _isListening;
    
    return Column(
      children: [
        // Quick suggestions
        if (widget.quickSuggestions.isNotEmpty)
          AnimatedBuilder(
            animation: _suggestionsAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _suggestionsAnimation,
                child: Container(
                  height: 60.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.quickSuggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = widget.quickSuggestions[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ActionChip(
                          label: Text(suggestion),
                          onPressed: () => _useSuggestion(suggestion),
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 14.0,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        
        // Input field
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((255 * 0.1).round()),
                blurRadius: 4.0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Voice input button
                AnimatedBuilder(
                  animation: _voiceAnimationController,
                  builder: (context, child) {
                    final scale = isListening 
                        ? 0.8 + (_voiceAnimationController.value * 0.4) 
                        : 1.0;
                    
                    return Transform.scale(
                      scale: scale,
                      child: IconButton(
                        onPressed: _handleVoiceInput,
                        icon: Icon(
                          isListening 
                              ? Icons.mic 
                              : Icons.mic_none_outlined,
                          color: isListening 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        tooltip: isListening ? 'Stop listening' : 'Voice input',
                      ),
                    );
                  },
                ),
                
                // Text input field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: isListening
                            ? 'Listening...'
                            : 'Message LANA...',
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant.withAlpha((255 * 0.6).round()),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                        enabled: !isListening,
                      ),
                      minLines: 1,
                      maxLines: 5,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                
                // Send button or loading indicator
                const SizedBox(width: 8.0),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: widget.isLoading
                      ? SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: _controller.text.trim().isNotEmpty
                              ? _sendMessage
                              : null,
                          icon: Icon(
                            Icons.send_rounded,
                            color: _controller.text.trim().isNotEmpty
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant.withAlpha((255 * 0.4).round()),
                          ),
                          tooltip: 'Send message',
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Quick action buttons widget
class QuickActionButtons extends StatelessWidget {
  final Function(String) onActionSelected;

  const QuickActionButtons({
    super.key,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final actions = [
      QuickAction(
        icon: Icons.add_task,
        label: 'New Task',
        prompt: 'Create a new task',
      ),
      QuickAction(
        icon: Icons.event,
        label: 'Schedule',
        prompt: 'Schedule an event',
      ),
      QuickAction(
        icon: Icons.list_alt,
        label: 'List',
        prompt: 'Add to my list',
      ),
      QuickAction(
        icon: Icons.help_outline,
        label: 'Help',
        prompt: 'What can you help me with?',
      ),
    ];
    
    return Container(
      height: 80.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions.map((action) {
          return GestureDetector(
            onTap: () => onActionSelected(action.prompt),
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    action.icon,
                    color: theme.colorScheme.primary,
                    size: 24.0,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    action.label,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class QuickAction {
  final IconData icon;
  final String label;
  final String prompt;

  const QuickAction({
    required this.icon,
    required this.label,
    required this.prompt,
  });
}
