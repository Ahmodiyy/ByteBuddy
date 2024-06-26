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

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _message;

  late TapGestureRecognizer _tapGestureRecognizer;
  late TapGestureRecognizer _resetTapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _message = TextEditingController();

    _tapGestureRecognizer = TapGestureRecognizer();
    _resetTapGestureRecognizer = TapGestureRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    final togglePassword = ref.watch(togglePasswordProvider);
    ref.listen(
      authControllerLoginProvider,
      (previous, next) {
        next.when(
          data: (data) async {
            context.go("/dashboard");
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

    final state = ref.watch(authControllerLoginProvider);
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Gap(40),
                              const HeaderTextWidget(
                                headerTextString: 'Welcome \nback!',
                              ),
                              const Gap(40),
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                style: context.bodySmall?.copyWith(color: Pallete.textColor),
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
                                style: context.bodySmall?.copyWith(color: Pallete.textColor),
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
                                            iconData: FontAwesomeIcons.eyeSlash)
                                        : const IconWidget(
                                            iconData: FontAwesomeIcons.eye),
                                  ),
                                ),
                                validator: (value) {
                                  return validatePassword(value);
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        recognizer: _resetTapGestureRecognizer
                                          ..onTap = () {
                                            context.push("/auth/resetPassword");
                                          },
                                        text: 'Forgot Password?',
                                        style: context.bodySmall?.copyWith(
                                            color: Pallete.primaryColor),
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                              const Gap(40),
                              ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        _message.clear();
                                        if (_formKey.currentState!.validate()) {
                                          ref
                                              .read(authControllerLoginProvider
                                                  .notifier)
                                              .signIn(
                                                  email: _email.text,
                                                  password: _password.text);
                                        }
                                      },
                                child: const Text(
                                  'Sign in',
                                ),
                              ),
                              const Gap(20),
                              Center(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Don\'t have an account ',
                                      style: context.bodySmall,
                                    ),
                                    TextSpan(
                                      recognizer: _tapGestureRecognizer
                                        ..onTap = () {
                                          context.push("/auth/register");
                                        },
                                      text: 'Sign up',
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
              );
      },
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _message.dispose();
    _tapGestureRecognizer.dispose();
    _resetTapGestureRecognizer.dispose();
    super.dispose();
  }
}
