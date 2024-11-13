import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:v3_mvp/services/auth_provider.dart';
import 'package:v3_mvp/widgets/responsive_safe_area/responsive_safe_area.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<Color> _buttonColor = ValueNotifier<Color>(Color(0xFFD5D5D5));

  @override
  void initState() {
    super.initState();
    emailController.addListener(_handleInputChange);
    passwordController.addListener(_handleInputChange);
  }

  void _handleInputChange() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      _buttonColor.value = Color(0xFF00AF66);
    } else {
      _buttonColor.value = Color(0xFFD5D5D5);
    }
  }

  void _login(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProviderService>(context, listen: false);
      print('Attempting to sign in...');
      await authProvider.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      print('Sign in successful.');

      // 로그인 성공 후 MainScreen으로 이동
      context.go('/');
    } catch (e) {
      print('Sign in failed with error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderService>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //bi 영역
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: Image.asset(
                        'assets/png/bgood.png',
                        height: 60,
                      ),
                    ),
                    //아이디 입력
                    const Text(
                      '아이디',
                      style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 20),
                      width: 320,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFFD5D5D5).withOpacity(0.30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: '아이디를 입력해주세요.',
                          hintStyle: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -1,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          border: InputBorder.none, // 입력 박스 테두리를 없앱니다.
                        ),
                        style: const TextStyle(
                          color: Colors.black, // 입력된 텍스트의 색상
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                    //비밀번호 입력
                    const Text(
                      '비밀번호',
                      style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 50),
                      width: 320,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFFD5D5D5).withOpacity(0.30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          hintText: '비밀번호를 입력해주세요.',
                          hintStyle: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -1,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                    //로그인 버튼 & 아이디, 비밀번호 찾기
                    ValueListenableBuilder<Color>(
                      valueListenable: _buttonColor,
                      builder: (context, color, child) {
                        return ElevatedButton(
                          onPressed: color == Color(0xFFD5D5D5)
                              ? null
                              : () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            minimumSize: Size(320, 50),
                          ),
                          child: const Text(
                            '로그인',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                    // Row(
                    //   children: [
                    //     TextButton(
                    //       onPressed: () {
                    //         // 비밀번호 찾기 기능 구현
                    //       },
                    //       child: const Text(
                    //         '비밀번호 찾기',
                    //         style: TextStyle(
                    //           color: Color(0xFF4F4F4F),
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(
                      width: 302,
                      height: 85,
                    ),
                    //회원가입 안내, 버튼
                    const SizedBox(
                      // 회원가입 안내
                      width: 302,
                      height: 80,
                      child: Text(
                        '비굿 회원이 되시면\n다양한 정보 확인이 가능해 집니다.\n회원가입 하시겠습니까?',
                        style: TextStyle(
                          color: Color(0xFF004629),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      //회원가입 버튼
                      onPressed: () {
                        context.push('/terms_and_condition_screen');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE4F5EE),
                        foregroundColor: Color(0xFF00AF66),
                        side: BorderSide(color: Color(0xFF00AF66), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        minimumSize: Size(320, 50),
                      ),
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          color: Color(0xFF00AF66),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
