import 'package:flutter/material.dart';
import 'package:tiktok_pcto/mock_data.dart';

class RegistrationScreen extends StatelessWidget {
  final List<MockUser> users;
  final ValueChanged<MockUser> onSelectUser;
  final bool Function(String email, String password) onLoginWithCredentials;

  const RegistrationScreen({
    super.key,
    required this.users,
    required this.onSelectUser,
    required this.onLoginWithCredentials,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.help_outline_rounded,
                            color: Color(0xFF737373),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sign up\nfor TikTok',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 0.98,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _SignUpOptionButton(
                      icon: Icons.person_outline_rounded,
                      label: 'Use phone or email',
                      onTap: () => _showSignupSheet(context),
                    ),
                    const SizedBox(height: 14),
                    _SignUpOptionButton(
                      icon: Icons.facebook,
                      iconColor: const Color(0xFF1877F2),
                      label: 'Continue with Facebook',
                      onTap: () => onSelectUser(users[1]),
                    ),
                    const SizedBox(height: 14),
                    _SignUpOptionButton(
                      icon: Icons.apple,
                      label: 'Continue with Apple',
                      onTap: () => onSelectUser(users[0]),
                    ),
                    const SizedBox(height: 14),
                    _SignUpOptionButton(
                      icon: Icons.g_mobiledata_rounded,
                      iconColor: const Color(0xFFDB4437),
                      label: 'Continue with Google',
                      onTap: () => onSelectUser(users[2]),
                    ),
                    const SizedBox(height: 120),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'By continuing, you agree to our Terms of Service and acknowledge that you have read our Privacy Policy to learn how we collect, use, and share your data.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7D7D7D),
                          fontSize: 13,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _SignupBottomBar(
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSignupSheet(BuildContext context) async {
    final emailController = TextEditingController(text: 'sara@mocktok.it');
    final passwordController = TextEditingController(text: '123456');
    String? errorText;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create with mock data',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Per il clone locale, signup e login usano gli account demo gia` presenti.',
                      style: TextStyle(color: Color(0xFF666666), fontSize: 14),
                    ),
                    const SizedBox(height: 18),
                    _SheetField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.mail_outline_rounded,
                    ),
                    const SizedBox(height: 12),
                    _SheetField(
                      controller: passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: true,
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        errorText!,
                        style: const TextStyle(color: Color(0xFFFE2C55), fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          final success = onLoginWithCredentials(
                            emailController.text,
                            passwordController.text,
                          );
                          if (success) {
                            Navigator.of(sheetContext).pop();
                            Navigator.of(context).pop();
                          } else {
                            setSheetState(() {
                              errorText = 'Questo clone usa solo gli account mockati gia` caricati.';
                            });
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFE2C55),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Create account'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Oppure scegli un account demo',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    ...users.map(
                      (user) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: () {
                            onSelectUser(user);
                            Navigator.of(sheetContext).pop();
                            Navigator.of(context).pop();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(color: Color(0xFFE8E8E8)),
                          ),
                          tileColor: Colors.white,
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFEFF6FF),
                            child: Text(user.avatarEmoji),
                          ),
                          title: Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(user.username),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SignUpOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;

  const _SignUpOptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFD9D9D9)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 25),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
        ),
      ),
    );
  }
}

class _SignupBottomBar extends StatelessWidget {
  final VoidCallback onTap;

  const _SignupBottomBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F1F1),
        border: Border(top: BorderSide(color: Color(0xFFE3E3E3))),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account?',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onTap,
              child: const Text(
                'Log in',
                style: TextStyle(
                  color: Color(0xFFFE2C55),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
