import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../widgets/lana/chat_message_bubble.dart';
import '../widgets/lana/chat_input_widget.dart';
import '../../providers/lana_chat_providers.dart';
import '../../models/lana/chat_message_model.dart';

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
  late Animation<double> _welcomeAnimation;
  late Animation<Offset> _fabSlideAnimation;
  bool _showWelcome = true;
  bool _showScrollToBottom = false;
  
  // Text-to-speech feature
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  
  // Speech-to-text feature
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
    
    _welcomeAnimation = CurvedAnimation(
      parent: _welcomeAnimationController,
      curve: Curves.elasticOut,
    );
    
    _fabSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeOut,
    ));
    
    _scrollController.addListener(_onScroll);
    
    // Start welcome animation
    _welcomeAnimationController.forward();
    
    // Hide welcome screen after first interaction
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _showWelcome) {
          _hideWelcome();
        }
      });
    });
    
    // Initialize text-to-speech
    _initTts();
    
    // Initialize speech-to-text
    _initSpeech();
  }

  // Initialize text-to-speech
  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }
  
  // Initialize speech-to-text
  Future<void> _initSpeech() async {
    await _speechToText.initialize();
  }
  
  // Speak text
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
  
  // Listen to user speech
  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _recognizedText = '';
        });
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _recognizedText = result.recognizedWords;
            });
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
          listenOptions: stt.SpeechListenOptions(
            partialResults: true,
            cancelOnError: true,
            listenMode: stt.ListenMode.confirmation,
          ),
          onSoundLevelChange: (level) {
            // Could be used for visual feedback
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speechToText.stop();
      
      // If we have recognized text, send it
      if (_recognizedText.isNotEmpty) {
        _handleSendMessage(_recognizedText);
        _recognizedText = '';
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _welcomeAnimationController.dispose();
    _fabController.dispose();
    _flutterTts.stop();
    _speechToText.cancel();
    super.dispose();
  }

  void _onScroll() {
    final showButton = _scrollController.hasClients &&
        _scrollController.offset > 200;
    
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
    
    // Auto-scroll to bottom when sending message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(isChatLoadingProvider);
    final isTyping = ref.watch(isChatTypingProvider);
    final error = ref.watch(chatErrorProvider);
    final quickSuggestions = ref.watch(quickSuggestionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            _buildLanaAvatar(theme, size: 36),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LANA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    isTyping ? 'Thinking...' : (_isSpeaking ? 'Speaking...' : 'Your AI Assistant'),
                    key: ValueKey(isTyping ? 'typing' : (_isSpeaking ? 'speaking' : 'idle')),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withAlpha((255 * 0.6).round()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Voice input button
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                key: ValueKey(_isListening),
                color: _isListening ? theme.colorScheme.primary : null,
              ),
            ),
            onPressed: _listen,
            tooltip: _isListening ? 'Stop listening' : 'Voice input',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(chatProvider.notifier).startNewChat();
              setState(() => _showWelcome = true);
              _welcomeAnimationController.reset();
              _welcomeAnimationController.forward();
            },
            tooltip: 'New Chat',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'clear':
                  _showClearDialog();
                  break;
                case 'help':
                  _showHelpDialog();
                  break;
                case 'settings':
                  _showSettingsDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Clear Chat'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline),
                    SizedBox(width: 8),
                    Text('Help'),
                  ],
                ),
              ),
            ],
          ),
        ],
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Main chat area
          Column(
            children: [
              // Messages list
              Expanded(
                child: Stack(
                  children: [
                    // Welcome screen
                    if (_showWelcome)
                      AnimatedBuilder(
                        animation: _welcomeAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _welcomeAnimation.value,
                            child: _buildWelcomeScreen(),
                          );
                        },
                      ),
                    
                    // Chat messages
                    if (!_showWelcome)
                      _buildChatList(messages, isTyping),
                      
                    // Voice input indicator
                    if (_isListening)
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha((255 * 0.1).round()),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildPulsingMic(),
                                const SizedBox(width: 8),
                                Text(
                                  _recognizedText.isEmpty ? 'Listening...' : _recognizedText,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Error display
              if (error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  color: theme.colorScheme.errorContainer,
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error,
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref.read(chatProvider.notifier).clearError(),
                        child: const Text('Dismiss'),
                      ),
                    ],
                  ),
                ),
              
              // Input area
              ChatInputWidget(
                onSendMessage: _handleSendMessage,
                isLoading: isLoading,
                quickSuggestions: _showWelcome ? quickSuggestions : [],
              ),
            ],
          ),
          
          // Scroll to bottom FAB
          Positioned(
            right: 16,
            bottom: 100,
            child: SlideTransition(
              position: _fabSlideAnimation,
              child: FloatingActionButton(
                onPressed: _scrollToBottom,
                mini: true,
                backgroundColor: theme.colorScheme.primary,
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingMic() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(
            Icons.mic,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
      onEnd: () {
        setState(() {
          // Rebuild to restart animation
        });
      },
    );
  }

  Widget _buildLanaAvatar(ThemeData theme, {double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha((255 * 0.3).round()),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        Icons.assistant,
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    final theme = Theme.of(context);
    
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLanaAvatar(theme, size: 80),
            const SizedBox(height: 24),
            Text(
              'Welcome to LANA!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your intelligent productivity assistant is here to help you organize your tasks, schedule events, and manage your workflow.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha((255 * 0.7).round()),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _listen,
              icon: const Icon(Icons.mic),
              label: const Text('Speak to LANA'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 32),
            QuickActionButtons(
              onActionSelected: _handleSendMessage,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((255 * 0.05).round()),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try saying:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"Create a task to review the quarterly report tomorrow"\n"What do I have scheduled for today?"\n"Add milk and bread to my shopping list"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(List<ChatMessage> messages, bool isTyping) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isTyping) {
          return const TypingIndicator();
        }
        
        final message = messages[index];
        final isFirstInGroup = index == 0 || 
            messages[index - 1].sender != message.sender;
        final isLastInGroup = index == messages.length - 1 || 
            messages[index + 1].sender != message.sender;
        
        return ChatMessageBubble(
          message: message,
          showAvatar: isFirstInGroup,
          showTime: isLastInGroup,
          onSpeakPressed: message.sender == MessageSender.assistant 
              ? () => _speak(message.content) 
              : null,
          isSpeaking: _isSpeaking && message.sender == MessageSender.assistant,
        );
      },
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear the entire conversation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(chatProvider.notifier).startNewChat();
              setState(() => _showWelcome = true);
              _welcomeAnimationController.reset();
              _welcomeAnimationController.forward();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    double speechRate = 0.5;
    double pitch = 1.0;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('LANA Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Text-to-Speech Settings', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('Speech Rate'),
                Slider(
                  value: speechRate,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  label: speechRate.toString(),
                  onChanged: (value) {
                    setState(() {
                      speechRate = value;
                    });
                  },
                ),
                const Text('Pitch'),
                Slider(
                  value: pitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: pitch.toString(),
                  onChanged: (value) {
                    setState(() {
                      pitch = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _flutterTts.setPitch(pitch);
                      await _flutterTts.setSpeechRate(speechRate);
                      await _flutterTts.speak('Hello, I am LANA, your AI assistant');
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Test Voice'),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await _flutterTts.setPitch(pitch);
                  await _flutterTts.setSpeechRate(speechRate);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            _buildLanaAvatar(Theme.of(context), size: 24),
            const SizedBox(width: 8),
            const Text('LANA Help'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LANA can help you with:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Creating and managing tasks'),
              Text('• Scheduling events and appointments'),
              Text('• Managing lists and reminders'),
              Text('• Organizing your daily workflow'),
              Text('• Answering questions about your data'),
              SizedBox(height: 16),
              Text(
                'Voice Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Tap the microphone icon to speak to LANA'),
              Text('• Tap the speaker icon on LANA\'s messages to hear them read aloud'),
              Text('• Adjust voice settings in the menu'),
              SizedBox(height: 16),
              Text(
                'Tips:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Use natural language - speak to LANA like you would a person'),
              Text('• Be specific with dates, times, and details'),
              Text('• Ask follow-up questions for clarification'),
              Text('• Use the quick suggestion chips for common actions'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class QuickActionButtons extends StatelessWidget {
  final Function(String) onActionSelected;

  const QuickActionButtons({
    super.key,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _buildActionChip(context, 'Create a task', Icons.task_alt),
        _buildActionChip(context, 'Schedule meeting', Icons.event),
        _buildActionChip(context, 'Add to shopping list', Icons.shopping_cart),
        _buildActionChip(context, 'Show my calendar', Icons.calendar_month),
      ],
    );
  }

  Widget _buildActionChip(BuildContext context, String label, IconData icon) {
    final theme = Theme.of(context);
    
    return ActionChip(
      avatar: Icon(
        icon,
        size: 18,
        color: theme.colorScheme.primary,
      ),
      label: Text(label),
      onPressed: () => onActionSelected(label),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withAlpha((255 * 0.3).round()),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
