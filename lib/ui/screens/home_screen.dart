import 'package:flutter/material.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

/// Home screen that manages overlay permission and
/// bubble activation.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  bool _isOverlayActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
    _syncOverlayState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
      _syncOverlayState();
    }
  }

  Future<void> _syncOverlayState() async {
    final active =
        await FlutterOverlayWindow.isActive();
    setState(() {
      _isOverlayActive = active;
    });
  }

  Future<void> _checkPermission() async {
    final granted =
        await FlutterOverlayWindow.isPermissionGranted();
    setState(() {
      _isPermissionGranted = granted;
    });
  }

  Future<void> _requestPermission() async {
    await FlutterOverlayWindow.requestPermission();
    await _checkPermission();
  }

  Future<void> _startOverlay() async {
    final alreadyActive =
        await FlutterOverlayWindow.isActive();
    if (alreadyActive) {
      await FlutterOverlayWindow.closeOverlay();
      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );
    }

    await FlutterOverlayWindow.showOverlay(
      height: 70,
      width: 70,
      enableDrag: true,
      positionGravity: PositionGravity.auto,
      overlayTitle: 'Notefly',
      overlayContent: 'Tap bubble to open notes',
    );
    setState(() {
      _isOverlayActive = true;
    });
  }

  Future<void> _stopOverlay() async {
    await FlutterOverlayWindow.closeOverlay();
    setState(() {
      _isOverlayActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.note_alt_rounded,
                  size: 80,
                  color: Color(0xFF1565C0),
                ),
                const SizedBox(height: 16),
                Text(
                  'Notefly',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1565C0),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Quick notes, always on top',
                  style:
                      Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 48),
                if (!_isPermissionGranted)
                  _buildPermissionCard()
                else
                  _buildOverlayToggle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.shield_outlined,
              size: 40,
              color: Color(0xFFFFA726),
            ),
            const SizedBox(height: 12),
            const Text(
              'Overlay permission required',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Notefly needs permission to display '
              'the floating bubble on top of '
              'other apps.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _requestPermission,
              icon: const Icon(Icons.settings),
              label: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayToggle() {
    return FilledButton.icon(
      onPressed:
          _isOverlayActive ? _stopOverlay : _startOverlay,
      icon: Icon(
        _isOverlayActive
            ? Icons.stop_rounded
            : Icons.play_arrow_rounded,
      ),
      label: Text(
        _isOverlayActive
            ? 'Stop Bubble'
            : 'Start Bubble',
      ),
      style: FilledButton.styleFrom(
        minimumSize: const Size(200, 48),
        backgroundColor: _isOverlayActive
            ? const Color(0xFFE53935)
            : const Color(0xFF1565C0),
      ),
    );
  }
}
