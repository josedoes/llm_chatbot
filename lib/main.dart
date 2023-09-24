import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:llm_chat/model/llm_chat_message.dart';
import 'package:llm_chat/model/llm_style.dart';

List<LlmChatMessage> chats = [
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 3000,
    message: "Welcome to ChatGPT! How can I help you today?",
    type: "system",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 2000,
    message: "Hello! I have a question about Dart.",
    type: "user",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 1000,
    message: "Of course! Please go ahead and ask your question.",
    type: "assistant",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 2000,
    message: "Hello! I have a question about Dart.",
    type: "user",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 1000,
    message: "Of course! Please go ahead and ask your question.",
    type: "assistant",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 2000,
    message: "Hello! I have a question about Dart.",
    type: "user",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 1000,
    message: "Of course! Please go ahead and ask your question.",
    type: "assistant",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 2000,
    message: "Hello! I have a question about Dart.",
    type: "user",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 1000,
    message: "Of course! Please go ahead and ask your question.",
    type: "assistant",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 2000,
    message: "Hello! I have a question about Dart.",
    type: "user",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 1000,
    message: "Of course! Please go ahead and last",
    type: "assistant",
  ),
];

main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Example(),
    );
  }
}

final controller = TextEditingController();
final scrollController = ScrollController();

class _Example extends StatefulWidget {
  @override
  State<_Example> createState() => _ExampleState();
}

class _ExampleState extends State<_Example> {
  @override
  Widget build(BuildContext context) {
    final t = TextStyle(color: Colors.white);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: LLMChat(
              style: LlmMessageStyle(
                  userColor: Color(0xff9E9EA5),
                  assistantColor: Colors.greenAccent),
              showSystemMessage: true,
              scrollController: scrollController,
              awaitingResponse: true,
              messages: chats,
              controller: controller,
              onSubmit: (newMessage) {
                chats.add(LlmChatMessage.user(message: newMessage));
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }
}

class LLMChat extends StatefulWidget {
  const LLMChat({
    required this.messages,
    required this.awaitingResponse,
    required this.controller,
    required this.onSubmit,
    required this.scrollController,
    required this.showSystemMessage,
    this.style,
    this.messageBuilder,
    this.boxDecorationBasedOnMessage,
    this.messagePadding,
    this.chatPadding,
    this.loadingWidget,
    super.key,
  });

  final bool showSystemMessage;

  final EdgeInsetsGeometry? messagePadding;
  final EdgeInsetsGeometry? chatPadding;

  final BoxDecoration Function(LlmChatMessage)? boxDecorationBasedOnMessage;
  final LlmMessageStyle? style;

  final List<LlmChatMessage> messages;
  final bool awaitingResponse;
  final Widget Function(LlmChatMessage message)? messageBuilder;
  final ScrollController? scrollController;

  final TextEditingController controller;
  final Function(String) onSubmit;
  final Widget? loadingWidget;

  @override
  State<LLMChat> createState() => _LLMChatState();
}

class _LLMChatState extends State<LLMChat> {
  @override
  Widget build(BuildContext context) {
    final _messages = widget.messages.reversed.toList();

    final _style = widget.style ??
        LlmMessageStyle(
          userColor: Colors.grey,
          assistantColor: Colors.blue,
        );

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length + 1,
            controller: widget.scrollController,
            padding: widget.chatPadding ??
                EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            itemBuilder: (_, i) {
              if (i == 0) {
                if (widget.awaitingResponse) {
                  return widget.loadingWidget ??
                      TypingIndicator(
                        assistantColor:
                            widget.style?.assistantColor ?? Colors.blue,
                      );
                }
                return Container();
              }

              i = i - 1;

              final builder = widget.messageBuilder;
              if (builder != null) {
                return widget.messageBuilder!(_messages[i]);
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: LlmChatMessageItem(
                    showSystemMessage: widget.showSystemMessage,
                    boxDecorationBasedOnMessage:
                        widget.boxDecorationBasedOnMessage,
                    messagePadding: widget.messagePadding,
                    message: _messages[i],
                    style: _style,
                  ),
                );
              }
            },
          ),
        ),
        LLmChatTextInput(
          inputPadding: widget.style?.inputPadding,
          background: widget.style?.inputBoxColor,
          icon: widget.style?.sendIcon,
          textStyle: widget.style?.inputTextStyle,
          controller: widget.controller,
          onSubmit: (text) {
            widget.onSubmit(text);
            widget.scrollController?.jumpTo(0);
          },
        ),
      ],
    );
  }
}

