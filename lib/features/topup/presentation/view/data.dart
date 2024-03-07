import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/common.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/topup/model/data_purchase_model.dart';
import 'package:bytebuddy/features/topup/model/data_service_model.dart';
import 'package:bytebuddy/features/topup/presentation/controller/data_controller.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

final serviceIDProvider = StateProvider<String>((ref) {
  return 'mtn_sme';
});

class Data extends ConsumerStatefulWidget {
  const Data({super.key});

  @override
  ConsumerState createState() => _DataState();
}

class _DataState extends ConsumerState<Data> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController numberController = TextEditingController();
  List<Map<String, String>> dropdownItems = [
    {'value': 'mtn_sme', 'image': ImageConstant.mtn},
    {'value': 'airtel_cg', 'image': ImageConstant.airtel},
    {'value': 'glo_data', 'image': ImageConstant.glo},
    {'value': 'etisalat_data', 'image': ImageConstant.nineMobile},
    // Add more images as needed
  ];

  @override
  Widget build(BuildContext context) {
    final networkData = ref.watch(serviceIDProvider);
    final dataServiceModelStatus = ref.watch(dataControllerProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget.appbar(context, "Data"),
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.isMobile) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      color: Pallete.secondaryColor,
                      child: Row(
                        children: [
                          DropdownButton(
                            value: networkData,
                            elevation: 0,
                            underline: Container(),
                            itemHeight: 50,
                            items: dropdownItems.map((item) {
                              return DropdownMenuItem(
                                value: item['value'],
                                child: Row(
                                  children: [
                                    ClipOval(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Image.asset(
                                          item['image']!,
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              ref
                                  .read(serviceIDProvider.notifier)
                                  .update((state) => value!);
                              ref.invalidate(dataControllerProvider);
                            },
                          ),
                          const Gap(10),
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: numberController,
                                keyboardType: TextInputType.number,
                                decoration: StyleConstant.input.copyWith(
                                  hintText: 'Phone number',
                                  fillColor: Pallete.tertiaryColor,
                                ),
                                validator: (value) {
                                  return value?.length == 11
                                      ? null
                                      : "input valid number";
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 40),
                        child: dataServiceModelStatus.when(
                          data: (data) => Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Pallete.secondaryColor,
                              borderRadius: BorderRadius.circular(
                                  15.0), // Adjust the corner radius as needed
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(
                                  data.service,
                                  textAlign: TextAlign.center,
                                  style: context.bodySmall?.copyWith(),
                                ),
                                const Gap(10),
                                GridDataWidget(
                                  dataServiceModel: data,
                                  formKey: _formKey,
                                  numberController: numberController,
                                ),
                              ],
                            ),
                          ),
                          error: (error, stackTrace) => AutoSizeText(
                              error.toString(),
                              textAlign: TextAlign.center),
                          loading: () => const CircularProgressIndicator(
                              color: Pallete.primaryColor),
                        )),
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        color: Pallete.secondaryColor,
                        child: Row(
                          children: [
                            DropdownButton(
                              value: networkData,
                              elevation: 0,
                              underline: Container(),
                              itemHeight: 50,
                              items: dropdownItems.map((item) {
                                return DropdownMenuItem(
                                  value: item['value'],
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Image.asset(
                                            item['image']!,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                ref
                                    .read(serviceIDProvider.notifier)
                                    .update((state) => value!);
                                ref.invalidate(dataControllerProvider);
                              },
                            ),
                            const Gap(10),
                            Expanded(
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: numberController,
                                  keyboardType: TextInputType.number,
                                  decoration: StyleConstant.input.copyWith(
                                    fillColor: Pallete.tertiaryColor,
                                    hintText: 'Phone number',
                                  ),
                                  validator: (value) {
                                    return value?.length == 11
                                        ? null
                                        : "input valid number";
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      flex: 3,
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 40),
                          child: dataServiceModelStatus.when(
                            data: (data) => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Pallete.secondaryColor,
                                borderRadius: BorderRadius.circular(
                                    15.0), // Adjust the corner radius as needed
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AutoSizeText(
                                    data.service,
                                    textAlign: TextAlign.center,
                                    style: context.bodySmall?.copyWith(),
                                  ),
                                  const Gap(10),
                                  GridDataWidget(
                                    dataServiceModel: data,
                                    formKey: _formKey,
                                    numberController: numberController,
                                  ),
                                ],
                              ),
                            ),
                            error: (error, stackTrace) => AutoSizeText(
                                error.toString(),
                                textAlign: TextAlign.center),
                            loading: () => const Center(
                              child: CircularProgressIndicator(
                                  color: Pallete.primaryColor),
                            ),
                          )),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GridDataWidget extends ConsumerWidget {
  final DataServiceModel dataServiceModel;
  final GlobalKey<FormState> formKey;
  final TextEditingController numberController;
  const GridDataWidget(
      {super.key,
      required this.dataServiceModel,
      required this.formKey,
      required this.numberController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          mainAxisExtent: 120),
      itemCount: dataServiceModel.plans.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (formKey.currentState!.validate()) {
              context.go('/dashboard/checkout',
                  extra: DataPurchaseModel(
                    service: dataServiceModel.service,
                    serviceID: ref.read(serviceIDProvider),
                    planIndex: index,
                    number: numberController.text,
                    dataPlan: dataServiceModel.plans[index],
                  ));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Pallete.backgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 100.0,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: AutoSizeText(
                      dataServiceModel.plans[index].displayName,
                      textAlign: TextAlign.center,
                      style: context.bodyMedium?.copyWith(
                          color: Pallete.textColor,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AutoSizeText(
                      '\u20A6${dataServiceModel.plans[index].price}',
                      textAlign: TextAlign.center,
                      style: context.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Pallete.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
