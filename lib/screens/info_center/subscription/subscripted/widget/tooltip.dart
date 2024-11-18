import 'package:flutter/material.dart';

class TooltipWidget extends StatefulWidget {
  final String message;

  TooltipWidget({required this.message});

  @override
  _TooltipWidgetState createState() => _TooltipWidgetState();
}

class _TooltipWidgetState extends State<TooltipWidget> {
  OverlayEntry? _overlayEntry;

  void _showTooltip(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    // 툴팁의 위치 조정
    double tooltipLeft = position.dx - 20;
    double tooltipTop = position.dy + renderBox.size.height + 8;

    // 툴팁이 화면 왼쪽을 넘어서는 경우
    if (tooltipLeft < 0) {
      tooltipLeft = 0;
    }

    // 툴팁이 화면 오른쪽을 넘어서는 경우
    if (tooltipLeft + 150 > screenSize.width) {
      tooltipLeft = screenSize.width - 180;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tooltip 외부 클릭을 감지하는 영역
          Listener(
            behavior: HitTestBehavior.translucent, 
            onPointerDown: (_) {
              _hideTooltip(); 
            },
            child: Container(), 
          ),
          Positioned(
            left: tooltipLeft,
            top: tooltipTop,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 170,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay?.insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_overlayEntry == null) {
          _showTooltip(context);
        } else {
          _hideTooltip();
        }
      },
      child: Icon(Icons.help_outline, color: Colors.grey, size: 16),
    );
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }
}
