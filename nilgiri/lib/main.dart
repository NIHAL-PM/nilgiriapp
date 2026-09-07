import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.launcher});

  final Future<bool> Function(Uri uri)? launcher;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nilgiri College',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF071C2C),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B75BB),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Arial',
      ),
      home: SplashScreen(launcher: launcher),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.launcher});

  final Future<bool> Function(Uri uri)? launcher;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static final Uri portalUri = Uri.parse('http://192.168.4.254:30013');
  late final AnimationController _logoController;
  late final Animation<double> _logoScale;
  late final Timer _portalTimer;
  bool _isOpening = false;
  String? _launchMessage;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    );
    _portalTimer = Timer(const Duration(milliseconds: 2400), _openPortal);
  }

  Future<void> _openPortal() async {
    if (!mounted || _isOpening) return;
    setState(() {
      _isOpening = true;
      _launchMessage = null;
    });

    try {
      final didLaunch = await (widget.launcher ?? launchUrl)(portalUri);
      if (mounted && !didLaunch) {
        setState(
          () => _launchMessage = 'Could not open the portal automatically.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _launchMessage = 'Could not open the portal automatically.',
        );
      }
    } finally {
      if (mounted) setState(() => _isOpening = false);
    }
  }

  @override
  void dispose() {
    _portalTimer.cancel();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A3550), Color(0xFF07131F)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _logoScale,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F7F2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF4FA7DC,
                            ).withValues(alpha: 0.25),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/nilgiri_college_logo.png',
                          width: 205,
                          height: 205,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  const Text(
                    'NILGIRI COLLEGE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF6F4ED),
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ARTS & SCIENCE',
                    style: TextStyle(
                      color: const Color(0xFF9CC9E6).withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4.2,
                    ),
                  ),
                  const SizedBox(height: 34),
                  Container(
                    height: 1,
                    width: 54,
                    color: const Color(0xFF4FA7DC),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Your digital campus is ready',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFF6F4ED).withValues(alpha: 0.82),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: _isOpening ? null : _openPortal,
                    icon: _isOpening
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.open_in_new_rounded),
                    label: const Text('Open college portal'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2D86C5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  if (_launchMessage != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      _launchMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFFFC7A5)),
                    ),
                  ],
                  const SizedBox(height: 46),
                  Text(
                    'co-developed with Nihal PM',
                    style: TextStyle(
                      color: const Color(0xFFF6F4ED).withValues(alpha: 0.55),
                      fontSize: 12,
                      letterSpacing: 0.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
