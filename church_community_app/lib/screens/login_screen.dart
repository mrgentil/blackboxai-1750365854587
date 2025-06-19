import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userService = UserService();
  
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final success = await _userService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email ou mot de passe incorrect'),
              backgroundColor: Constants.errorColor,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = await showDialog<String>(
      context: context,
      builder: (context) => _ForgotPasswordDialog(),
    );

    if (email != null && mounted) {
      final success = await _userService.resetPassword(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Instructions envoyées à $email'
                  : 'Erreur lors de l\'envoi des instructions',
            ),
            backgroundColor: success ? Constants.successColor : Constants.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.church,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // App Name
                  Text(
                    Constants.appName,
                    style: Constants.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email Field
                  CustomTextField.email(
                    controller: _emailController,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  CustomTextField.password(
                    controller: _passwordController,
                    enabled: !_isLoading,
                    obscureText: !_showPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        color: Constants.primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading ? null : _handleForgotPassword,
                      child: const Text('Mot de passe oublié ?'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  CustomButton(
                    text: 'Se connecter',
                    onPressed: _isLoading ? null : _handleLogin,
                    isLoading: _isLoading,
                    isFullWidth: true,
                  ),
                  const SizedBox(height: 16),

                  // Register Button
                  CustomButton.secondary(
                    text: 'Créer un compte',
                    onPressed: _isLoading
                        ? null
                        : () {
                            // TODO: Navigate to register screen
                          },
                    isFullWidth: true,
                  ),
                  const SizedBox(height: 32),

                  // Version Info
                  Text(
                    'Version ${Constants.appVersion}',
                    style: TextStyle(
                      color: Constants.textColor.withOpacity(0.6),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
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

class _ForgotPasswordDialog extends StatefulWidget {
  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.defaultBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Réinitialiser le mot de passe',
                style: Constants.subheadingStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Entrez votre email pour recevoir les instructions '
                'de réinitialisation de mot de passe.',
              ),
              const SizedBox(height: 16),
              CustomTextField.email(
                controller: _emailController,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomButton.secondary(
                      text: 'Annuler',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Envoyer',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context, _emailController.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
