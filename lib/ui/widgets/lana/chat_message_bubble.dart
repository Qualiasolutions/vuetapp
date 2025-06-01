import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../models/lana/chat_message_model.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;
  final bool showTime;
  final Function? onSpeakPressed;
  final bool isSpeaking;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.showAvatar = true,
    this.showTime = true,
    this.onSpeakPressed,
    this.isSpeaking = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser && showAvatar) ...[
            _buildAvatar(context, isUser),
            const SizedBox(width: 8.0),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: isUser 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18.0),
                  topRight: const Radius.circular(18.0),
                  bottomLeft: Radius.circular(isUser ? 18.0 : 4.0),
                  bottomRight: Radius.circular(isUser ? 4.0 : 18.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((255 * 0.1).round()),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isUser 
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      fontSize: 16.0,
                      height: 1.4,
                    ),
                  ),
                  if (showTime) ...[
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(message.timestamp),
                          style: TextStyle(
                            color: (isUser 
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant)
                                .withAlpha((255 * 0.7).round()),
                            fontSize: 12.0,
                          ),
                        ),
                        if (!isUser) ...[
                          const SizedBox(width: 8.0),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Copy button
                              GestureDetector(
                                onTap: () => _copyToClipboard(context, message.content),
                                child: Icon(
                                  Icons.copy,
                                  size: 14.0,
                                  color: theme.colorScheme.onSurfaceVariant.withAlpha((255 * 0.7).round()),
                                ),
                              ),
                              // Speak button (only for assistant messages)
                              if (onSpeakPressed != null) ...[
                                const SizedBox(width: 12.0),
                                GestureDetector(
                                  onTap: () => onSpeakPressed!(),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(
                                      isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                                      key: ValueKey(isSpeaking),
                                      size: 16.0,
                                      color: isSpeaking
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurfaceVariant.withAlpha((255 * 0.7).round()),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser && showAvatar) ...[
            const SizedBox(width: 8.0),
            _buildAvatar(context, isUser),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, bool isUser) {
    final theme = Theme.of(context);
    
    return Container(
      width: 32.0,
      height: 32.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUser 
            ? theme.colorScheme.primary.withAlpha((255 * 0.1).round())
            : theme.colorScheme.secondary.withAlpha((255 * 0.1).round()),
      ),
      child: Icon(
        isUser ? Icons.person : Icons.assistant,
        size: 18.0,
        color: isUser 
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary,
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.secondary.withAlpha((255 * 0.1).round()),
            ),
            child: Icon(
              Icons.assistant,
              size: 18.0,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
                bottomLeft: Radius.circular(4.0),
                bottomRight: Radius.circular(18.0),
              ),
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDot(0),
                    const SizedBox(width: 4.0),
                    _buildDot(1),
                    const SizedBox(width: 4.0),
                    _buildDot(2),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final delay = index * 0.2;
    final animationValue = (_animation.value - delay).clamp(0.0, 1.0);
    final opacity = (animationValue * 2).clamp(0.0, 1.0);
    
    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha((opacity * 255).round()),
      ),
    );
  }
}
