import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/config.dart';
import 'package:iambiz/presentation/providers/providers.dart';
import 'package:iambiz/presentation/screens/widgets/custom_button.dart';
import 'package:iambiz/presentation/screens/widgets/social_button.dart';
import 'package:iambiz/presentation/screens/widgets/custom_textfield.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? nameError;
  String? phoneError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String? validateEmail(String email) {
    if (email.isEmpty) return 'Campo obligatorio';
    if (!email.contains('@')) return 'Email inválido';
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Campo obligatorio';
    if (password.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return 'Campo obligatorio';
    if (password != confirmPassword) return 'Las contraseñas no coinciden';
    return null;
  }

  String? validateNombre(String nombre) {
    if (nombre.isEmpty) return 'Campo obligatorio';
    //  if (!email.contains('@')) return 'Email inválido';
    return null;
  }

  String? validatePhone(String phone) {
    if (phone.trim().isEmpty) {
      return 'El número de teléfono es requerido';
    }

    final numericRegex = RegExp(r'^[0-9]{10,15}$'); // Entre 10 y 15 dígitos

    if (!numericRegex.hasMatch(phone)) {
      return 'Número de teléfono inválido';
    }

    return null;
  }

  void _register() async {
    // Validar campos y mostrar errores si los hay
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final name = nameController.text;
    final phone = phoneController.text;

    setState(() {
      emailError = validateEmail(email);
      passwordError = validatePassword(password);
      confirmPasswordError = validateConfirmPassword(password, confirmPassword);
      nameError = validateNombre(name);
      phoneError = validatePhone(phone);
    });

    // Si hay errores, detener el proceso
    if (emailError != null ||
        passwordError != null ||
        confirmPasswordError != null ||
        nameError != null ||
        phoneError != null) {
      return;
    }

    try {
      // Intentar registrar al usuario
      await ref
          .read(authProvider.notifier)
          .registerWithEmail(
            email: email,
            password: password,
            name: name,
            phone: phone,
          );

      if (!mounted) return;
      // Limpiar campos y errores si fue exitoso
      setState(() {
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        nameController.clear();
        phoneController.clear();

        emailError = null;
        passwordError = null;
        confirmPasswordError = null;
        nameError = null;
        phoneError = null;
      });

      // Navegar a la pantalla de login
      context.go('/login');
    } catch (e) {
      // Mostrar error genérico (por ejemplo, de Firebase)
      final errorMessage = e.toString().replaceAll('Exception: ', '');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext contextf) {
    //final authProviders = ref.watch(authProvider);
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
                            'Crear cuenta',
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
                              'Crea una cuenta y explora IAmBiz',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 30),
                          CustomTextfield(
                            hint: "Nombre completo",
                            controller: nameController,
                            errorText: nameError,
                          ),
                          SizedBox(height: 20),
                          CustomTextfield(
                            hint: "Teléfono",
                            controller: phoneController,
                            errorText: phoneError,
                          ),
                          SizedBox(height: 20),
                          CustomTextfield(
                            hint: "Email",
                            controller: emailController,
                            errorText: emailError,
                          ),
                          SizedBox(height: 20),
                          CustomTextfield(
                            hint: "Password",
                            controller: passwordController,
                            obscureText: true,
                            errorText: passwordError,
                          ),
                          SizedBox(height: 20),
                          CustomTextfield(
                            hint: "Confirma Password",
                            controller: confirmPasswordController,
                            obscureText: true,
                            errorText: confirmPasswordError,
                          ),

                          SizedBox(height: 50),
                          CustomButton(
                            text: 'Registrarse',
                            isLarge: true,
                            onPressed: _register,
                          ),
                          SizedBox(height: 40),
                          InkWell(
                            onTap: () {
                              context.go('/login');
                            },
                            child: Text(
                              'Ya tienes una cuenta?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          SizedBox(height: 50),
                          Text(
                            'O continua con',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
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
