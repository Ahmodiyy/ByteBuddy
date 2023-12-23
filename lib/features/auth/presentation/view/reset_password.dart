import 'package:bytebuddy/common/loading_widget.dart';
import 'package:bytebuddy/common/message_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:bytebuddy/features/auth/presentation/widget/functions.dart';
import 'package:bytebuddy/features/auth/presentation/widget/header_text_widget.dart';
import 'package:bytebuddy/features/auth/presentation/widget/icon_widget.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

final togglePasswordProvider = StateProvider<bool>((ref) {
  return true;
});

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _email;

  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _tapGestureRecognizer = TapGestureRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      authControllerResetPasswordProvider,
      (previous, next) {
        next.when(
          data: (data) {
            MessageWidget.showSnackBar(
                context, "check your inbox to reset your password");
          },
          error: (error, stackTrace) {
            MessageWidget.showSnackBar(context, error.toString());
          },
          loading: () {},
        );
      },
    );
    final state = ref.watch(authControllerResetPasswordProvider);
    final isLoading = state is AsyncLoading;
    return LayoutBuilder(
      builder: (context, constraints) {
        return isLoading
            ? const LoadingWidget()
            : Scaffold(
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: constraints.isMobile ? double.infinity : 500.0,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Gap(40),
                              const HeaderTextWidget(
                                headerTextString: 'Forgot \nPassword?',
                              ),
                              const Gap(40),
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: StyleConstant.input.copyWith(
                                  hintText: 'Email Address',
                                  prefixIcon: const IconWidget(
                                    iconData: FontAwesomeIcons.user,
                                  ),
                                ),
                                validator: (value) {
                                  return validateEmail(value);
                                },
                              ),
                              const Gap(20),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: '*',
                                    style: context.bodySmall
                                        ?.copyWith(color: Pallete.greenColor),
                                  ),
                                  TextSpan(
                                    text:
                                        'We will send you a message to reset your password',
                                    style: context.bodySmall,
                                  ),
                                ]),
                              ),
                              const Gap(20),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ref
                                        .read(
                                            authControllerResetPasswordProvider
                                                .notifier)
                                        .sendPasswordResetEmail(_email.text);
                                  }
                                },
                                child: const Text(
                                  'Send',
                                ),
                              ),
                              const Gap(20),
                              Center(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      recognizer: _tapGestureRecognizer
                                        ..onTap = () {
                                          context.pop();
                                        },
                                      text: 'Go back!',
                                      style: context.bodySmall
                                          ?.copyWith(color: Pallete.greenColor),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _tapGestureRecognizer.dispose();
    super.dispose();
  }
}
