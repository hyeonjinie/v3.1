import 'package:flutter/material.dart';

import '../../../../widgets/font_size_helper/font_size_helper.dart';

class CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Container(
          width: 1200,
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/png/bgood.png', // 로고 이미지 경로
                    height: 40,
                  ),
                  // Row(
                  //   children: [
                  //     SvgPicture.asset('assets/icons/facebook.svg', height: 30),
                  //     SizedBox(width: 10),
                  //     SvgPicture.asset('assets/icons/instagram.svg', height: 30),
                  //     SizedBox(width: 10),
                  //     SvgPicture.asset('assets/icons/naver.svg', height: 30),
                  //     SizedBox(width: 10),
                  //     SvgPicture.asset('assets/icons/youtube.svg', height: 30),
                  //   ],
                  // ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '(주) 에스앤이컴퍼니\n대표자 : 장세훈 | 사업자등록번호 : 737-88-01827\n통신판매업 신고 : 제 2022-서울강남-01957호\n개인정보관리 책임자 : 장세훈 (shjang@bgood.co.kr)',
                style: TextStyle(color: Colors.white, fontSize: getFontSize(context, FontSizeType.small)),
              ),
              SizedBox(height: 10),
              Text(
                '"(주)에스앤이컴퍼니"은 모든 거래에 대한 책임과 배송, 교환, 환불, 민원 등의 처리는 "(주)에스앤이컴퍼니"에서 진행합니다. 민원담당자: 박재성 연락처: 02-553-7709',
                style: TextStyle(color: Colors.white, fontSize: getFontSize(context, FontSizeType.small)),
              ),
              SizedBox(height: 10),
              Text(
                '전화 : 02-553-7709\n가입문의 : contact@bgood.co.kr\n채용문의 : recruit@bgood.co.kr\n소재지 : 서울특별시 서초구 매헌로8길 39 D동 406호',
                style: TextStyle(color: Colors.white, fontSize: getFontSize(context, FontSizeType.small)),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '이용 약관',
                    style: TextStyle(color: Colors.blue, fontSize: getFontSize(context, FontSizeType.extraSmall)),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '개인정보처리방침',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Copyright 2022 B · good. All rights reserved.',
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
