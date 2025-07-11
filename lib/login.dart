import 'package:flutter/material.dart';
import 'package:t_store/signup.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'branch_checkin_screen.dart';

class EmployeeLoginScreen extends StatefulWidget {
  const EmployeeLoginScreen({super.key});

  @override
  State<EmployeeLoginScreen> createState() => _EmployeeLoginScreenState();
}

class _EmployeeLoginScreenState extends State<EmployeeLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authenticateUser();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BranchCheckInScreen(
              employeeName: _getNameFromEmail(_emailController.text),
              employeeId: _emailController.text,
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getNameFromEmail(String email) {
    try {
      final namePart = email.split('@').first;
      final nameComponents = namePart.split('.');
      return nameComponents
          .map((e) => e.isNotEmpty ? e[0].toUpperCase() + e.substring(1) : '')
          .join(' ');
    } catch (e) {
      return "Employee";
    }
  }

  Future<void> _authenticateUser() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TColors.error,
      ),
    );
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmployeeSignInScreen()),
    );
  }

  Widget _buildHeader() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 24),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/logos/splash_logo.png',
            width: 90,
            height: 90,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome Back',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? TColors.accent : TColors.primary,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to access your workspace',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? TColors.textSecondary : TColors.darkGrey,
              ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? hint,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          color: isDarkMode ? TColors.white : TColors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDarkMode ? TColors.textWhite : TColors.darkGrey,
          ),
          prefixIcon: Icon(icon, color: TColors.accent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDarkMode ? TColors.grey : TColors.borderPrimary,
            ),
          ),
          filled: true,
          fillColor: isDarkMode ? TColors.dark : TColors.light,
          hintText: hint,
          hintStyle: TextStyle(
            color: isDarkMode ? TColors.textSecondary : TColors.darkGrey,
          ),
          suffixIcon: suffix,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      controller: _passwordController,
      label: 'Password',
      icon: Icons.lock_outline,
      obscureText: _obscurePassword,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Please enter your password' : null,
      suffix: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).brightness == Brightness.dark
              ? TColors.grey
              : TColors.darkGrey,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
    );
  }

  Widget _buildRememberMeRow() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) => setState(() => _rememberMe = value ?? false),
          activeColor: TColors.primary,
        ),
        Text(
          'Remember me',
          style: TextStyle(
            color: isDarkMode ? TColors.textWhite : TColors.darkGrey,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: isDarkMode ? TColors.accent : TColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(TColors.white),
              )
            : const Text(
                'SIGN IN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TColors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildFooter() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            "New employee?",
            style: TextStyle(
              color: isDarkMode ? TColors.textSecondary : TColors.darkGrey,
            ),
          ),
          TextButton(
            onPressed: _navigateToSignUp,
            child: Text(
              'Create Account',
              style: TextStyle(
                color: isDarkMode ? TColors.accent : TColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                _buildTextField(
                  controller: _emailController,
                  label: 'Company Email',
                  icon: Icons.email_outlined,
                  hint: 'your.name@company.com',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^.+@.+\..+$').hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                _buildPasswordField(),
                _buildRememberMeRow(),
                const SizedBox(height: 8),
                _buildSignInButton(),
                const SizedBox(height: 24),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
