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

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _email;
  late TextEditingController _errorMessage;
  late TextEditingController _successMessage;

  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _errorMessage = TextEditingController();
    _successMessage = TextEditingController();
    _tapGestureRecognizer = TapGestureRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      authControllerResetPasswordProvider,
      (previous, next) {
        next.when(
          data: (data) {
            _successMessage.text = 'check your inbox to reset your password';
          },
          error: (error, stackTrace) {
            RegExp regExp = RegExp(r'\[.*?\]');
            String cleanedMessage = error.toString().replaceAll(regExp, '');
            _errorMessage.text = cleanedMessage.trim();
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
                                headerTextString: 'Forgot \nPassword?',
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
                              _errorMessage.text.isNotEmpty
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: AutoSizeText(_errorMessage.text,
                                          style: context.bodySmall?.copyWith(
                                              color: Pallete.errorColor)),
                                    )
                                  : Container(),
                              _successMessage.text.isNotEmpty
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: AutoSizeText(_successMessage.text,
                                          style: context.bodySmall?.copyWith(
                                              color: Pallete.primaryColor)),
                                    )
                                  : Container(),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: '*',
                                    style: context.bodySmall
                                        ?.copyWith(color: Pallete.primaryColor),
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
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        _errorMessage.clear();
                                        _successMessage.clear();
                                        if (_formKey.currentState!.validate()) {
                                          ref
                                              .read(
                                                  authControllerResetPasswordProvider
                                                      .notifier)
                                              .sendPasswordResetEmail(
                                                  _email.text);
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
    _errorMessage.dispose();
    _successMessage.dispose();
    _tapGestureRecognizer.dispose();
    super.dispose();
  }
}
