// lib/screens/info_center/subscription/new_subscription/mock_data/mock_price_data.dart
const mockPriceData = {
  "categories": [
    {
      "level": 1,
      "options": ["가격예측"]
    },
    {
      "level": 2,
      "options": ["D+7", "D+15", "D+30"]
    },
    {
      "level": 3,
      "options": ["경매", "도매", "소매", "수입"]
    },
    {
      "level": 4,
      "options": ["농산물", "축산물", "수산물", "가공식품"]
    },
    {
      "level": 5,
      "options": ["과일", "채소", "기타"]
    },
    {
      "level": 6,
      "options": ["과실류", "잎채류", "뿌리채소"]
    }
  ],
  "products": [
    {
      "name": "딸기",
      "price": 500000,
      "filters": {
        "terms": ["D+7", "D+15", "D+30"],
        "markets": ["경매", "도매", "소매"],
        "category": "농산물",
        "subtype": "과일",
        "detail": "과실류"
      }
    },
    {
      "name": "수박",
      "price": 500000,
      "filters": {
        "terms": ["D+7", "D+15"],
        "markets": ["경매", "도매"],
        "category": "농산물",
        "subtype": "과일",
        "detail": "과실류"
      }
    },
    {
      "name": "참외",
      "price": 500000,
      "filters": {
        "terms": ["D+15", "D+30"],
        "markets": ["도매", "소매"],
        "category": "농산물",
        "subtype": "과일",
        "detail": "과실류"
      }
    },
    {
      "name": "배추",
      "price": 500000,
      "filters": {
        "terms": ["D+7", "D+30"],
        "markets": ["경매", "도매"],
        "category": "농산물",
        "subtype": "채소",
        "detail": "잎채류"
      }
    },
    {
      "name": "양배추",
      "price": 500000,
      "filters": {
        "terms": ["D+7", "D+15"],
        "markets": ["도매", "소매"],
        "category": "농산물",
        "subtype": "채소",
        "detail": "잎채류"
      }
    },
    {
      "name": "당근",
      "price": 500000,
      "filters": {
        "terms": ["D+15", "D+30"],
        "markets": ["경매", "도매", "소매"],
        "category": "농산물",
        "subtype": "채소",
        "detail": "뿌리채소"
      }
    },
    {
      "name": "한우",
      "price": 500000,
      "filters": {
        "terms": ["D+7", "D+15", "D+30"],
        "markets": ["경매", "도매"],
        "category": "축산물",
        "subtype": "기타",
        "detail": "과실류"
      }
    },
    {
      "name": "고등어",
      "price": 500000,
      "filters": {
        "terms": ["D+7", "D+15"],
        "markets": ["경매", "도매", "수입"],
        "category": "수산물",
        "subtype": "기타",
        "detail": "과실류"
      }
    },
    {
      "name": "오징어",
      "price": 500000,
      "filters": {
        "terms": ["D+15", "D+30"],
        "markets": ["도매", "수입"],
        "category": "수산물",
        "subtype": "기타",
        "detail": "과실류"
      }
    },
    {
      "name": "라면",
      "price": 500000,
      "filters": {
        "terms": ["D+7", "D+30"],
        "markets": ["도매", "소매"],
        "category": "가공식품",
        "subtype": "기타",
        "detail": "과실류"
      }
    }
  ]
};

// lib/screens/info_center/subscription/new_subscription/mock_data/mock_index_data.dart
const mockIndexData = {
  "categories": [
    {
      "level": 1,
      "options": ["지수"]
    },
    {
      "level": 2,
      "options": ["D+7", "D+15", "D+30"]
    },
    {
      "level": 3,
      "options": ["묶음", "메뉴"]
    },
    {
      "level": 4,
      "options": ["차례상", "농산물", "수산물", "축산물"]
    },
    {
      "level": 5,
      "options": ["표준코드별", "통계별", "시장별"]
    }
  ],
  "indices": [
    {
      "name": "종합지수",
      "price": 500000,
      "filters": {
        "term": ["D+7", "D+15"],
        "category": "농산물",
        "type": "묶음",
        "detail": "표준코드별"
      }
    },
    {
      "name": "가락시장 TOP10",
      "price": 500000,
      "filters": {
        "term": ["D+15", "D+30"],
        "category": "농산물",
        "type": "묶음",
        "detail": "시장별"
      }
    },
    {
      "name": "강서시장 지수",
      "price": 500000,
      "filters": {
        "term": ["D+7", "D+30"],
        "category": "농산물",
        "type": "묶음",
        "detail": "시장별"
      }
    },
    {
      "name": "차례상 물가지수",
      "price": 500000,
      "filters": {
        "term": ["D+7", "D+15"],
        "category": "차례상",
        "type": "메뉴",
        "detail": "통계별"
      }
    },
    {
      "name": "제수용품 지수",
      "price": 500000,
      "filters": {
        "term": ["D+15", "D+30"],
        "category": "차례상",
        "type": "메뉴",
        "detail": "통계별"
      }
    },
    {
      "name": "수산물 종합",
      "price": 500000,
      "filters": {
        "term": ["D+7", "D+15"],
        "category": "수산물",
        "type": "묶음",
        "detail": "표준코드별"
      }
    },
    {
      "name": "축산물 종합",
      "price": 500000,
      "filters": {
        "term": ["D+15", "D+30"],
        "category": "축산물",
        "type": "묶음",
        "detail": "표준코드별"
      }
    },
    {
      "name": "농산물 통계",
      "price": 500000,
      "filters": {
        "term": ["D+7", "D+30"],
        "category": "농산물",
        "type": "묶음",
        "detail": "통계별"
      }
    },
    {
      "name": "수입 수산물",
      "price": 500000,
      "filters": {
        "term": ["D+7", "D+15"],
        "category": "수산물",
        "type": "묶음",
        "detail": "시장별"
      }
    },
    {
      "name": "한우 도매",
      "price": 500000,
      "filters": {
        "term": ["D+15", "D+30"],
        "category": "축산물",
        "type": "메뉴",
        "detail": "시장별"
      }
    }
  ]
};