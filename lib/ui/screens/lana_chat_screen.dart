import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../providers/lana_chat_providers.dart';
import '../../models/lana/chat_message_model.dart';
import '../../theme/app_colors.dart';

class LanaChatScreen extends ConsumerStatefulWidget {
  const LanaChatScreen({super.key});

  @override
  ConsumerState<LanaChatScreen> createState() => _LanaChatScreenState();
}

class _LanaChatScreenState extends ConsumerState<LanaChatScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _welcomeAnimationController;
  late AnimationController _fabController;
  late AnimationController _typingAnimationController;
  late Animation<double> _welcomeAnimation;
  late Animation<Offset> _fabSlideAnimation;
  late Animation<double> _typingAnimation;

  bool _showWelcome = true;
  bool _showScrollToBottom = false;

  // TTS features
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  // STT features
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();

    _welcomeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _welcomeAnimation = CurvedAnimation(
      parent: _welcomeAnimationController,
      curve: Curves.easeOutBack,
    );

    _fabSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeOut,
    ));

    _typingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _typingAnimationController,
      curve: Curves.easeInOut,
    ));

    _scrollController.addListener(_onScroll);

    // Start welcome animation
    _welcomeAnimationController.forward();

    // Auto-hide welcome after timeout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted && _showWelcome) {
          _hideWelcome();
        }
      });
    });

    _initTts();
    _initSpeech();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(0.8);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
  }

  Future<void> _initSpeech() async {
    await _speechToText.initialize(
      onError: (error) {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
        }
      },
      onStatus: (status) {
        if (status == 'done' && mounted) {
          setState(() {
            _isListening = false;
          });
          if (_recognizedText.isNotEmpty) {
            _handleSendMessage(_recognizedText);
            _recognizedText = '';
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _welcomeAnimationController.dispose();
    _fabController.dispose();
    _typingAnimationController.dispose();
    _flutterTts.stop();
    _speechToText.cancel();
    super.dispose();
  }

  void _onScroll() {
    final showButton =
        _scrollController.hasClients && _scrollController.offset > 200;

    if (showButton != _showScrollToBottom) {
      setState(() => _showScrollToBottom = showButton);
      if (showButton) {
        _fabController.forward();
      } else {
        _fabController.reverse();
      }
    }
  }

  void _hideWelcome() {
    if (mounted) {
      setState(() => _showWelcome = false);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage(String message) {
    _hideWelcome();
    ref.read(chatProvider.notifier).sendMessage(message);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _speak(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
      return;
    }

    setState(() {
      _isSpeaking = true;
    });

    await _flutterTts.speak(text);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _recognizedText = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speechToText.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final isTyping = ref.watch(isChatTypingProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.mediumTurquoise,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: const Icon(
                Icons.assistant,
                size: 20,
                color: AppColors.mediumTurquoise,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LANA AI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    isTyping
                        ? 'Thinking...'
                        : (_isSpeaking
                            ? 'Speaking...'
                            : (_isListening ? 'Listening...' : 'AI Assistant')),
                    key: ValueKey(isTyping
                        ? 'typing'
                        : (_isSpeaking
                            ? 'speaking'
                            : (_isListening ? 'listening' : 'idle'))),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isSpeaking ? Icons.volume_up : Icons.volume_off),
            tooltip: _isSpeaking ? 'Stop Speaking' : 'Text to Speech',
            onPressed: () {
              if (messages.isNotEmpty) {
                final lastMessage = messages.last;
                if (lastMessage.sender == MessageSender.assistant) {
                  _speak(lastMessage.content);
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear Chat',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Chat'),
                  content: const Text(
                      'Are you sure you want to clear all messages?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(chatProvider.notifier).startNewChat();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Chat messages
                  _showWelcome
                      ? _buildModernWelcomeScreen(theme)
                      : _buildChatMessages(messages, isTyping, theme),

                  // Scroll to bottom button
                  if (_showScrollToBottom && !_showWelcome)
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: SlideTransition(
                        position: _fabSlideAnimation,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: AppColors.mediumTurquoise,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          onPressed: _scrollToBottom,
                          child: const Icon(Icons.arrow_downward),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Chat input
            _buildModernChatInput(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessages(
      List<ChatMessage> messages, bool isTyping, ThemeData theme) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          // Typing indicator
          return _buildTypingIndicator(theme);
        }

        final message = messages[index];
        return _buildModernMessageBubble(message, theme);
      },
    );
  }

  Widget _buildModernMessageBubble(ChatMessage message, ThemeData theme) {
    final isFromUser = message.sender == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.mediumTurquoise.withValues(alpha: 0.1),
              child: const Icon(
                Icons.assistant,
                size: 18,
                color: AppColors.mediumTurquoise,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isFromUser ? AppColors.mediumTurquoise : theme.cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isFromUser
                      ? Colors.white
                      : theme.textTheme.bodyMedium?.color,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (isFromUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.mediumTurquoise,
              child: const Icon(
                Icons.person,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 40),
      child: Row(
        children: [
          FadeTransition(
            opacity: _typingAnimation,
            child: Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: AppColors.mediumTurquoise,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          FadeTransition(
            opacity: _typingAnimation,
            child: Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: AppColors.mediumTurquoise.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          FadeTransition(
            opacity: _typingAnimation,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.mediumTurquoise.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernChatInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? AppColors.mediumTurquoise : null,
            ),
            onPressed: _listen,
            tooltip: 'Voice Input',
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: _isListening ? 'Listening...' : 'Message LANA...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _handleSendMessage(value.trim());
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.mediumTurquoise,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                // Get the text from the TextField
                final textField = context.findRenderObject() as RenderBox?;
                if (textField != null) {
                  final textFieldFocus = FocusScope.of(context);
                  if (textFieldFocus.focusedChild != null) {
                    final controller =
                        (textFieldFocus.focusedChild as TextField).controller;
                    if (controller != null &&
                        controller.text.trim().isNotEmpty) {
                      _handleSendMessage(controller.text.trim());
                      controller.clear();
                    }
                  }
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernWelcomeScreen(ThemeData theme) {
    return ScaleTransition(
      scale: _welcomeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.mediumTurquoise.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assistant,
                size: 60,
                color: AppColors.mediumTurquoise,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Hello, I\'m LANA',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.mediumTurquoise,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your AI assistant for task management and productivity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 40),
            _buildWelcomeFeatures(theme),
            const SizedBox(height: 40),
            _buildGetStartedButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeFeatures(ThemeData theme) {
    final features = [
      {
        'icon': Icons.task_alt,
        'title': 'Task Creation',
        'description': 'Create tasks with natural language',
      },
      {
        'icon': Icons.chat_bubble_outline,
        'title': 'Smart Chat',
        'description': 'Get help with your productivity',
      },
      {
        'icon': Icons.mic,
        'title': 'Voice Commands',
        'description': 'Speak naturally to interact',
      },
    ];

    return Column(
      children:
          features.map((feature) => _buildFeatureItem(feature, theme)).toList(),
    );
  }

  Widget _buildFeatureItem(Map<String, dynamic> feature, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.mediumTurquoise.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: AppColors.mediumTurquoise,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature['description'] as String,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: _hideWelcome,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mediumTurquoise,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        'Start Chatting',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
