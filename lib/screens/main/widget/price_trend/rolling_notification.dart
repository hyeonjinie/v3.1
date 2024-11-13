import 'package:flutter/material.dart';
import 'package:v3_mvp/widgets/font_size_helper/font_size_helper.dart';

class RollingNotification extends StatefulWidget {
  const RollingNotification({Key? key}) : super(key: key);

  @override
  State<RollingNotification> createState() => _RollingNotificationState();
}

class _RollingNotificationState extends State<RollingNotification> {
  final List<String> notifications = [
    '최신 알림: 가격이 변경되었습니다!',
    '알림: 새로운 거래가 가능합니다.',
    '경고: 시스템 점검이 예정되어 있습니다.',
    '업데이트: 새 기능이 추가되었습니다.',
    '알림: 내일은 휴무일입니다.'
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth > 1200 ? 1200 : screenWidth,
      child: GestureDetector(
        onTap: () {
          // Placeholder for navigation logic
          print('Notification tapped.');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Color(0xFFF6F6F6),
          child: Row(
            children: [
              Icon(Icons.volume_up, color: Colors.black),
              SizedBox(width: 10),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500), // 애니메이션 시간을 0.5초로 단축
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Text(
                    notifications[index],
                    key: ValueKey(notifications[index]),
                    style: TextStyle(color: Colors.black, fontSize: getFontSize(context, FontSizeType.medium)),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startRolling(); // 4초 간격으로 롤링 시작
  }

  void startRolling() {
    Future.delayed(Duration(seconds: 4), rollText); // 4초 후에 텍스트 롤링
  }

  void rollText() {
    if (!mounted) return;
    setState(() {
      index = (index + 1) % notifications.length; // 다음 텍스트로 순환
    });
    startRolling(); // 다시 롤링 시작
  }
}
