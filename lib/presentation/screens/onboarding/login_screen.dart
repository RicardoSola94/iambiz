import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/config.dart';
import 'package:iambiz/presentation/screens/widgets/custom_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../providers/providers.dart';
import '../screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  void _login() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      setState(() => emailError = 'Campo obligatorio');
      return;
    }
    if (password.isEmpty) {
      setState(() => passwordError = 'Campo obligatorio');
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .loginWithEmail(email: email, password: password);

      if (!mounted) return;

      // Ir a la pantalla principal, reemplazando login
      context.go('/home');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: -330,
                      right: -330,
                      child: Container(
                        height: 600,
                        width: 600,
                        decoration: BoxDecoration(
                          color: AppColors.lightprimaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -((1 / 4) * 500),
                      right: -((1 / 4) * 500),
                      child: Container(
                        height: 450,
                        width: 450,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.lightprimaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          SizedBox(width: double.infinity, height: 100),
                          Text(
                            'Inicie sesión aquí',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              'Bienvenido de nuevo se te ha echado de menos!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 100),
                          CustomTextfield(
                            hint: "Email",
                            controller: emailController,
                            errorText: emailError,
                          ),
                          SizedBox(height: 20),
                          CustomTextfield(
                            hint: "Password",
                            controller: passwordController,
                            errorText: passwordError,
                          ),
                          SizedBox(height: 25),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Olvido la contraseña?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          CustomButton(
                            text: 'Iniciar sesión',
                            isLarge: true,
                            onPressed: _login,
                          ),
                          SizedBox(height: 40),
                          InkWell(
                            onTap: () {
                              context.go('/create-account');
                            },
                            child: Text(
                              'Crear nueva cuenta',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'O continua con',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialButton(icon: FontAwesomeIcons.google),
                              SizedBox(width: 10),
                              SocialButton(icon: FontAwesomeIcons.facebook),
                              SizedBox(width: 10),
                              SocialButton(icon: FontAwesomeIcons.apple),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (authState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
