import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:survey_stunting/consts/colors.dart';
import 'package:survey_stunting/controllers/login_controller.dart';
import 'package:survey_stunting/routes/route_name.dart';

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
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  const Text(
                    "Username",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Username",
                      hintStyle: const TextStyle(color: kHintColor),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SvgPicture.asset(
                          "assets/icons/bold/sms.svg",
                        ),
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minHeight: 12,
                        minWidth: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).hintColor.withAlpha(20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  TextFormField(
                    // focusNode: loginController.usernameNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(color: kHintColor),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/bold/eye.svg",
                        ),
                        onPressed: () {},
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minHeight: 12,
                        minWidth: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).hintColor.withAlpha(20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(RouteName.layout);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Theme.of(context).primaryColor,
                          elevation: 8,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14)),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
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
