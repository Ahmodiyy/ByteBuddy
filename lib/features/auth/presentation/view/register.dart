import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/common.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:bytebuddy/features/auth/presentation/widget/functions.dart';
import 'package:bytebuddy/features/auth/presentation/widget/header_text_widget.dart';
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
final toggleConfirmPasswordProvider = StateProvider<bool>((ref) {
  return true;
});

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _confirmPassword;
  late TextEditingController _message;

  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _message = TextEditingController();
    _tapGestureRecognizer = TapGestureRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    final togglePassword = ref.watch(togglePasswordProvider);
    final toggleConfirmPassword = ref.watch(toggleConfirmPasswordProvider);
    ref.listen(
      authControllerRegisterProvider,
      (previous, next) {
        next.when(
          data: (data) {
            context.push("/auth");
          },
          error: (error, stackTrace) {
            RegExp regExp = RegExp(r'\[.*?\]');
            String cleanedMessage = error.toString().replaceAll(regExp, '');
            _message.text = cleanedMessage.trim();
          },
          loading: () {},
        );
      },
    );
    final state = ref.watch(authControllerRegisterProvider);
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
                      width: constraints.isMobile ? double.infinity : 400.0,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Gap(40),
                                const HeaderTextWidget(
                                  headerTextString: 'Create an \naccount',
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
                                TextFormField(
                                  controller: _password,
                                  obscureText: togglePassword,
                                  keyboardType: TextInputType.text,
                                  decoration: StyleConstant.input.copyWith(
                                    hintText: 'Password',
                                    prefixIcon: const IconWidget(
                                      iconData: FontAwesomeIcons.lock,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () => ref
                                          .read(togglePasswordProvider.notifier)
                                          .update((state) => !state),
                                      child: togglePassword
                                          ? const IconWidget(
                                              iconData:
                                                  FontAwesomeIcons.eyeSlash)
                                          : const IconWidget(
                                              iconData: FontAwesomeIcons.eye),
                                    ),
                                  ),
                                  validator: (value) {
                                    return validatePassword(value);
                                  },
                                ),
                                const Gap(20),
                                TextFormField(
                                  controller: _confirmPassword,
                                  obscureText: toggleConfirmPassword,
                                  keyboardType: TextInputType.text,
                                  decoration: StyleConstant.input.copyWith(
                                    hintText: 'Confirm password',
                                    prefixIcon: const IconWidget(
                                      iconData: FontAwesomeIcons.lock,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () => ref
                                          .read(toggleConfirmPasswordProvider
                                              .notifier)
                                          .update((state) => !state),
                                      child: toggleConfirmPassword
                                          ? const IconWidget(
                                              iconData:
                                                  FontAwesomeIcons.eyeSlash)
                                          : const IconWidget(
                                              iconData: FontAwesomeIcons.eye),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm password';
                                    }
                                    if (_password.text !=
                                        _confirmPassword.text) {
                                      return "Password does not match";
                                    }
                                    return null;
                                  },
                                ),
                                const Gap(20),
                                _message.text.isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: AutoSizeText(_message.text,
                                            style: context.bodySmall?.copyWith(
                                                color: Pallete.errorColor)),
                                      )
                                    : Container(),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'By clicking the ',
                                      style: context.bodySmall,
                                    ),
                                    TextSpan(
                                      recognizer: _tapGestureRecognizer
                                        ..onTap = () {},
                                      text: 'Sign Up ',
                                      style: context.bodySmall?.copyWith(
                                          color: Pallete.primaryColor),
                                    ),
                                    TextSpan(
                                      text: 'button, ',
                                      style: context.bodySmall,
                                    ),
                                    TextSpan(
                                      text: 'you agree to our ',
                                      style: context.bodySmall,
                                    ),
                                    TextSpan(
                                      recognizer: _tapGestureRecognizer
                                        ..onTap = () {},
                                      text: 'Terms & Condition ',
                                      style: context.bodySmall?.copyWith(
                                        color: Pallete.primaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ]),
                                ),
                                const Gap(20),
                                ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          _message.clear();
                                          if (_formKey.currentState!
                                              .validate()) {
                                            ref
                                                .read(
                                                    authControllerRegisterProvider
                                                        .notifier)
                                                .signUp(
                                                    email: _email.text,
                                                    password: _password.text);
                                          }
                                        },
                                  child: const Text(
                                    'Sign up',
                                  ),
                                ),
                                const Gap(20),
                                Center(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: 'Already have an account ',
                                        style: context.bodySmall,
                                      ),
                                      TextSpan(
                                        recognizer: _tapGestureRecognizer
                                          ..onTap = () {
                                            context.push("/auth");
                                          },
                                        text: 'Sign in',
                                        style: context.bodySmall?.copyWith(
                                            color: Pallete.primaryColor),
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
                ),
              );
      },
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _message.dispose();
    _tapGestureRecognizer.dispose();
    super.dispose();
  }
}
