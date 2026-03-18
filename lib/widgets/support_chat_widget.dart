import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/openai/openai_config.dart';

/// Chat mode - either Leo AI or PayRoute Support
enum ChatMode { leo, support }

/// Model for chat messages
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
  });

  ChatMessage copyWith({String? text, bool? isLoading}) => ChatMessage(
    id: id,
    text: text ?? this.text,
    isUser: isUser,
    timestamp: timestamp,
    isLoading: isLoading ?? this.isLoading,
  );
}

/// Support chat floating widget with expandable chat panel
/// Now with AI integration via Digital Ocean Gradient
class SupportChatWidget extends StatefulWidget {
  const SupportChatWidget({super.key});

  @override
  State<SupportChatWidget> createState() => _SupportChatWidgetState();
}

class _SupportChatWidgetState extends State<SupportChatWidget>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  ChatMode _chatMode = ChatMode.leo;
  bool _showModeSelector = true;
  bool _isTyping = false;
  
  final List<ChatMessage> _leoMessages = [];
  final List<ChatMessage> _supportMessages = [];
  
  List<ChatMessage> get _currentMessages => 
      _chatMode == ChatMode.leo ? _leoMessages : _supportMessages;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );
    
    // Add initial welcome messages
    _leoMessages.add(ChatMessage(
      id: 'leo_welcome',
      text: 'Hey there! 👋 I\'m Leo, your AI-powered financial assistant. I can help you with transfers, exchange rates, account questions, and more. What can I help you with today?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ));
    
    _supportMessages.add(ChatMessage(
      id: 'support_welcome',
      text: 'Hello! 👋 Welcome to PayRoute Support. Our team is here to help you with any questions or issues. How can we assist you today?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ));
  }

  @override
  void dispose() {
    _animController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animController.forward();
        _showModeSelector = _currentMessages.length <= 1;
      } else {
        _animController.reverse();
      }
    });
  }
  
  void _selectMode(ChatMode mode) {
    setState(() {
      _chatMode = mode;
      _showModeSelector = false;
    });
    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isTyping) return;
    
    _showModeSelector = false;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    setState(() {
      _currentMessages.add(userMessage);
      _messageController.clear();
    });

    _scrollToBottom();

    if (_chatMode == ChatMode.leo) {
      await _getAIResponse(text);
    } else {
      await _getSupportResponse(text);
    }
  }
  
  Future<void> _getAIResponse(String userMessage) async {
    // Add loading message
    final loadingId = 'loading_${DateTime.now().millisecondsSinceEpoch}';
    final loadingMessage = ChatMessage(
      id: loadingId,
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );
    
    setState(() {
      _isTyping = true;
      _leoMessages.add(loadingMessage);
    });
    _scrollToBottom();

    try {
      final chatHistory = _leoMessages
          .where((m) => m.id != loadingId && !m.isLoading && m.id != 'leo_welcome')
          .map((m) => {
                'role': m.isUser ? 'user' : 'assistant',
                'content': m.text,
              })
          .toList();

      final aiResponse = await OpenAiConfig.getChatResponse(
        systemPrompt: 'You are Leo, a friendly and professional AI assistant for PayRoute, an African fintech platform that handles cross-border payments, currency exchange, and financial services across Africa. Be helpful, concise, and knowledgeable about payments, transfers, exchange rates, and African financial markets.',
        chatHistory: chatHistory,
      );

      if (mounted) {
        setState(() {
          _isTyping = false;
          final idx = _leoMessages.indexWhere((m) => m.id == loadingId);
          if (idx != -1) {
            _leoMessages[idx] = ChatMessage(
              id: loadingId,
              text: aiResponse,
              isUser: false,
              timestamp: DateTime.now(),
            );
          }
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('AI API exception: $e');
      if (mounted) {
        setState(() {
          _isTyping = false;
          final idx = _leoMessages.indexWhere((m) => m.id == loadingId);
          if (idx != -1) {
            _leoMessages[idx] = ChatMessage(
              id: loadingId,
              text: 'Could not reach DigitalOcean AI.\nError: $e\n\nFallback: ${_getLocalAIResponse(userMessage)}',
              isUser: false,
              timestamp: DateTime.now(),
            );
          }
        });
        _scrollToBottom();
      }
    }
  }

  String _getLocalAIResponse(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('transfer') || lower.contains('send money')) {
      return 'Great question! PayRoute offers instant transfers across 54 African countries with competitive rates. You can use Smart Send from your dashboard to initiate a transfer. Would you like me to guide you through the process?';
    } else if (lower.contains('rate') || lower.contains('exchange')) {
      return 'Our exchange rates are updated in real-time and aggregated across 54 markets to find you the best deal. You can check current rates in the Exchange section. We typically save our customers up to 68% compared to traditional banks!';
    } else if (lower.contains('card') || lower.contains('freeze')) {
      return 'You can manage your PayRoute cards from the Cards section. There you can freeze/unfreeze cards instantly, set spending limits, and view transactions. Need help with anything specific?';
    } else if (lower.contains('fee') || lower.contains('cost') || lower.contains('charge')) {
      return 'PayRoute is designed to save you money! Our fees are transparent and typically 68% lower than traditional methods. For most transfers, you\'ll see the exact fee upfront before confirming.';
    } else if (lower.contains('account') || lower.contains('verify')) {
      return 'Account management is easy with PayRoute. Go to Settings to update your profile, verify your identity, or manage security settings. Full verification unlocks higher transfer limits!';
    } else if (lower.contains('hello') || lower.contains('hi') || lower.contains('hey')) {
      return 'Hello! 👋 Great to chat with you! I\'m Leo, your PayRoute assistant. I can help with transfers, exchange rates, cards, and more. What would you like to know?';
    } else if (lower.contains('thank')) {
      return 'You\'re welcome! 😊 I\'m always here to help. Is there anything else you\'d like to know about PayRoute?';
    }
    return 'Thanks for your question! I\'m here to help with transfers, exchange rates, cards, and account management. Could you tell me more about what you need assistance with?';
  }
  
  Future<void> _getSupportResponse(String userMessage) async {
    // Simulate typing delay for support
    setState(() => _isTyping = true);
    
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;
    
    String response;
    final lower = userMessage.toLowerCase();
    
    if (lower.contains('urgent') || lower.contains('emergency')) {
      response = '🚨 I understand this is urgent. I\'m escalating your request to a senior support agent who will respond within the next few minutes. In the meantime, can you provide your account email or phone number?';
    } else if (lower.contains('complaint') || lower.contains('problem') || lower.contains('issue')) {
      response = 'I\'m sorry to hear you\'re experiencing difficulties. Your satisfaction is our priority. Could you please describe the issue in detail so I can help resolve it as quickly as possible?';
    } else if (lower.contains('refund') || lower.contains('money back')) {
      response = 'I understand you\'re inquiring about a refund. Our refund policy covers failed transactions and service issues. Please provide your transaction ID and I\'ll look into this for you right away.';
    } else if (lower.contains('speak') || lower.contains('human') || lower.contains('agent')) {
      response = 'Absolutely! I\'m connecting you with a human support agent. Please hold on for a moment. Average wait time is under 2 minutes. 📞';
    } else {
      response = 'Thank you for reaching out to PayRoute Support! A member of our team will review your message and respond shortly. Our average response time is under 5 minutes during business hours.';
    }
    
    setState(() {
      _isTyping = false;
      _supportMessages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Chat Panel
        ScaleTransition(
          scale: _scaleAnimation,
          alignment: Alignment.bottomRight,
          child: _ChatPanel(
            messages: _currentMessages,
            messageController: _messageController,
            scrollController: _scrollController,
            focusNode: _focusNode,
            onSend: _sendMessage,
            onClose: _toggleChat,
            chatMode: _chatMode,
            onModeSelected: _selectMode,
            showModeSelector: _showModeSelector,
            isTyping: _isTyping,
          ),
        ),
        const SizedBox(height: 12),
        // Floating Action Button
        _ChatFab(
          isOpen: _isOpen,
          onTap: _toggleChat,
          hasUnread: !_isOpen && _currentMessages.isNotEmpty,
        ),
      ],
    );
  }
}

class _ChatPanel extends StatelessWidget {
  final List<ChatMessage> messages;
  final TextEditingController messageController;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onClose;
  final ChatMode chatMode;
  final Function(ChatMode) onModeSelected;
  final bool showModeSelector;
  final bool isTyping;

  const _ChatPanel({
    required this.messages,
    required this.messageController,
    required this.scrollController,
    required this.focusNode,
    required this.onSend,
    required this.onClose,
    required this.chatMode,
    required this.onModeSelected,
    required this.showModeSelector,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final screenHeight = MediaQuery.of(context).size.height;
    final panelHeight = (screenHeight * 0.6).clamp(400.0, 550.0);

    return Container(
      width: 380,
      height: panelHeight,
      decoration: BoxDecoration(
        color: DashboardPalette.surface(b),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DashboardPalette.border(b)),
        boxShadow: [
          BoxShadow(
            color: b == Brightness.dark
                ? Colors.black.withValues(alpha: 0.6)
                : Colors.black.withValues(alpha: 0.2),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          _ChatHeader(
            onClose: onClose,
            chatMode: chatMode,
          ),
          if (showModeSelector) _ModeSelectorCard(onModeSelected: onModeSelected),
          Expanded(
            child: _MessageList(
              messages: messages,
              scrollController: scrollController,
              chatMode: chatMode,
              isTyping: isTyping,
            ),
          ),
          _MessageInput(
            controller: messageController,
            focusNode: focusNode,
            onSend: onSend,
            isTyping: isTyping,
            chatMode: chatMode,
          ),
        ],
      ),
    );
  }
}

class _ModeSelectorCard extends StatelessWidget {
  final Function(ChatMode) onModeSelected;

  const _ModeSelectorCard({required this.onModeSelected});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PayRouteColors.vibrantOrange.withValues(alpha: 0.08),
            PayRouteColors.dashboardPrimary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PayRouteColors.vibrantOrange.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How would you like to get help?',
            style: GoogleFonts.inter(
              color: DashboardPalette.textPrimary(b),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ModeOption(
                  icon: Icons.auto_awesome,
                  label: 'Chat with Leo',
                  subtitle: 'AI Assistant',
                  color: PayRouteColors.vibrantOrange,
                  onTap: () => onModeSelected(ChatMode.leo),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ModeOption(
                  icon: Icons.support_agent,
                  label: 'PayRoute Support',
                  subtitle: 'Human Help',
                  color: PayRouteColors.dashboardPrimary,
                  onTap: () => onModeSelected(ChatMode.support),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ModeOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: b == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: DashboardPalette.textPrimary(b),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: DashboardPalette.textSecondary(b),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final VoidCallback onClose;
  final ChatMode chatMode;

  const _ChatHeader({
    required this.onClose,
    required this.chatMode,
  });

  @override
  Widget build(BuildContext context) {
    final isLeo = chatMode == ChatMode.leo;
    final color = isLeo ? PayRouteColors.vibrantOrange : PayRouteColors.dashboardPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isLeo ? Icons.auto_awesome : Icons.support_agent,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLeo ? 'Leo' : 'PayRoute Support',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: PayRouteColors.dashboardGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: PayRouteColors.dashboardGreen.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isLeo ? 'AI-Powered • Always Ready' : 'Online • Ready to Help',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.close,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final ChatMode chatMode;
  final bool isTyping;

  const _MessageList({
    required this.messages,
    required this.scrollController,
    required this.chatMode,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _MessageBubble(message: message, chatMode: chatMode);
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final ChatMode chatMode;

  const _MessageBubble({required this.message, required this.chatMode});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final isUser = message.isUser;
    final isLeo = chatMode == ChatMode.leo;
    final accentColor = isLeo ? PayRouteColors.vibrantOrange : PayRouteColors.dashboardPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withValues(alpha: 0.2),
                    accentColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isLeo ? Icons.auto_awesome : Icons.support_agent,
                color: accentColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? (isLeo ? PayRouteColors.vibrantOrange : PayRouteColors.dashboardPrimary)
                    : b == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: isUser
                    ? [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: message.isLoading
                  ? _TypingIndicator()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: GoogleFonts.inter(
                            color: isUser
                                ? Colors.white
                                : DashboardPalette.textPrimary(b),
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(message.timestamp),
                          style: GoogleFonts.inter(
                            color: isUser
                                ? Colors.white.withValues(alpha: 0.7)
                                : DashboardPalette.textSecondary(b),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withValues(alpha: 0.2),
                    accentColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'U',
                  style: GoogleFonts.inter(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = ((_controller.value + delay) % 1.0);
            final scale = 0.5 + (value < 0.5 ? value : 1 - value) * 1.0;
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: DashboardPalette.textSecondary(Theme.of(context).brightness),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool isTyping;
  final ChatMode chatMode;

  const _MessageInput({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.isTyping,
    required this.chatMode,
  });

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final isLeo = chatMode == ChatMode.leo;
    final accentColor = isLeo ? PayRouteColors.vibrantOrange : PayRouteColors.dashboardPrimary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: DashboardPalette.border(b)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: b == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.grey.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: DashboardPalette.border(b),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.attach_file,
                      color: DashboardPalette.iconMuted(b),
                      size: 20,
                    ),
                    splashRadius: 20,
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: GoogleFonts.inter(
                        color: DashboardPalette.textPrimary(b),
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: isLeo ? 'Ask Leo anything...' : 'Type a message...',
                        hintStyle: GoogleFonts.inter(
                          color: DashboardPalette.textSecondary(b),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: isTyping ? accentColor.withValues(alpha: 0.5) : accentColor,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: isTyping ? null : onSend,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 44,
                height: 44,
                child: isTyping
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
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
}

class _ChatFab extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;
  final bool hasUnread;

  const _ChatFab({
    required this.isOpen,
    required this.onTap,
    this.hasUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              PayRouteColors.vibrantOrange,
              PayRouteColors.vibrantOrange.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: PayRouteColors.vibrantOrange.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: PayRouteColors.vibrantOrange.withValues(alpha: 0.2),
              blurRadius: 40,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedRotation(
              duration: const Duration(milliseconds: 220),
              turns: isOpen ? 0.25 : 0,
              child: Icon(
                isOpen ? Icons.close : Icons.auto_awesome,
                color: Colors.white,
                size: 26,
              ),
            ),
            if (hasUnread && !isOpen)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: PayRouteColors.dashboardGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: PayRouteColors.vibrantOrange,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: PayRouteColors.dashboardGreen.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
