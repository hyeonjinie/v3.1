import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
// import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/main/main_contents_screen.dart';
import 'package:v3_mvp/widgets/responsive_safe_area/responsive_safe_area.dart';
import 'dart:typed_data';
import 'dart:ui';
import '../../../services/auth_provider.dart';
import '../../main/widget/footer/footer.dart';
import '../../utils/member_type.dart';
import '../../utils/notification_preference.dart';

class RegisterScreen extends StatefulWidget {
  final bool isRequiredTermsAgreed;
  final bool isPrivacyPolicyAgreed;
  final bool isEmailMarketingAgreed;
  final bool isSMSMarketingAgreed;

  RegisterScreen({
    required this.isRequiredTermsAgreed,
    required this.isPrivacyPolicyAgreed,
    required this.isEmailMarketingAgreed,
    required this.isSMSMarketingAgreed,
  });

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmFocusNode = FocusNode();
  final FocusNode _businessRegistrationNumberFocusNode = FocusNode();
  final FocusNode _companyNameFocusNode = FocusNode();
  final FocusNode _representativeNameFocusNode = FocusNode();
  final FocusNode _partnerCompanyFocusNode = FocusNode();
  final FocusNode _businessTypeFocusNode = FocusNode();
  final FocusNode _businessFieldFocusNode = FocusNode();
  final FocusNode _industryTypeFocusNode = FocusNode();
  final FocusNode _itemFocusNode = FocusNode();
  final FocusNode _businessAddressFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _companyTelFocusNode = FocusNode();
  final FocusNode _faxNumberFocusNode = FocusNode();
  final FocusNode _contactPersonNameFocusNode = FocusNode();
  final FocusNode _contactPersonPhoneNumberFocusNode = FocusNode();
  final FocusNode _contactPersonEmailFocusNode = FocusNode();
  final FocusNode _recommendingCompanyFocusNode = FocusNode();
  final FocusNode _accountNumberFocusNode = FocusNode();
  final FocusNode _bankNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeFocusNodes();
  }

  void _initializeFocusNodes() {
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
    _passwordConfirmFocusNode.addListener(() => setState(() {}));
    _businessRegistrationNumberFocusNode.addListener(() => setState(() {}));
    _companyNameFocusNode.addListener(() => setState(() {}));
    _representativeNameFocusNode.addListener(() => setState(() {}));
    _partnerCompanyFocusNode.addListener(() => setState(() {}));
    _businessTypeFocusNode.addListener(() => setState(() {}));
    _businessFieldFocusNode.addListener(() => setState(() {}));
    _industryTypeFocusNode.addListener(() => setState(() {}));
    _itemFocusNode.addListener(() => setState(() {}));
    _businessAddressFocusNode.addListener(() => setState(() {}));
    _phoneNumberFocusNode.addListener(() => setState(() {}));
    _companyTelFocusNode.addListener(() => setState(() {}));
    _faxNumberFocusNode.addListener(() => setState(() {}));
    _contactPersonNameFocusNode.addListener(() => setState(() {}));
    _contactPersonPhoneNumberFocusNode.addListener(() => setState(() {}));
    _contactPersonEmailFocusNode.addListener(() => setState(() {}));
    _recommendingCompanyFocusNode.addListener(() => setState(() {}));
    _accountNumberFocusNode.addListener(() => setState(() {}));
    _bankNameFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _disposeFocusNodes();
    super.dispose();
  }

  void _disposeFocusNodes() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
    _businessRegistrationNumberFocusNode.dispose();
    _companyNameFocusNode.dispose();
    _representativeNameFocusNode.dispose();
    _partnerCompanyFocusNode.dispose();
    _businessTypeFocusNode.dispose();
    _businessFieldFocusNode.dispose();
    _industryTypeFocusNode.dispose();
    _itemFocusNode.dispose();
    _businessAddressFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _companyTelFocusNode.dispose();
    _faxNumberFocusNode.dispose();
    _contactPersonNameFocusNode.dispose();
    _contactPersonPhoneNumberFocusNode.dispose();
    _contactPersonEmailFocusNode.dispose();
    _recommendingCompanyFocusNode.dispose();
    _accountNumberFocusNode.dispose();
    _bankNameFocusNode.dispose();
  }

  InputDecoration getDecoration(String labelText, FocusNode focusNode) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: focusNode.hasFocus
            ? const Color(0xFF505050)
            : Colors.grey, // 포커스 상태에 따른 색상 변경
      ),
      floatingLabelStyle: TextStyle(
        color:
        focusNode.hasFocus ? Colors.red : Colors.grey, // 포커스 상태에 따라 색상 변경
      ),
      fillColor: focusNode.hasFocus
          ? Colors.white
          : Color(0xFFD6D6D6).withOpacity(0.3),
      filled: true,
      border: focusNode.hasFocus
          ? OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF00AF66)),
        borderRadius: BorderRadius.circular(8),
      )
          : OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD6D6D6)),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD6D6D6)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF00AF66)),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  final _auth = FirebaseAuth.instance;
  final _memberTypeNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _businessRegistrationNumberController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _representativeNameController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _businessFieldController = TextEditingController();
  final _industryTypeController = TextEditingController();
  final _itemController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _companyTelController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _createDate = DateTime.now();

  final MemberType _memberType = MemberType(
    currentValue: '1',
    items: MemberType.getItems(),
  );
  final NotificationPreferences _notificationPreferences =
  NotificationPreferences();
  final _formKey = GlobalKey<FormState>();

  final _partnerCompanyController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _faxNumberController = TextEditingController();
  final _contactPersonNameController = TextEditingController();
  final _contactPersonPhoneNumberController = TextEditingController();
  final _contactPersonEmailController = TextEditingController();
  final _recommendingCompanyController = TextEditingController();
  final _paymentPreferencesController = TextEditingController();
  final _transactionHistoryController = TextEditingController();
  final _partnerCompanyIdController = TextEditingController();

  String _uploadedFileURL = '';
  DateTime? _modifiedDate;
  String? _modifiedBy;
  Uint8List? _businessLicenseImage;
  String? _businessLicenseImageName;

  bool _isLoading = false;

  Widget _businessLicenseImagePreview() {
    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF00AF66),
          width: 1, // 테두리 두께
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _businessLicenseImage != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          _businessLicenseImage!,
          fit: BoxFit.cover,
        ),
      )
          : const Center(
        child: Text(
          '미리보기 없음',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // 이미지 선택 함수
  // Future<void> _pickImage() async {
  //   final imageInfo = await ImagePickerWeb.getImageInfo;
  //   if (imageInfo?.data != null) {
  //     setState(() {
  //       _businessLicenseImage = imageInfo?.data;
  //       _businessLicenseImageName = imageInfo?.fileName;
  //       _uploadedFileURL = '';
  //     });
  //   }
  // }

  // 회원가입 및 이미지 업로드 함수
  void _register() async {
    if (!_isLoading &&
        _formKey.currentState!.validate() &&
        _businessLicenseImage != null) {
      setState(() {
        _isLoading = true; // 로딩 시작
      });

      try {
        final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final User? user = userCredential.user;

        if (user != null) {
          String fileName =
              'uploads/register/client/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_business_license';
          await FirebaseStorage.instance
              .ref(fileName)
              .putData(_businessLicenseImage!);
          String uploadedFileURL =
          await FirebaseStorage.instance.ref(fileName).getDownloadURL();

          await FirebaseFirestore.instance
              .collection('client')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'email': _emailController.text.trim(),
            'businessLicenseImageURL': uploadedFileURL,
            'memberType': _memberType.currentValue,
            'memberTypeName': _memberTypeNameController.text.trim(),
            'notificationPreferences': _notificationPreferences.preferences,
            'businessRegistrationNumber':
            _businessRegistrationNumberController.text.trim(),
            'companyName': _companyNameController.text.trim(),
            'representativeName': _representativeNameController.text.trim(),
            'partnerCompany': _partnerCompanyController.text,
            'businessType': _businessTypeController.text.trim(),
            'businessField': _businessFieldController.text.trim(),
            'industryType': _industryTypeController.text.trim(),
            'item': _itemController.text.trim(),
            'businessAddress': _businessAddressController.text.trim(),
            'phoneNumber': _phoneNumberController.text,
            'companyTelNumber': _companyTelController.text.trim(),
            'faxNumber': _faxNumberController.text,
            'contactPersonName': _contactPersonNameController.text,
            'contactPersonPhoneNumber':
            _contactPersonPhoneNumberController.text,
            'contactPersonEmail': _contactPersonEmailController.text,
            'recommendingCompany': _recommendingCompanyController.text,
            'accountNumber': _accountNumberController.text.trim(),
            'bankName': _bankNameController.text.trim(),
            'createDate': _createDate,
            'isAccepted': false,
          });

          // 등록된 사용자 정보를 설정하고 상태를 업데이트합니다.
          await context.read<AuthProviderService>().setUserAfterRegistration(user);

          // 회원가입 성공 후 홈 화면으로 이동
          if (mounted) {
            context.go('/');
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("이미 사용 중인 이메일입니다.")),
          );
        } else if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("약한 패스워드입니다.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("회원가입에 실패하였습니다. 관리자에게 문의하세요.")),
          );
        }
      } finally {
        setState(() {
          _isLoading = false; // 로딩 종료
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이미지를 선택해주세요.")),
      );
    }
  }

  String getCollectionPathBasedOnMemberType(String memberType) {
    switch (memberType) {
      case '1':
        return 'farmers'; // 농민
      case '2':
        return 'food_manufacturers'; // 식품제조가공업체
      case '3':
        return 'small_businesses'; // 소상공인
      default:
        return 'others'; // 기타
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '회원가입',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: <Widget>[
                          // Add your form fields here
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                labelText: '회원유형',
                                labelStyle: TextStyle(color: Color(0xFF505050)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF00AF66)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF00AF66)),
                                ),
                              ),
                              value: _memberType.currentValue,
                              items: _memberType.items,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _memberType.currentValue = newValue!;
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              decoration: getDecoration('이메일', _emailFocusNode),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@')) {
                                  return '유효한 이메일을 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              obscureText: true,
                              decoration: getDecoration('패스워드', _passwordFocusNode),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 6) {
                                  return '패스워드는 6자 이상이어야 합니다.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _passwordConfirmController,
                              focusNode: _passwordConfirmFocusNode,
                              obscureText: true,
                              decoration: getDecoration(
                                  '패스워드 확인', _passwordConfirmFocusNode),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return '패스워드가 일치하지 않습니다.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _businessRegistrationNumberController,
                              focusNode: _businessRegistrationNumberFocusNode,
                              decoration: getDecoration(
                                  '사업자 등록번호', _businessRegistrationNumberFocusNode),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '사업자 등록번호를 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              children: [
                                // ElevatedButton(
                                //   style: ElevatedButton.styleFrom(
                                //     foregroundColor: Colors.white,
                                //     backgroundColor: Color(0xFF00AF66),
                                //   ),
                                //   onPressed: _pickImage,
                                //   child: const Text('사업자 등록증 선택',
                                //       style:
                                //       TextStyle(fontWeight: FontWeight.bold)),
                                // ),
                                Spacer(),
                                Container(
                                    margin: const EdgeInsets.only(left: 16.0),
                                    child: _businessLicenseImagePreview()),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _companyNameController,
                              focusNode: _companyNameFocusNode,
                              decoration:
                              getDecoration('회사명', _companyNameFocusNode),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '회사명을 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _representativeNameController,
                              focusNode: _representativeNameFocusNode,
                              decoration: getDecoration(
                                  '대표자명', _representativeNameFocusNode),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '대표자명을 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _businessTypeController,
                              focusNode: _businessTypeFocusNode,
                              decoration:
                              getDecoration('업태', _businessTypeFocusNode),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '업태를 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _businessFieldController,
                              focusNode: _businessFieldFocusNode,
                              decoration:
                              getDecoration('업종', _businessFieldFocusNode),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '업종을 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _itemController,
                              focusNode: _itemFocusNode,
                              decoration: getDecoration('종목', _itemFocusNode),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '종목을 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _businessAddressController,
                              focusNode: _businessAddressFocusNode,
                              decoration: getDecoration(
                                  '사업장 주소', _businessAddressFocusNode),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '사업장 주소를 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _companyTelController,
                              focusNode: _companyTelFocusNode,
                              decoration:
                              getDecoration('전화번호', _companyTelFocusNode),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '전화번호를 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _contactPersonNameController,
                              focusNode: _contactPersonNameFocusNode,
                              decoration: getDecoration(
                                  '담당자명', _contactPersonNameFocusNode),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _contactPersonPhoneNumberController,
                              focusNode: _contactPersonPhoneNumberFocusNode,
                              decoration: getDecoration(
                                  '담당자 전화번호', _contactPersonPhoneNumberFocusNode),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _contactPersonEmailController,
                              focusNode: _contactPersonEmailFocusNode,
                              decoration: getDecoration(
                                  '담당자 이메일', _contactPersonEmailFocusNode),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _accountNumberController,
                              focusNode: _accountNumberFocusNode,
                              decoration:
                              getDecoration('계좌번호', _accountNumberFocusNode),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '계좌번호를 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 50.0),
                            child: TextFormField(
                              controller: _bankNameController,
                              focusNode: _bankNameFocusNode,
                              decoration: getDecoration('은행명', _bankNameFocusNode),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '은행명을 입력해주세요.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 80.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 32.0),
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFF00AF66),
                              ),
                              onPressed: _isLoading ? null : _register,
                              // 로딩 중이면 버튼 비활성화
                              child: const Text('회원가입',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800, fontSize: 20)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _isLoading
                      ? Container(
                    color: Colors.grey.withOpacity(0.3), // 반투명한 배경
                    child: BackdropFilter(
                      filter:
                      ImageFilter.blur(sigmaX: 3, sigmaY: 3), // 블러 효과 적용
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                      : SizedBox.shrink(),
                ],
              ),
              if (kIsWeb) CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
