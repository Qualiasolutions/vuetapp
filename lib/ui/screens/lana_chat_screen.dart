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
  late AnimationController _typingAnimationController;
  late Animation<double> _welcomeAnimation;
  late Animation<Offset> _fabSlideAnimation;
  late Animation<double> _typingAnimation;
  
  bool _showWelcome = true;
  bool _showScrollToBottom = false;
  
  // Enhanced TTS features
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  
  // Enhanced STT features
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';
  double _soundLevel = 0.0;

  @override
  void initState() {
    super.initState();
    
    _welcomeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
    
    _welcomeAnimation = CurvedAnimation(
      parent: _welcomeAnimationController,
      curve: Curves.elasticOut,
    );
    
    _fabSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
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
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _speak(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
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
          _recognizedText = '';
        });
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _recognizedText = result.recognizedWords;
            });
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          onSoundLevelChange: (level) {
            setState(() {
              _soundLevel = level;
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
    final isLoading = ref.watch(isChatLoadingProvider);
    final isTyping = ref.watch(isChatTypingProvider);
    final error = ref.watch(chatErrorProvider);
    final quickSuggestions = ref.watch(quickSuggestionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            snap: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: null,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _buildEnhancedLanaAvatar(theme, size: 48),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'LANA AI',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: Text(
                                  isTyping ? 'Thinking...' : 
                                  (_isSpeaking ? 'Speaking...' : 
                                  (_isListening ? 'Listening...' : 'Your AI Assistant')),
                                  key: ValueKey(isTyping ? 'typing' : 
                                      (_isSpeaking ? 'speaking' : 
                                      (_isListening ? 'listening' : 'idle'))),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildActionButtons(theme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          if (_showWelcome)
                            AnimatedBuilder(
                              animation: _welcomeAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _welcomeAnimation.value,
                                  child: Opacity(
                                    opacity: _welcomeAnimation.value,
                                    child: _buildEnhancedWelcomeScreen(theme),
                                  ),
                                );
                              },
                            ),
                          
                          if (!_showWelcome)
                            _buildEnhancedChatList(messages, isTyping, theme),
                            
                          if (_isListening)
                            _buildListeningIndicator(theme),
                        ],
                      ),
                    ),
                    
                    if (error != null)
                      _buildErrorBanner(error, theme),
                    
                    _buildEnhancedInputArea(isLoading, quickSuggestions, theme),
                  ],
                ),
                
                if (_showScrollToBottom)
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
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedLanaAvatar(ThemeData theme, {double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
            theme.colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.psychology,
              color: Colors.white,
              size: size * 0.6,
            ),
          ),
          if (_isSpeaking)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _typingAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: _typingAnimation.value * 0.5),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
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
          style: IconButton.styleFrom(
            backgroundColor: _isListening 
                ? theme.colorScheme.primary.withOpacity(0.1)
                : null,
          ),
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
    );
  }

  Widget _buildEnhancedWelcomeScreen(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEnhancedLanaAvatar(theme, size: 120),
            const SizedBox(height: 32),
            Text(
              'Hello! I\'m LANA',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your intelligent AI assistant for task management and productivity',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            _buildWelcomeFeatures(theme),
            const SizedBox(height: 32),
            _buildQuickActions(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeFeatures(ThemeData theme) {
    final features = [
      {
        'icon': Icons.task_alt,
        'title': 'Smart Task Creation',
        'subtitle': 'Create tasks with natural language',
      },
      {
        'icon': Icons.chat_bubble_outline,
        'title': 'Intelligent Chat',
        'subtitle': 'Get help with your productivity',
      },
      {
        'icon': Icons.mic,
        'title': 'Voice Commands',
        'subtitle': 'Speak naturally to interact',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      feature['subtitle'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    final actions = [
      'Create a shopping list',
      'Set up a morning routine',
      'Plan my week',
      'Show my tasks',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Try saying:',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: actions.map((action) {
            return InkWell(
              onTap: () => _handleSendMessage(action),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  action,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEnhancedChatList(List<ChatMessage> messages, bool isTyping, ThemeData theme) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
                 if (index < messages.length) {
           final message = messages[index];
           final isUser = message.sender == MessageSender.user;
           return Padding(
             padding: const EdgeInsets.only(bottom: 16),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 if (!isUser) ...[
                   _buildEnhancedLanaAvatar(theme, size: 32),
                   const SizedBox(width: 12),
                 ],
                 Expanded(
                   child: ChatMessageBubble(
                     message: message,
                     onSpeakPressed: isUser ? null : () => _speak(message.content),
                     isSpeaking: _isSpeaking,
                   ),
                 ),
                 if (isUser) ...[
                   const SizedBox(width: 12),
                   CircleAvatar(
                     radius: 16,
                     backgroundColor: theme.colorScheme.primary,
                     child: const Icon(
                       Icons.person,
                       color: Colors.white,
                       size: 18,
                     ),
                   ),
                 ],
               ],
             ),
           );
        } else {
          return _buildTypingIndicator(theme);
        }
      },
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEnhancedLanaAvatar(theme, size: 32),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _typingAnimation,
                  builder: (context, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          margin: const EdgeInsets.only(right: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(
                              0.3 + ((_typingAnimation.value + index * 0.3) % 1.0) * 0.7,
                            ),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  'Thinking...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListeningIndicator(ThemeData theme) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _typingAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_typingAnimation.value * 0.3),
                    child: Icon(
                      Icons.mic,
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  _recognizedText.isEmpty ? 'Listening...' : _recognizedText,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String error, ThemeData theme) {
    return Container(
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
    );
  }

  Widget _buildEnhancedInputArea(bool isLoading, List<String> quickSuggestions, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ChatInputWidget(
        onSendMessage: _handleSendMessage,
        isLoading: isLoading,
        quickSuggestions: _showWelcome ? quickSuggestions : [],
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear this conversation?'),
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
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to use LANA'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('LANA can help you with:'),
              SizedBox(height: 8),
              Text('• Creating and managing tasks'),
              Text('• Setting up routines and schedules'),
              Text('• Managing lists and categories'),
              Text('• Answering questions about productivity'),
              SizedBox(height: 16),
              Text('Tips:'),
              SizedBox(height: 8),
              Text('• Use voice input for hands-free interaction'),
              Text('• Be specific in your requests'),
              Text('• Ask follow-up questions for clarification'),
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chat Settings'),
        content: const Text('Chat settings will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