class LLmChatTextInput extends StatefulWidget {
  const LLmChatTextInput({
    required this.controller,
    required this.onSubmit,
    super.key,
    this.textStyle,
    this.icon,
    this.background,
    this.inputPadding,
  });

  final TextEditingController controller;
  final Function(String) onSubmit;
  final TextStyle? textStyle;
  final Widget? icon;
  final Color? background;
  final EdgeInsets? inputPadding;

  @override
  State<LLmChatTextInput> createState() => _LLmChatTextInputState();
}

class _LLmChatTextInputState extends State<LLmChatTextInput> {
  void submit() {
    widget.onSubmit(widget.controller.text);
    widget.controller.clear();
  }

  late final _focusNode = FocusNode(
    onKey: (FocusNode node, RawKeyEvent evt) {
      if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
        if (evt is RawKeyDownEvent) {
          submit();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.background ?? Color(0xff9E9EA5),
      padding: widget.inputPadding ??
          const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: widget.textStyle,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              focusNode: _focusNode,
              controller: widget.controller,
              onSubmitted: (_) => submit(),
              decoration: InputDecoration(
                  hintText: "Type your message...",
                  border: InputBorder.none,
                  hintStyle: widget.textStyle),
            ),
          ),
          IconButton(
            icon: widget.icon ?? const Icon(Icons.send),
            onPressed: submit,
          )
        ],
      ),
    );
  }
}

class LlmChatMessageItem extends StatelessWidget {
  const LlmChatMessageItem({
    this.boxDecorationBasedOnMessage,
    this.messagePadding,
    required this.message,
    required this.style,
    required this.showSystemMessage,
  });

  final bool showSystemMessage;
  final LlmMessageStyle style;
  final LlmChatMessage message;
  final BoxDecoration Function(LlmChatMessage)? boxDecorationBasedOnMessage;
  final EdgeInsetsGeometry? messagePadding;

  @override
  Widget build(BuildContext context) {
    if (message.type == 'system') {
      if (!showSystemMessage) {
        return Container();
      }
    }

    final isSystem = message.type == 'system';

    BoxDecoration decoration = boxDecorationBasedOnMessage == null
        ? BoxDecoration(
            color: _getColor(), borderRadius: BorderRadius.circular(12))
        : boxDecorationBasedOnMessage!(message);

    return Align(
      alignment:
          message.type == 'user' ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        padding: messagePadding ??
            EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
        decoration: decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSystem)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'System',
                  style: style.systemTextStyle,
                ),
              ),
            SelectableText(
              style: _getTextStyle(),
              '${message.message}',
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor() {
    switch (message.type) {
      case 'user':
        return style.userColor;
      case 'system':
        return style.systemColor ?? style.assistantColor.withOpacity(.5);
      default:
        return style.assistantColor;
    }
  }

  TextStyle? _getTextStyle() {
    switch (message.type) {
      case 'user':
        return style.userTextStyle;
      case 'system':
        return style.systemTextStyle;
      default:
        return style.assistantTextStyle;
    }
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({required this.assistantColor, super.key});

  final Color assistantColor;

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> {
  List<double> _opacities = [0.0, 0.0, 0.0];

  @override
  void initState() {
    super.initState();
    _animateDots();
  }

  void _animateDots() async {
    const duration = Duration(milliseconds: 200);
    while (true) {
      await Future.delayed(duration);
      setState(() {
        _opacities = [1.0, 0.0, 0.0];
      });
      await Future.delayed(duration);
      setState(() {
        _opacities = [1.0, 1.0, 0.0];
      });
      await Future.delayed(duration);
      setState(() {
        _opacities = [1.0, 1.0, 1.0];
      });
      await Future.delayed(duration);
      setState(() {
        _opacities = [0.0, 0.0, 0.0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: List.generate(
              3,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 3),
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: _opacities[index] > 0.5
                      ? widget.assistantColor
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
