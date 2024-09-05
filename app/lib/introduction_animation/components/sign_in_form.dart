import 'package:a_strong/Models/model.dart';
import 'package:a_strong/fitness_app/fitness_app_home_screen.dart';
import 'package:a_strong/introduction_animation/components/custom_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rive/rive.dart';

class SignInForm extends StatefulWidget {

  const SignInForm({
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void signIn(BuildContext context, Usuario usuario) {
    print(usuario.toJson());
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (_formKey.currentState!.validate()) {
        // show success
        check.fire();
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isShowLoading = false;
          });
          confetti.fire();
          Future.delayed(const Duration(seconds: 1), () async {
            // TODO: Save email to shared preferences
            final prefs = await SharedPreferences.getInstance();
            // El usuario que recibo, lo convierto a base64
            prefs.setString('Usuario', usuario.toBase64());
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
              builder: (_) => FitnessAppHomeScreen()),
              (route) => false
            );
          });
        });
      } else {
        error.fire();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuario = Usuario();
    return Stack(
      children: [
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInput(
                  label: "Username",
                  icon: CupertinoIcons.person,
                  initialValue: "",
                  callback: (username) {
                    setState(() {
                      usuario.username = username;
                    });
                  },
                ),
                CustomInput(
                  label: "Email",
                  icon: CupertinoIcons.mail,
                  initialValue: "",
                  keyboardType: TextInputType.emailAddress,
                  callback: (email) {
                    setState(() {
                      usuario.email = email;
                    });
                  },
                ),
                CustomInput(
                  label: 'Meta de peso (lb)',
                  icon: CupertinoIcons.person,
                  initialValue: 70,
                  keyboardType: TextInputType.number,
                  callback: (metaPeso) {
                    setState(() {
                      // Check if the value is a number
                      if (num.tryParse(metaPeso) == null) {
                        metaPeso = "0";
                        return;
                      }
                      usuario.metaPeso = num.parse(metaPeso);
                    });
                  },
                ),
                CustomInput(
                  label: 'Meta de porcentaje de grasa (%)',
                  icon: CupertinoIcons.person,
                  initialValue: 15,
                  keyboardType: TextInputType.number,
                  callback: (metaPorcentajeGrasa) {
                    setState(() {
                      // Check if the value is a number
                      if (num.tryParse(metaPorcentajeGrasa) == null) {
                        metaPorcentajeGrasa = "0";
                        return;
                      }
                      usuario.metaPorcentajeGrasa = num.parse(metaPorcentajeGrasa);
                    });
                  },
                ),
                CustomInput(
                  label: 'Meta de calorias diarias',
                  icon: CupertinoIcons.person,
                  initialValue: 2000,
                  keyboardType: TextInputType.number,
                  callback: (metaCaloriasDiarias) {
                    setState(() {
                      // Check if the value is a number
                      if (num.tryParse(metaCaloriasDiarias) == null) {
                        metaCaloriasDiarias = "0";
                        return;
                      }
                      usuario.metaCaloriasDiarias = num.parse(metaCaloriasDiarias);
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        _formKey.currentState!.save();
                        signIn(context, usuario);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 41, 41, 41),
                          minimumSize: const Size(double.infinity, 56),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25)))),
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        color: Color.fromARGB(255, 238, 238, 238),
                      ),
                      label: const Text("Confirmar data", style: TextStyle(color: Color.fromARGB(255, 238, 238, 238)))),
                )
              ],
            ))
        ,
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                "assets/RiveAssets/check.riv",
                onInit: (artboard) {
                  StateMachineController controller =
                      getRiveController(artboard);
                  check = controller.findSMI("Check") as SMITrigger;
                  error = controller.findSMI("Error") as SMITrigger;
                  reset = controller.findSMI("Reset") as SMITrigger;
                },
              ))
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                child: Transform.scale(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: (artboard) {
                    StateMachineController controller =
                        getRiveController(artboard);
                    confetti =
                        controller.findSMI("Trigger explosion") as SMITrigger;
                  },
                ),
              ))
            : const SizedBox()
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
