
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v3_mvp/services/auth_provider.dart';
import 'package:v3_mvp/widgets/responsive_safe_area/responsive_safe_area.dart';
import 'package:v3_mvp/screens/auth/user_profile/user_profile.dart';

class GlobalCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderService>(context);
    final user = authProvider.user;

    return ResponsiveSafeArea(
      child: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 앱 시작 시 로고를 왼쪽에 위치하지 않고, 중앙에 위치하도록 설정
            const Spacer(),  // 왼쪽 공간 추가
            IconButton(
              icon: Image.asset('assets/png/bgood.png', height: 40),
              onPressed: () => print('Home logo clicked'),
            ),
            Spacer(),  // 오른쪽 공간 추가
            if (user != null)
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfileScreen()));
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
