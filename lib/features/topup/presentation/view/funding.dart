import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/common/icon_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/constants/paystack_constant.dart';
import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

class Funding extends ConsumerStatefulWidget {
  const Funding({super.key});

  @override
  ConsumerState createState() => _FundingState();
}

class _FundingState extends ConsumerState<Funding> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _amount;
  late TextEditingController _message;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController();
    _message = TextEditingController();
  }

  String _generateTransactionReference() {
    return const Uuid().v4();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBarWidget.appbar(context, "Funding"),
            backgroundColor: Pallete.whiteColor,
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
                          AutoSizeText(
                            "Amount",
                            maxLines: 1,
                            style: context.bodySmall?.copyWith(
                              color: Pallete.blackColor,
                            ),
                          ),
                          const Gap(10),
                          TextFormField(
                            controller: _amount,
                            keyboardType: TextInputType.number,
                            decoration: StyleConstant.input.copyWith(
                              hintText: '100.00 - 2,450.00',
                              prefixIcon: const IconWidget(
                                iconData: FontAwesomeIcons.nairaSign,
                                color: Pallete.blackColor,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              double? enteredValue = double.tryParse(value);
                              if (enteredValue == null ||
                                  enteredValue < 100 ||
                                  enteredValue > 2450) {
                                return 'value must be 100 - 2,450';
                              }
                              return null;
                            },
                          ),
                          const Gap(40),
                          _message.text.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: AutoSizeText(_message.text,
                                      style: context.bodySmall
                                          ?.copyWith(color: Pallete.lightRed)),
                                )
                              : Container(),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var connectivityResult =
                                    await Connectivity().checkConnectivity();
                                if (connectivityResult ==
                                    ConnectivityResult.none) {
                                  setState(() {
                                    _message.text = 'No internet connection';
                                  });
                                  return;
                                }
                                try {
                                  setState(() {
                                    _message.clear();
                                  });

                                  final transactionReference =
                                      _generateTransactionReference();
                                  final email = ref
                                      .read(
                                          authControllerLoginProvider.notifier)
                                      .getCurrentUser()!
                                      .email!;
                                  final amountInDouble =
                                      double.parse(_amount.text);
                                  final amount =
                                      (amountInDouble * 100).toString();
                                  return await payWithPaystack(context,
                                      transactionReference:
                                          transactionReference,
                                      email: email,
                                      amount: amount);
                                } catch (e) {
                                  debugPrint(
                                      'Paystack payment error ${e.toString()}');
                                }
                              }
                            },
                            child: const Text(
                              'Pay with Paystack',
                            ),
                          ),
                          const Gap(20),
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
    _amount.dispose();
    _message.dispose();
    super.dispose();
  }
}

Future<void> payWithPaystack(BuildContext context,
    {required String transactionReference,
    required String email,
    required String amount}) async {
  return await FlutterPaystackPlus.openPaystackPopup(
      publicKey: PaystackConstant.testPublicKey,
      context: context,
      secretKey: PaystackConstant.testSecretKey,
      currency: 'NGN',
      customerEmail: email,
      amount: amount,
      reference: transactionReference,
      onClosed: () {
        debugPrint('Could\'nt finish payment');
      },
      onSuccess: () {
        debugPrint('Payment successful');
      });
}
