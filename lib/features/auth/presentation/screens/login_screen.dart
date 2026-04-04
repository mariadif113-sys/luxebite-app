import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:flutter_application_1/core/providers/language_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _pinController = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    if (_pinController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Hardcoded Admin PIN for now (Unifying 1234 and 0000)
    final pin = _pinController.text.trim();
    if (pin == '1234' || pin == '0000') {
      if (mounted) {
        debugPrint('LOGIN SUCCESS: Admin Access Granted');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        );
      }
    } else {
      if (mounted) {
        debugPrint('LOGIN FAILED: Invalid PIN entered: $pin');
        final locale = ref.read(languageProvider);
        final isAr = locale.languageCode == 'ar';
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAr ? 'رمز الدخول غير صحيح' : 'Invalid Admin PIN'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = ref.watch(languageProvider);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [theme.primaryColor.withOpacity(0.1), Colors.black],
                ),
              ),
            ),
          ),
          // Language Switcher
          Positioned(
            top: 50,
            right: isAr ? null : 20,
            left: isAr ? 20 : null,
            child: IconButton(
              icon: Icon(Icons.language_rounded, color: theme.primaryColor),
              onPressed: () => _showLanguageDialog(context, ref),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        color: theme.primaryColor, shape: BoxShape.circle),
                    child: const Icon(Icons.admin_panel_settings,
                        color: Colors.black, size: 35),
                  ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 20),
                  Text(
                    isAr ? 'لوحة تحكم المدير' : (isFr ? 'PORTAIL ADMIN' : 'LUXEBITE ADMIN'),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: theme.primaryColor,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 50),
                  GlassmorphicContainer(
                    width: double.infinity,
                    height: 300,
                    borderRadius: 30,
                    blur: 20,
                    alignment: Alignment.center,
                    border: 1,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05)
                      ],
                    ),
                    borderGradient: LinearGradient(
                      colors: [
                        theme.primaryColor.withOpacity(0.5),
                        theme.primaryColor.withOpacity(0.1)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isAr ? 'دخول المدير' : (isFr ? 'Accès Admin' : 'Admin Access'),
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(isAr ? 'أدخل الرمز السري المكون من 4 أرقام' : (isFr ? 'Entrez votre code PIN...' : 'Enter your secure 4-digit PIN'),
                              style:
                                  GoogleFonts.outfit(color: Colors.white60)),
                          const SizedBox(height: 30),
                          _buildTextField(isAr ? 'رمز PIN' : (isFr ? 'Code PIN' : 'PIN Code'), Icons.lock_outline,
                              _pinController,
                              isObscure: true, isNumber: true),
                          const Spacer(),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isLoading ? null : () {
                                debugPrint('LOGIN BUTTON PRESSED');
                                _submit();
                              },
                              borderRadius: BorderRadius.circular(27),
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    theme.primaryColor,
                                    const Color(0xFFB8860B)
                                  ]),
                                  borderRadius: BorderRadius.circular(27),
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.black)
                                      : Text(isAr ? 'دخول اللوحة' : (isFr ? 'ACCÉDER' : 'ACCESS DASHBOARD'),
                                          style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              letterSpacing: 2)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool isObscure = false, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.amber.withOpacity(0.6)),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.white54,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1)),
          ],
        ),
        TextField(
          controller: controller,
          obscureText: isObscure,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLength: 4,
          style: GoogleFonts.outfit(fontSize: 20, letterSpacing: 8),
          decoration: const InputDecoration(
            isDense: true,
            counterText: "",
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white10)),
            focusedBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          ),
        ),
      ],
    );
  }
  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.read(languageProvider);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isAr ? 'اختر اللغة' : (isFr ? 'Choisir la langue' : 'Select Language'),
          style: GoogleFonts.outfit(color: theme.primaryColor, fontWeight: FontWeight.bold),
          textAlign: isAr ? TextAlign.right : TextAlign.left,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption(context, ref, 'العربية', const Locale('ar'), locale.languageCode == 'ar'),
            _languageOption(context, ref, 'English', const Locale('en'), locale.languageCode == 'en'),
            _languageOption(context, ref, 'Français', const Locale('fr'), locale.languageCode == 'fr'),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(BuildContext context, WidgetRef ref, String label, Locale locale, bool isSelected) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(label, style: GoogleFonts.outfit(color: isSelected ? theme.primaryColor : Colors.white70)),
      trailing: isSelected ? Icon(Icons.check_circle, color: theme.primaryColor) : null,
      onTap: () {
        ref.read(languageProvider.notifier).setLocale(locale);
        Navigator.pop(context);
      },
    );
  }
}
