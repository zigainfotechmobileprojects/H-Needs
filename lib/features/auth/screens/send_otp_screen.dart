import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:hneeds_user/common/enums/footer_type_enum.dart';
import 'package:hneeds_user/common/models/config_model.dart';
import 'package:hneeds_user/common/widgets/custom_app_bar_widget.dart';
import 'package:hneeds_user/common/widgets/custom_button_widget.dart';
import 'package:hneeds_user/common/widgets/custom_pop_scope_widget.dart';
import 'package:hneeds_user/common/widgets/custom_text_field_widget.dart';
import 'package:hneeds_user/common/widgets/footer_web_widget.dart';
import 'package:hneeds_user/common/widgets/web_app_bar_widget.dart';
import 'package:hneeds_user/features/auth/domain/enums/verification_type_enum.dart';
import 'package:hneeds_user/features/auth/domain/enums/from_page_enum.dart';
import 'package:hneeds_user/features/auth/domain/models/user_log_data.dart';
import 'package:hneeds_user/features/auth/providers/auth_provider.dart';
import 'package:hneeds_user/features/auth/providers/verification_provider.dart';
import 'package:hneeds_user/features/auth/widgets/social_login_widget.dart';
import 'package:hneeds_user/features/splash/providers/splash_provider.dart';
import 'package:hneeds_user/helper/auth_helper.dart';
import 'package:hneeds_user/helper/custom_snackbar_helper.dart';
import 'package:hneeds_user/helper/phone_number_checker_helper.dart';
import 'package:hneeds_user/helper/responsive_helper.dart';
import 'package:hneeds_user/localization/language_constrants.dart';
import 'package:hneeds_user/utill/dimensions.dart';
import 'package:hneeds_user/utill/images.dart';
import 'package:hneeds_user/utill/styles.dart';
import 'package:provider/provider.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});


  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {

  String? countryCode;
  TextEditingController? _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();

    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final AuthProvider authProvider =  Provider.of<AuthProvider>(context, listen: false);

    UserLogData? userData = authProvider.getUserData();
    if(userData != null && userData.loginType == FromPage.otp.name) {
      if(userData.phoneNumber != null){
        _phoneNumberController!.text = PhoneNumberCheckerHelper.getPhoneNumber(userData.phoneNumber ?? '', userData.countryCode ?? '') ?? '';
      }
      countryCode ??= "+${userData.countryCode}";
      print('-------------(COUNTRY CODE IN USER)-----------$countryCode');
    }else{
      countryCode ??= CountryCode.fromCountryCode(configModel.countryCode!).dialCode;
      print('-------------(COUNTRY CODE)-----------$countryCode');
    }

  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    print("------------------------ ROUTE IS ${ModalRoute.of(context)?.settings.name}");

    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) : PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: CustomAppBarWidget(
            isBackButtonExist: true,
            title: '',
            onBackPressed: (){
              if(Navigator.canPop(context)){
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: CustomScrollView(slivers: [

              SliverToBoxAdapter(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                if(ResponsiveHelper.isDesktop(context))
                  SizedBox(height: size.width * 0.02),

                Center(child: Container(
                  width: size.width > 700 ? 450 : size.width,
                  margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                  padding: size.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                  decoration: size.width > 700 ? BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.07),
                        blurRadius: 30,
                        spreadRadius: 0,
                        offset: const Offset(0,10),
                      )
                    ],
                  ) : null,
                  child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                    SizedBox(height: ResponsiveHelper.isDesktop(context) ? size.height * 0.02 : size.height * 0.14),

                    if(!ResponsiveHelper.isDesktop(context))...[
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Image.asset(
                          Images.logo, height: ResponsiveHelper.isDesktop(context)
                            ? MediaQuery.of(context).size.height * 0.15
                            : MediaQuery.of(context).size.height / 4.5,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ],
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Text(getTranslated('login', context),
                      style: rubikBold.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: Theme.of(context).textTheme.bodyMedium?.color
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),



                    Row(children: [

                      Expanded(child: Container()),

                      Expanded(flex: 7, child: Column(children: [

                        CustomTextFieldWidget(
                          countryDialCode: countryCode,
                          onCountryChanged: (CountryCode value) => countryCode = value.dialCode,
                          hintText: getTranslated('number_hint', context),
                          isShowBorder: true,
                          controller: _phoneNumberController,
                          inputType: TextInputType.phone,
                          title: getTranslated('mobile_number', context),
                        ),
                        SizedBox(height: size.height * 0.03),

                        Consumer<AuthProvider>(builder: (context, authProvider, child) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: ()=> authProvider.toggleRememberMe(),
                            child: Row(children: [

                              Container(width: 18, height: 18,
                                decoration: BoxDecoration(
                                  color: authProvider.isActiveRememberMe ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                  border: Border.all(color: authProvider.isActiveRememberMe ? Colors.transparent : Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: authProvider.isActiveRememberMe
                                    ? const Icon(Icons.done, color: Colors.white, size: 17)
                                    : const SizedBox.shrink(),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Text(getTranslated('remember_me', context),
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),

                            ]),
                          );
                        }),
                        SizedBox(height: size.height * 0.03),

                        Selector<VerificationProvider, bool>(
                          selector: (context, verificationProvider) => verificationProvider.isLoading,
                          builder: (context, isLoading, child) {
                            return CustomButtonWidget(
                              isLoading: isLoading,
                              btnTxt: getTranslated('get_otp', context),
                              onTap: () async {

                                final VerificationProvider verificationProvider= context.read<VerificationProvider>();

                                if (_phoneNumberController!.text.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                }else {
                                  String phoneWithCountryCode = countryCode! + _phoneNumberController!.text.trim();
                                  if(PhoneNumberCheckerHelper.isPhoneValidWithCountryCode(phoneWithCountryCode)){
                                    if(AuthHelper.isPhoneVerificationEnable(configModel)){
                                      print("-----------(SEND)-----Phone Number With Country Code $phoneWithCountryCode");
                                      print("-----------(SEND)-----VerificationType ${VerificationType.phone.name}");
                                      print("-----------(SEND)-----FromPage ${FromPage.otp.name}");
                                      await verificationProvider.sendVerificationCode(context,
                                          configModel, phoneWithCountryCode, type: VerificationType.phone.name,
                                          fromPage: FromPage.otp.name
                                      );
                                    }
                                  }else{
                                    showCustomSnackBar(getTranslated('invalid_phone_number', context), context);
                                  }

                                }
                              },
                            );
                        },),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        if(AuthHelper.isSocialMediaLoginEnable(configModel) && !AuthHelper.isManualLoginEnable(configModel))...[
                          Center(child: Text(
                            getTranslated('or', context),
                            style: rubikRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).hintColor,
                            ),
                          )),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          const SocialLoginWidget(),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                        ],

                      ])),

                      Expanded(child: Container()),

                    ]),

                    // if(configModel.isGuestCheckout == true && !Navigator.canPop(context))...[
                    //   Center(child: InkWell(
                    //     onTap: () => Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getMainRoute(), (route) => false),
                    //     child: RichText(text: TextSpan(children: [
                    //
                    //       TextSpan(text: '${getTranslated('continue_as_a', context)} ',
                    //         style: poppinsRegular.copyWith(
                    //           fontSize: Dimensions.fontSizeSmall,
                    //           color: Theme.of(context).hintColor,
                    //         ),
                    //       ),
                    //
                    //       TextSpan(text: getTranslated('guest', context),
                    //         style: poppinsRegular.copyWith(
                    //           color: Theme.of(context).colorScheme.onSurface,
                    //         ),
                    //       ),
                    //
                    //     ])),
                    //   )),
                    // ],

                  ])),
                )),

                if(ResponsiveHelper.isDesktop(context))
                  SizedBox(height: size.width * 0.02),

              ]))),

              if(ResponsiveHelper.isDesktop(context)) const SliverFillRemaining(
                hasScrollBody: false,
                child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [

                  SizedBox(height: Dimensions.paddingSizeLarge),
                  FooterWebWidget(footerType: FooterType.nonSliver),

                ]),
              ),

            ]),
          ),
        ),
      ),
    );
  }
}
