import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import 'login_theme.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _selectedOption = 'password'; // 'email', 'phone', 'password'
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return Row(
              children: [
                // Left Side Image (50%)
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          color: LoginTheme.primaryBlue.withOpacity(0.6),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Image.asset(
                            'assets/images/Image.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right Side Form (50%)
                Expanded(
                  flex: 1,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: _buildLoginForm(context),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Mobile Layout
            return Container(
              decoration: const BoxDecoration(
                 gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Color(0xFFF0FFF5)],
                 ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildLoginForm(context),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo and Titles
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
             // Add Logo here if available
             // Image.asset('assets/images/logo.png', width: 50),
          ],
        ),
        const SizedBox(height: 20),
        
        Text(
          'Welcome',
          style: LoginTheme.headingStyle.copyWith(
             fontSize: 32, 
             fontWeight: FontWeight.bold,
             color: LoginTheme.primaryBlue,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: LoginTheme.accentGreen.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Hello welcome to Mavoo',
             style: LoginTheme.bodyStyle.copyWith(color: LoginTheme.primaryBlue, fontWeight: FontWeight.w500),
             textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),

        // Tabs de Selección
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: LoginTheme.primaryBlue.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildTabButton('Email', 'email'),
                  _buildTabButton('Phone', 'phone'),
                  _buildTabButton('Password', 'password'),
                ],
              ),
              
              // Campos de Input
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      LoginTheme.accentGreen.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: _buildInputs(),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 30),
        
        // Botón de Acción y Mensajes de Error
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go('/home');
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Column(
                children: [
                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator(color: LoginTheme.primaryBlue))
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LoginTheme.buttonGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: LoginTheme.primaryBlue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          _selectedOption == 'password' ? 'Login' : 'Send OTP',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  
                  if (state is AuthError) ...[
                     const SizedBox(height: 20),
                     Text(
                       state.message,
                       style: const TextStyle(color: Colors.red),
                       textAlign: TextAlign.center,
                     ),
                  ]
                ],
              );
            },
          ),
          ),
        ),
        const SizedBox(height: 20),
        
        Row(
          children: [
            Expanded(child: Divider(color: LoginTheme.primaryBlue.withOpacity(0.2), thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "OR",
                 style: GoogleFonts.poppins(color: LoginTheme.primaryBlue.withOpacity(0.6), fontWeight: FontWeight.w500)
              ),
            ),
            Expanded(child: Divider(color: LoginTheme.primaryBlue.withOpacity(0.2), thickness: 1)),
          ],
        ),
        const SizedBox(height: 20),
        _buildGoogleButton(),
      ],
    );

  }

  Widget _buildTabButton(String label, String value) {
    final isSelected = _selectedOption == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedOption = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? null : Colors.white,
            gradient: isSelected ? LoginTheme.buttonGradient : null,
            borderRadius: value == 'email' 
                ? const BorderRadius.only(topLeft: Radius.circular(12))
                : value == 'password' 
                    ? const BorderRadius.only(topRight: Radius.circular(12))
                    : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : LoginTheme.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputs() {
    if (_selectedOption == 'email') {
      return _buildTextField(_emailController, 'Enter your Email', TextInputType.emailAddress);
    } else if (_selectedOption == 'phone') {
      return _buildTextField(_phoneController, 'Enter phone number', TextInputType.phone);
    } else {
      return Column(
        children: [
          _buildTextField(_emailController, 'Username or Email', TextInputType.text),
          const SizedBox(height: 12),
          _buildTextField(_passwordController, 'Password', TextInputType.visiblePassword, obscureText: true),
        ],
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String hint, TextInputType type, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: LoginTheme.primaryBlue.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: LoginTheme.primaryBlue.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: LoginTheme.primaryBlue, width: 2),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_selectedOption == 'password') {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    } else {
      // Implementar lógica de OTP aquí
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Logic not implemented yet')),
      );
    }
  }
  }

  Widget _buildGoogleButton() {
     return InkWell(
        onTap: _handleGoogleSignIn,
        child: Container(
           padding: const EdgeInsets.symmetric(vertical: 12),
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.circular(12),
             border: Border.all(color: LoginTheme.primaryBlue.withOpacity(0.2), width: 2),
             boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
             ], 
           ),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
                const FaIcon(FontAwesomeIcons.google, color: LoginTheme.primaryBlue), // Google Logo
                const SizedBox(width: 12),
                Text("Continue with Google", style: GoogleFonts.poppins(
                   fontSize: 16, 
                   fontWeight: FontWeight.w600, 
                   color: LoginTheme.primaryBlue
                )),
             ],
           ),
        ),
     );
  }

  Future<void> _handleGoogleSignIn() async {
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
        );
        final GoogleSignInAccount? account = await googleSignIn.signIn();
        
        if (account != null) {
            // Send to Bloc (Need to implement AuthGoogleLoginRequested event)
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Sign In Success: ${account.email}. Sending to backend...')));
             // context.read<AuthBloc>().add(AuthGoogleLoginRequested(account));
             // For now, since event is not yet created, just print/show snackbar.
             // But I should create the event. 
             // Temporarily just print.
             print("Google Account: ${account.email} ${account.displayName} ${account.photoUrl}");
        }
      } catch (e) {
         print(e);
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Sign In Failed: $e')));
      }
  }

}

