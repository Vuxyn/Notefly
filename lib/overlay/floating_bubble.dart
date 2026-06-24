import 'package:flutter/material.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:notefly/core/theme.dart';
import 'package:notefly/overlay/notes_panel_overlay.dart';

/// Bubble size in logical pixels.
const double kBubbleSize = 56;

/// Entry point and UI for the floating overlay.
/// It toggles between a small Draggable Bubble and a Full-Screen Notes Panel.
class FloatingBubble extends StatefulWidget {
  const FloatingBubble({super.key});

  @override
  State<FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<FloatingBubble> {
  bool _isExpanded = false;
  bool _isHidden = false;
  OverlayPosition? _savedPosition;

  void _togglePanel() async {
    if (_isExpanded) {
      // Hide panel first to prevent scaling glitch during shrink
      setState(() => _isHidden = true);
      await Future.delayed(const Duration(milliseconds: 30));

      // Shrink back to bubble
      await FlutterOverlayWindow.updateFlag(OverlayFlag.defaultFlag);
      await FlutterOverlayWindow.resizeOverlay(100, 100, true);
      if (_savedPosition != null) {
        await FlutterOverlayWindow.moveOverlay(_savedPosition!);
      }
      
      await Future.delayed(const Duration(milliseconds: 30));
      setState(() {
        _isExpanded = false;
        _isHidden = false;
      });
    } else {
      // Save current bubble position before expanding
      _savedPosition = await FlutterOverlayWindow.getOverlayPosition();
      
      // Hide bubble first to prevent giant icon stretch glitch
      setState(() => _isHidden = true);
      await Future.delayed(const Duration(milliseconds: 30));

      // Move to top-left corner so matchParent doesn't extend off-screen
      await FlutterOverlayWindow.moveOverlay(const OverlayPosition(0, 0));
      // Expand to full screen panel
      await FlutterOverlayWindow.resizeOverlay(
        WindowSize.matchParent,
        WindowSize.matchParent,
        false, // disable drag when expanded
      );
      // Update flag to allow keyboard focus
      await FlutterOverlayWindow.updateFlag(OverlayFlag.focusPointer);
      
      // Wait a bit for the window resize to complete before showing UI to avoid clipping
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _isExpanded = true;
        _isHidden = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isHidden) {
      return const SizedBox.shrink();
    }

    if (_isExpanded) {
      return NotesPanelOverlay(onClose: _togglePanel);
    }

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _togglePanel,
        child: Center(
          child: SizedBox(
            width: kBubbleSize,
            height: kBubbleSize,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.border, width: 3),
                boxShadow: AppTheme.brutalShadow,
              ),
              child: const Icon(
                Icons.note_alt_rounded,
                color: Colors.black,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
