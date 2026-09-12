import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set system UI to light theme with dark icons for a clean native look on white
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const NilgiriApp());
}

class NilgiriApp extends StatelessWidget {
  const NilgiriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nilgiri College',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.light,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

/// A clean, pure white splash screen featuring ONLY the Nilgiri College logo
/// in the center and the co-developer attribution at the bottom, properly
/// animated for up to 5 seconds.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _pulseScale;

  late final Timer _splashTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // 1. Smooth entrance animation (Apple/Material 3 style)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutBack,
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.95, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    // 2. Subtle living pulse for the logo to give it an ultra-premium feel
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine,
      ),
    );

    _entranceController.forward().then((_) {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });

    // 3. Exactly max 5 seconds before transitioning into the portal
    _splashTimer = Timer(const Duration(seconds: 5), _navigateToPortal);
  }

  void _navigateToPortal() {
    if (_navigated || !mounted) return;
    _navigated = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PortalWebViewScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _splashTimer.cancel();
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SizedBox.expand(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Centered Nilgiri College Logo (Clean, no extra badges or titles)
                FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: ScaleTransition(
                      scale: _pulseScale,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
                              blurRadius: 36,
                              spreadRadius: 2,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/nilgiri_college_logo.png',
                          width: 175,
                          height: 175,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Bottom Co-Developer Attribution
                FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: _textSlide,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 24, left: 16, right: 16),
                      child: Text(
                        'APP CODEVELOPED WITH NIHAL PM',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Native-feeling Portal Screen.
/// Guarantees that users NEVER open external browsers, never see browser UI,
/// never trigger web callouts/text highlights, and experience a pure native app feel.
class PortalWebViewScreen extends StatefulWidget {
  const PortalWebViewScreen({super.key});

  @override
  State<PortalWebViewScreen> createState() => _PortalWebViewScreenState();
}

class _PortalWebViewScreenState extends State<PortalWebViewScreen> {
  static const String _portalUrl = 'http://192.168.4.254:30013';

  late final WebViewController _webViewController;
  double _loadingProgress = 0.0;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _startTimeoutWatchdog() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && _isLoading) {
        setState(() {
          _hasError = true;
          _isLoading = false;
          _errorMessage = 'Connection timed out. Please check campus Wi-Fi.';
        });
      }
    });
  }

  void _initWebView() {
    _startTimeoutWatchdog();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(false) // Disable browser pinch-to-zoom to maintain native app feel
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress / 100.0;
                if (progress >= 100) {
                  _isLoading = false;
                  _timeoutTimer?.cancel();
                }
              });
            }
          },
          onPageStarted: (String url) {
            _startTimeoutWatchdog();
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
            _injectNativeFeelScripts();
          },
          onPageFinished: (String url) {
            // If the browser loaded an internal Chromium error page (like chromewebdata), suppress it!
            if (url.contains('chromewebdata') ||
                url.startsWith('chrome-error://') ||
                url.startsWith('data:text/html')) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _isLoading = false;
                });
              }
              _timeoutTimer?.cancel();
              return;
            }

            _timeoutTimer?.cancel();
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
            _injectNativeFeelScripts();
          },
          onWebResourceError: (WebResourceError error) {
            _timeoutTimer?.cancel();
            // NEVER allow Chromium's "Web page not available" screen to show!
            if (mounted) {
              setState(() {
                _hasError = true;
                _isLoading = false;
                _errorMessage = error.description;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.tryParse(request.url);
            if (uri == null) return NavigationDecision.prevent;

            // STRICT IN-APP NAVIGATION:
            // All HTTP & HTTPS links MUST remain inside the native app WebView.
            // NEVER launch an external browser like Chrome or Samsung Internet.
            if (uri.scheme == 'http' || uri.scheme == 'https') {
              return NavigationDecision.navigate;
            }

            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(_portalUrl));
  }

  /// Injects CSS and JavaScript to strip away all browser-like giveaways:
  /// - Removes web tap highlight boxes
  /// - Disables text selection loupes/handles
  /// - Suppresses default web context menus (Save Image, Copy Link, etc.)
  /// - Forces target="_blank" links and window.open to stay within the app
  void _injectNativeFeelScripts() {
    const js = '''
      (function() {
        // 1. Remove web tap highlights and callouts
        const style = document.createElement('style');
        style.type = 'text/css';
        style.innerHTML = `
          * {
            -webkit-tap-highlight-color: transparent !important;
            -webkit-touch-callout: none !important;
          }
          body, html {
            overscroll-behavior-y: contain;
            -webkit-font-smoothing: antialiased;
            -webkit-user-select: none;
            user-select: none;
          }
          input, textarea, [contenteditable="true"] {
            -webkit-user-select: text !important;
            user-select: text !important;
          }
        `;
        document.head.appendChild(style);

        // 2. Block web browser context menus (Save image, open in new tab)
        document.addEventListener('contextmenu', function(e) {
          if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
            e.preventDefault();
          }
        }, false);

        // 3. Ensure target="_blank" links open in this view, NOT in external browsers
        function sanitizeLinks() {
          const links = document.querySelectorAll('a[target="_blank"]');
          for (let i = 0; i < links.length; i++) {
            links[i].setAttribute('target', '_self');
          }
        }
        sanitizeLinks();
        document.addEventListener('DOMContentLoaded', sanitizeLinks);

        // 4. Override window.open to keep everything inside the app
        window.open = function(url) {
          if (url) {
            window.location.href = url;
          }
          return null;
        };
      })();
    ''';
    _webViewController.runJavaScript(js).catchError((_) {});
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _hasError = false;
      _isLoading = true;
      _loadingProgress = 0.0;
    });
    _startTimeoutWatchdog();
    await _webViewController.loadRequest(Uri.parse(_portalUrl));
  }

  Widget _buildErrorView() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Branded Logo Container
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.12),
                      blurRadius: 28,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/nilgiri_college_logo.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 28),

              // Title
              const Text(
                'Campus Network Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle / Guidance
              const Text(
                'The Nilgiri College portal can only be accessed while your phone is connected to the Nilgiri Campus Wi-Fi network.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 24),

              // Step-by-step native instruction card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.wifi_rounded,
                            size: 18,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Connect your device to the Nilgiri Campus Wi-Fi network.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF334155),
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.refresh_rounded,
                            size: 18,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Tap Retry Connection below to enter the portal.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF334155),
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _handleRefresh,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Retry Connection',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          // Native back navigation: go back through web history if available
          if (!_hasError && await _webViewController.canGoBack()) {
            await _webViewController.goBack();
          } else {
            // If at root of navigation or on error screen, exit gracefully
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            // When an error occurs, COMPLETELY replace the view with the native screen!
            // This guarantees the Android Chromium "Web page not available" screen NEVER displays!
            child: _hasError
                ? _buildErrorView()
                : Stack(
                    children: [
                      // Main Native In-App Web View with Pull-to-Refresh
                      RefreshIndicator(
                        color: const Color(0xFF1E3A8A),
                        backgroundColor: Colors.white,
                        onRefresh: _handleRefresh,
                        child: WebViewWidget(controller: _webViewController),
                      ),

                      // Native Slim Loading Progress Bar (Top Pinned)
                      if (_isLoading)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: 2.5,
                            child: LinearProgressIndicator(
                              value: _loadingProgress > 0 ? _loadingProgress : null,
                              backgroundColor: Colors.transparent,
                              color: const Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

