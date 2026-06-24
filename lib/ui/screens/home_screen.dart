import 'package:flutter/material.dart';
import 'package:notefly/core/theme.dart';
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
    final alreadyActive = await FlutterOverlayWindow.isActive();
    if (alreadyActive) {
      await FlutterOverlayWindow.closeOverlay();
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }

    await FlutterOverlayWindow.showOverlay(
      height: 100,
      width: 100,
      enableDrag: true,
      positionGravity: PositionGravity.none,
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
      appBar: AppBar(
        title: const Text('FLOATING SETTINGS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -1)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(color: Colors.black, height: 3.0),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: AppTheme.brutalShadow,
                  ),
                  child: const Icon(
                    Icons.note_alt_rounded,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Notefly',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Quick notes, always on top',
                  style: Theme.of(context).textTheme.bodyLarge,
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: AppTheme.brutalShadow,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: AppTheme.brutalShadow,
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'PERMISSION REQUIRED',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Notefly needs permission to display the floating bubble on top of other apps.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _requestPermission,
            icon: const Icon(Icons.settings),
            label: const Text('GRANT PERMISSION'),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayToggle() {
    return FilledButton.icon(
      onPressed: _isOverlayActive ? _stopOverlay : _startOverlay,
      icon: Icon(
        _isOverlayActive ? Icons.stop_rounded : Icons.play_arrow_rounded,
      ),
      label: Text(
        _isOverlayActive ? 'STOP BUBBLE' : 'START BUBBLE',
      ),
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 64),
        backgroundColor: _isOverlayActive
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        foregroundColor: _isOverlayActive ? Colors.white : Colors.black,
      ),
    );
  }
}
