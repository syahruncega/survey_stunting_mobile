import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/controllers/login_controller.dart';

class LoginBody extends StatelessWidget {
  LoginBody({Key? key}) : super(key: key);
  final loginController = Get.find<LoginController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.13,
                    child: SvgPicture.asset("assets/icons/undraw_hello.svg"),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Center(
                    child: Text(
                      "Login untuk melanjutkan",
                      style: GoogleFonts.kodchasan(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Obx(
                    () => FilledTextField(
                      title: "Nama Pengguna",
                      hintText: "Nama Pengguna",
                      errorText: loginController.usernameError.value,
                      controller: loginController.username,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SvgPicture.asset(
                          "assets/icons/bold/sms.svg",
                          color: Theme.of(context).primaryColor.withAlpha(125),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Obx(
                    () => FilledTextField(
                      title: "Kata Sandi",
                      hintText: "Kata Sandi",
                      errorText: loginController.passwordError.value,
                      controller: loginController.password,
                      obsecureText: !loginController.showPassword.value,
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(
                          loginController.showPassword.value
                              ? "assets/icons/bold/eye.svg"
                              : "assets/icons/bold/eye-slash.svg",
                          color: Theme.of(context).primaryColor.withAlpha(125),
                        ),
                        onPressed: () => loginController.showPassword.value =
                            !loginController.showPassword.value,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Center(
                    child: ElevatedButton(
                      onPressed: loginController.login,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Theme.of(context).colorScheme.primary,
                          elevation: 8,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14)),
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
