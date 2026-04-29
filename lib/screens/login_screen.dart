import 'package:flutter/material.dart';
import 'package:tiktok_pcto/mock_data.dart';
import 'package:tiktok_pcto/screens/registration_screen.dart';

class LoginScreen extends StatelessWidget {
  final List<MockUser> users;
  final bool Function(String email, String password) onLoginWithCredentials;
  final ValueChanged<MockUser> onQuickLogin;

  const LoginScreen({
    super.key,
    required this.users,
    required this.onLoginWithCredentials,
    required this.onQuickLogin,
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
                    _TopBar(
                      onHelpTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usa uno dei profili demo o le credenziali mockate.'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Log in to TikTok',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _AuthOptionButton(
                      icon: Icons.person_outline_rounded,
                      label: 'Use phone / email / username',
                      onTap: () => _showLoginSheet(context),
                    ),
                    const SizedBox(height: 14),
                    _AuthOptionButton(
                      icon: Icons.facebook,
                      iconColor: const Color(0xFF1877F2),
                      label: 'Continue with Facebook',
                      onTap: () => onQuickLogin(users[1]),
                    ),
                    const SizedBox(height: 14),
                    _AuthOptionButton(
                      icon: Icons.apple,
                      label: 'Continue with Apple',
                      onTap: () => onQuickLogin(users[0]),
                    ),
                    const SizedBox(height: 14),
                    _AuthOptionButton(
                      icon: Icons.g_mobiledata_rounded,
                      iconColor: const Color(0xFFDB4437),
                      label: 'Continue with Google',
                      onTap: () => onQuickLogin(users[2]),
                    ),
                    const SizedBox(height: 14),
                    _AuthOptionButton(
                      icon: Icons.camera_alt_outlined,
                      iconColor: const Color(0xFFE1306C),
                      label: 'Continue with Instagram',
                      onTap: () => onQuickLogin(users[3]),
                    ),
                    const SizedBox(height: 14),
                    _AuthOptionButton(
                      icon: Icons.flutter_dash_rounded,
                      iconColor: const Color(0xFF1DA1F2),
                      label: 'Continue with Twitter',
                      onTap: () => onQuickLogin(users[4]),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE9E9E9)),
                      ),
                      child: const Text(
                        'Demo rapida: giulia@mocktok.it / 123456',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 90),
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
            _BottomCtaBar(
              prompt: "Don't have an account?",
              action: 'Sign up',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RegistrationScreen(
                      users: users,
                      onSelectUser: onQuickLogin,
                      onLoginWithCredentials: onLoginWithCredentials,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLoginSheet(BuildContext context) async {
    final emailController = TextEditingController(text: 'giulia@mocktok.it');
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
                      'Use phone / email / username',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Login locale con credenziali mockate oppure scegli un profilo demo.',
                      style: TextStyle(color: Color(0xFF666666), fontSize: 14),
                    ),
                    const SizedBox(height: 18),
                    _InputField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.alternate_email_rounded,
                    ),
                    const SizedBox(height: 12),
                    _InputField(
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
                          } else {
                            setSheetState(() {
                              errorText = 'Credenziali non valide. Prova con l account demo suggerito.';
                            });
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFE2C55),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Log in'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Profili demo',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...users.map(
                      (user) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _DemoUserTile(
                          user: user,
                          onTap: () {
                            onQuickLogin(user);
                            Navigator.of(sheetContext).pop();
                          },
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

class _TopBar extends StatelessWidget {
  final VoidCallback onHelpTap;

  const _TopBar({required this.onHelpTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onHelpTap,
          icon: const Icon(
            Icons.help_outline_rounded,
            color: Color(0xFF737373),
            size: 28,
          ),
        ),
      ],
    );
  }
}

class _AuthOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;

  const _AuthOptionButton({
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
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;

  const _InputField({
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

class _DemoUserTile extends StatelessWidget {
  final MockUser user;
  final VoidCallback onTap;

  const _DemoUserTile({
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE8E8E8)),
      ),
      tileColor: Colors.white,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFFFE6EC),
        child: Text(user.avatarEmoji),
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text('${user.username}  •  ${user.email}'),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
    );
  }
}

class _BottomCtaBar extends StatelessWidget {
  final String prompt;
  final String action;
  final VoidCallback onTap;

  const _BottomCtaBar({
    required this.prompt,
    required this.action,
    required this.onTap,
  });

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
            Text(
              prompt,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onTap,
              child: Text(
                action,
                style: const TextStyle(
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
