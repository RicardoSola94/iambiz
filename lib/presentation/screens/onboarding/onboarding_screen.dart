import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/config.dart';
import 'package:iambiz/presentation/screens/widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                SizedBox(width: double.infinity, height: 60),
                Image.asset(
                  'assets/images/inicio.png',
                  fit: BoxFit.cover,
                  height: 350,
                  width: 350,
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Impulsa tu negocio con IAmBiz",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Organiza tus servicios, cotizaciones, inventario y finanzas desde una sola app fácil de usar.",

                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 120),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: "Login",
                      onPressed: () {
                        context.go('/login');
                      },
                    ),
                    SizedBox(width: 20),
                    CustomButton(
                      text: "Register",
                      isTransparent: true,
                      onPressed: () {
                        context.go('/create-account');
                      },
                    ),
                  ],
                ),
                //Image.asset('assets/images/office.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
