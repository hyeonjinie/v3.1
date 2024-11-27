import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/index.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/index_data.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/product.dart';
import 'package:intl/intl.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/selection.dart';
import 'package:v3_mvp/services/subscription_service.dart';

import '../../../../services/auth_provider.dart';
import '../widget/term_popup.dart';

import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/subscription_category.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/subscription_data.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/subscription_state.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  SubscriptionData? priceData;
  IndexData? indexData;
  String selectedMode = '가격';
  bool isSummaryView = false; // 화면 상태 변수
  bool isLoading = true;
  String? errorMessage;

  // Selected values for price prediction
  String? selectedTerm;
  String? selectedMarket;
  String? selectedCategory;
  String? selectedSubtype;
  String? selectedDetail;

  // Selected values for index
  String? selectedIndexTerm;
  String? selectedType;
  String? selectedIndexCategory;
  String? selectedIndexDetail;
  String? selectedIndexSubDetail;  // 레벨 6 추가

  // 선택한 품목을 저장할 변수
  List<dynamic> selectedItems = [];

  // 약관 동의 상태
  bool allAgreed = false;
  bool agreeServiceTerms = false;
  bool agreeServiceAdditionalTerms = false;

  // API 응답 데이터 저장
  Map<String, dynamic>? subscriptionData;

  // 수정 모드인지 여부를 저장하는 상태 변수 추가
  bool isEditMode = false;

  // 모든 레벨이 선택되었는지 확인하는 getter
  bool get hasAllLevelsSelected {
    if (selectedMode == '가격') {
      final hasAll = selectedTerm != null &&
          selectedMarket != null &&
          selectedSubtype != null &&  // 첫 번째 카테고리 (농산물, 수산물 등)
          selectedCategory != null &&  // 두 번째 카테고리 (과일, 채소 등)
          selectedDetail != null;  // 세 번째 카테고리 (과일과채류, 과실류 등)
      
      return hasAll;
    } else {
      return selectedIndexTerm != null &&
          selectedType != null &&
          selectedIndexCategory != null &&
          selectedIndexDetail != null &&  // 레벨 5 추가
          selectedIndexSubDetail != null;  // 레벨 6 추가
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSubscriptionStatus();
    });
    _loadCategoryData();
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      final authProvider = Provider.of<AuthProviderService>(context, listen: false);
      final token = await authProvider.getCurrentUserToken();

      if (token != null) {
        final response = await SubscriptionApiService.checkSubscriptionStatus(token);
        if (response.statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          final bool subStatus = data['sub_status'] ?? false;
          final bool standby = data['standby'] ?? false;

          if (!subStatus && standby) {
            setState(() {
              isSummaryView = true;
            });
            // 상태가 summary view인 경우 데이터 가져오기
            await _fetchLandingData();
          } else {
            setState(() {
              isSummaryView = false;
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        isSummaryView = false;
      });
    }
  }

  Future<void> _loadCategoryData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await SubscriptionApiService.getCategoryList(selectedMode);
      
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final dynamic data = json.decode(decodedBody);
        
        if (data == null) {
          throw Exception('서버에서 데이터를 받지 못했습니다.');
        }

        if (data is! Map<String, dynamic>) {
          throw Exception('잘못된 데이터 형식입니다: ${data.runtimeType}');
        }

        setState(() {
          if (selectedMode == '가격') {
            if (!data.containsKey('categories') || !data.containsKey('products')) {
              throw Exception('필수 데이터가 누락되었습니다.');
            }
            priceData = SubscriptionData.fromJson(data, selectedMode);
          } else {
            if (!data.containsKey('categories') || !data.containsKey('indices')) {
              throw Exception('필수 데이터가 누락되었습니다.');
            }
            indexData = IndexData.fromJson(data);
          }
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = '데이터를 불러오는 중 오류가 발생했습니다: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _subscribe() async {
    try {
      final data = _prepareSubscriptionData();
      
      final authProvider = Provider.of<AuthProviderService>(context, listen: false);
      final token = await authProvider.getCurrentUserToken();
      
      if (token == null) {
        throw Exception('토큰이 없습니다.');
      }
      
      if (isEditMode) {
        await SubscriptionApiService.updateSubscription(
          token,
          data,
        );
      } else {
        await SubscriptionApiService.createSubscription(
          token,
          data,
        );
      }

      // 구독 생성/수정 후 상태 업데이트
      setState(() {
        isSummaryView = true;
      });

      // 새로운 구독 데이터 가져오기
      await Future.delayed(const Duration(milliseconds: 500)); // API 상태 업데이트 대기
      await _fetchLandingData();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('구독 ${isEditMode ? "수정" : "신청"}에 실패했습니다: $e')),
      );
    }
  }

  void resetSelections() {
    if (selectedMode == '가격') {
      selectedTerm = null;
      selectedMarket = null;
      selectedCategory = null;
      selectedSubtype = null;
      selectedDetail = null;
    } else {
      selectedIndexTerm = null;
      selectedType = null;
      selectedIndexCategory = null;
      selectedIndexDetail = null;
      selectedIndexSubDetail = null;  // 레벨 6 초기화
    }
  }

  void onModeChanged(String mode) {
    setState(() {
      selectedMode = mode;
      resetSelections();
      isLoading = true;
    });
    _loadCategoryData(); // 모드 변경 시 새로운 데이터 로드
  }



  // 가격 모드의 레벨 선택 핸들러들
  int _getPriceIndexForTerm(String term) {
    final products = getFilteredProducts();
    if (products.isEmpty) {
      return 0;
    }
    
    final product = products.first;
    final termOptions = product.filters.terms;
    final index = termOptions.indexOf(term);
    return index >= 0 ? index : 0;
  }

  void onTermSelected(String term) {
    setState(() {
      selectedTerm = term;
      selectedMarket = null;
      selectedCategory = null;
      selectedSubtype = null;
      selectedDetail = null;
    });
  }

  void onMarketSelected(String market) {
    setState(() {
      selectedMarket = market;
      selectedCategory = null;
      selectedSubtype = null;
      selectedDetail = null;

      final List<dynamic> updatedItems = [];
      for (final item in selectedItems) {
        if (item is ProductSelection) {
          updatedItems.add(ProductSelection(
            product: item.product,
            term: item.term,
            market: market,
            selectedPrice: item.selectedPrice,
          ));
        } else {
          updatedItems.add(item);
        }
      }
      selectedItems = updatedItems;
    });
  }

  // 지수 모드 관련 메서드들
  List<Index> getFilteredIndices() {
    if (indexData == null) return [];

    return indexData!.indices.where((index) {
      if (selectedIndexTerm != null && !index.filters.terms.contains(selectedIndexTerm)) {
        return false;
      }
      if (selectedType != null && index.filters.subtype != selectedType) {
        return false;
      }
      if (selectedIndexCategory != null && index.filters.category != selectedIndexCategory) {
        return false;
      }
      if (selectedIndexDetail != null && index.filters.detail != selectedIndexDetail) {
        return false;
      }
      if (selectedIndexSubDetail != null && index.filters.subDetail != selectedIndexSubDetail) {
        return false;
      }
      return true;
    }).toList();
  }

  void onIndexTermSelected(String term) {
    setState(() {
      selectedIndexTerm = term;
      selectedType = null;
      selectedIndexCategory = null;
      selectedIndexDetail = null;
      selectedIndexSubDetail = null;  // 레벨 6 초기화
    });
  }

  void onTypeSelected(String type) {
    setState(() {
      selectedType = type;
      selectedIndexCategory = null;
      selectedIndexDetail = null;
      selectedIndexSubDetail = null;  // 레벨 6 초기화
      // 테이블의 기존 항목들은 유지
    });
  }

  void onIndexCategorySelected(String category) {
    setState(() {
      selectedIndexCategory = category;
      selectedIndexDetail = null;
      selectedIndexSubDetail = null;  // 레벨 6 초기화
      // 테이블의 기존 항목들은 유지
    });
  }

  void onIndexDetailSelected(String detail) {
    setState(() {
      selectedIndexDetail = detail;
      selectedIndexSubDetail = null;  // 레벨 6 초기화
      
      // 모든 필수 필터가 선택되었는지 확인
      if (selectedIndexTerm != null && 
          selectedType != null && 
          selectedIndexCategory != null && 
          selectedIndexDetail != null) {
        
        // 현재 선택된 필터 조건에 맞는 인덱스들을 가져옴
        final indices = getFilteredIndices();
        
        // 테이블의 기존 항목 업데이트
        final List<dynamic> updatedItems = [];
        for (final item in selectedItems) {
          if (item is IndexSelection) {
            // 현재 선택된 필터 조건에 맞는 인덱스 찾기
            final matchingIndex = indices.firstWhere(
              (i) => i.name == item.index.name && 
                    i.filters.category == item.index.filters.category &&
                    i.filters.subtype == item.index.filters.subtype &&
                    i.filters.detail == item.index.filters.detail &&
                    (i.filters.subDetail == item.index.filters.subDetail),
              orElse: () => item.index,
            );
            
            // 기존 항목의 기간과 가격 업데이트
            updatedItems.add(IndexSelection(
              index: matchingIndex,  // 새로운 가격 정보가 포함된 인덱스
              term: selectedIndexTerm!,  // 새로 선택된 기간
              type: selectedType!,
            ));
          } else {
            updatedItems.add(item);
          }
        }
        selectedItems = updatedItems;
      }
    });
  }

  void onIndexSubDetailSelected(String subDetail) {
    setState(() {
      selectedIndexSubDetail = subDetail;

      final List<dynamic> updatedItems = [];
      for (final item in selectedItems) {
        if (item is IndexSelection) {
          final indices = getFilteredIndices();
          final matchingIndex = indices.firstWhere(
            (i) => i.name == item.index.name,
            orElse: () => item.index,
          );
          
          updatedItems.add(IndexSelection(
            index: matchingIndex,
            term: item.term,
            type: item.type,
          ));
        } else {
          updatedItems.add(item);
        }
      }
      selectedItems = updatedItems;
    });
  }

  // 레벨 옵션 및 필터링 메서드들
  List<String> getOptionsForLevel(int level) {
    if (selectedMode == '가격' && priceData != null) {
      final category = priceData!.getCategoryByLevel(level) ?? 
          SubscriptionCategory(level: level, options: [], mode: selectedMode);

      switch (level) {
        case 4:
          final options = category.getOptionsForLevel(null, null);
          print('Level 4 Options: $options');
          return options;
        case 5:
          final options = category.getOptionsForLevel(selectedCategory, null);
          print('Level 5 Options: $options');
          return options;
        case 6:
          final options = category.getOptionsForLevel(selectedCategory, selectedSubtype);
          print('Level 6 Options: $options');
          return options;
        default:
          final options = category.getOptionsForLevel(selectedCategory, selectedSubtype);
          print('Default Level Options: $options');
          return options;
      }
    } else if (selectedMode == '지수' && indexData != null) {
      final category = indexData!.getCategoryByLevel(level) ?? 
          SubscriptionCategory(level: level, options: [], mode: selectedMode);

      switch (level) {
        case 4:
          print('Getting Level 4 options with selectedType: $selectedType'); // 디버깅용
          final options = category.getOptionsForLevel(null, selectedType);
          print('Level 4 Options from category: $options'); // 디버깅용
          return options;
        case 5:
          final options = category.getOptionsForLevel(selectedIndexCategory, selectedType);
          print('Level 5 Options: $options');
          return options;
        case 6:
          final options = category.getOptionsForLevel(selectedIndexCategory, selectedIndexDetail);
          print('Level 6 Options: $options');
          return options;
        default:
          final options = category.getOptionsForLevel(selectedType, selectedIndexCategory);
          print('Default Level Options: $options');
          return options;
      }
    }
    return [];
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      selectedSubtype = null;
      selectedDetail = null;
      _updateSelectedItems();
    });
  }

  void onSubtypeSelected(String? value) {
    if (value == null) return;
    
    setState(() {
      selectedSubtype = value;
      selectedDetail = null;
      _updateSelectedItems();
    });
  }

  void onDetailSelected(String? value) {
    if (value == null) return;
    
    setState(() {
      selectedDetail = value;
      _updateSelectedItems();
    });
  }

  // 선택된 아이템들 업데이트
  void _updateSelectedItems() {
    final List<dynamic> updatedItems = [];
    for (final item in selectedItems) {
      if (item is ProductSelection) {
        final products = getFilteredProducts();
        final matchingProduct = products.firstWhere(
          (p) => p.name == item.product.name,
          orElse: () => item.product,
        );
        
        updatedItems.add(ProductSelection(
          product: matchingProduct,
          term: item.term,
          market: item.market,
          selectedPrice: item.selectedPrice,
        ));
      } else {
        updatedItems.add(item);
      }
    }
    selectedItems = updatedItems;
  }

  int calculateTotalPrice() {
    int total = 0;
    
    for (var item in selectedItems) {
      if (item is ProductSelection) {
        total += item.product.price[item.selectedPrice];
      } else if (item is IndexSelection) {
        // 선택된 기간에 해당하는 가격 인덱스 찾기
        final termIndex = item.index.filters.terms.indexOf(item.term);
        if (termIndex != -1 && termIndex < item.index.price.length) {
          total += item.index.price[termIndex];
        }
      }
    }
    
    return total;
  }


  // 중복된 항목 삭제 메서드
  void removeRedundantSelections(dynamic newItem) {
    setState(() {
      selectedItems.removeWhere((item) {
        if (item is ProductSelection && newItem is ProductSelection) {
          return item.product == newItem.product && item.market == newItem.market;
        } else if (item is IndexSelection && newItem is IndexSelection) {
          return item.index == newItem.index && item.type == newItem.type;
        }
        return false;
      });
    });
  }

  void _addIndexToTable(Index index) {
    // 모든 필수 필터가 선택되었는지 확인
    if (selectedIndexTerm == null || 
        selectedType == null || 
        selectedIndexCategory == null || 
        selectedIndexDetail == null) {
      return;
    }

    setState(() {
      // 같은 품목이 이미 있는지 확인
      final existingItemIndex = selectedItems.indexWhere((item) {
        if (item is IndexSelection) {
          return item.index.name == index.name &&
                 item.index.filters.category == index.filters.category &&
                 item.index.filters.subtype == index.filters.subtype &&
                 item.index.filters.detail == index.filters.detail;
        }
        return false;
      });

      final newSelection = IndexSelection(
        index: index,
        term: selectedIndexTerm!,
        type: selectedType!,
      );

      if (existingItemIndex != -1) {
        // 같은 품목이 있다면 업데이트
        selectedItems[existingItemIndex] = newSelection;
      } else {
        // 없다면 새로 추가
        selectedItems.add(newSelection);
      }
    });
  }

  // 약관 동의 상태 업데이트
  void updateAgreementStatus({bool? all, bool? service, bool? additional}) {
    if (selectedItems.isEmpty) {
      _showSelectItemAlert();
      return;
    }

    setState(() {
      if (all != null) {
        allAgreed = all;
        agreeServiceTerms = all;
        agreeServiceAdditionalTerms = all;
      } else {
        if (service != null) {
          agreeServiceTerms = service;
        }
        if (additional != null) {
          agreeServiceAdditionalTerms = additional;
        }
        allAgreed = agreeServiceTerms && agreeServiceAdditionalTerms;
      }
    });
  }

  // 보기 버튼 클릭 시 약관 팝업을 열기 전에 선택 품목 확인
  void _handleViewTerms1(VoidCallback onAgree) {
    if (selectedItems.isEmpty) {
      _showSelectItemAlert();
    } else {
      showDialog(
        context: context,
        builder: (context) => TermsPopupPage(onAgree: onAgree),
      );
    }
  }

  // 보기 버튼 클릭 시 약관 팝업을 열기 전에 선택 품목 확인
  void _handleViewTerms2(VoidCallback onAgree) {
    if (selectedItems.isEmpty) {
      _showSelectItemAlert();
    } else {
      showDialog(
        context: context,
        builder: (context) => TermsAdditionalPopupPage(onAgree: onAgree),
      );
    }
  }

  void _showSelectItemAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('품목을 선택해 주세요.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // UI 구성 요소 위젯들
  Widget _buildOptionButton(String text, bool isSelected,
      VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isSelected ? const Color(0xFF11C278) : Colors.white,
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: isSelected ? const Color(0xFF11C278) : Colors.grey[300]!,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? value,
      Function(String?)? onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: DropdownButtonHideUnderline(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: onChanged == null ? Colors.grey[300]! : Colors.grey[400]!,
            ),
            borderRadius: BorderRadius.circular(4),
            color: onChanged == null ? Colors.grey[100] : Colors.white,
          ),
          child: DropdownButton<String>(
            hint: Text(
              hint,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            value: value,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid<T>({
    required List<T> items,
    required String Function(T) getName,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;
        double fontSize;
        double iconSize;

        if (constraints.maxWidth < 600) {
          crossAxisCount = 4;
          childAspectRatio = 1;
          fontSize = 12;
          iconSize = 16;
        } else if (constraints.maxWidth < 1024) {
          crossAxisCount = 6;
          childAspectRatio = 1;
          fontSize = 13;
          iconSize = 18;
        } else {
          crossAxisCount = 8;
          childAspectRatio = 1;
          fontSize = 14;
          iconSize = 20;
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD5D5D5)),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 8,
              mainAxisSpacing: 16,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (item is Product &&
                                  selectedTerm != null &&
                                  selectedMarket != null) {
                                final priceIndex = _getPriceIndexForTerm(selectedTerm!);
                                final newSelection = ProductSelection(
                                  product: item,
                                  term: selectedTerm!,
                                  market: selectedMarket!,
                                  selectedPrice: priceIndex,
                                );
                                removeRedundantSelections(newSelection);
                                selectedItems.add(newSelection);
                              } else if (item is Index &&
                                  selectedIndexTerm != null &&
                                  selectedType != null) {
                                _addIndexToTable(item);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.image_outlined,
                              color: Colors.grey,
                              size: iconSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 20,
                      child: Text(
                        getName(item),
                        style: TextStyle(
                          fontSize: fontSize,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showErrorAlert(int statusCode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('오류'),
          content: Text('서버 요청에 실패했습니다. 상태 코드: $statusCode'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }



// ...

  Widget _buildSelectedItemsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '선택 품목',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                children: const [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('품목',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('구분',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('기간/타입',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('시장/세부',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('가격',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(width: 40),
                    ),
                  ),
                ],
              ),
              ...selectedItems.map((item) {
                if (item is ProductSelection) {
                  final priceIndex = item.product.filters.terms.indexOf(item.term);
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.product.name),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.product.filters.category),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.term),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.market),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            '${NumberFormat.currency(locale: "ko_KR", symbol: "").format(item.product.price[item.selectedPrice])} 원',
                          ),
                        ),
                      ),
                      TableCell(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              removeRedundantSelections(item);
                              selectedItems.remove(item);
                            });
                          },
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                } else if (item is IndexSelection) {
                  final priceIndex = item.index.filters.terms.indexOf(item.term);
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.index.name),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.index.filters.category),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.term),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item.type),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            '${NumberFormat.currency(locale: "ko_KR", symbol: "").format(item.index.price[priceIndex])} 원',
                          ),
                        ),
                      ),
                      TableCell(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              removeRedundantSelections(item);
                              selectedItems.remove(item);
                            });
                          },
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const TableRow(children: []);
                }
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!),
            ElevatedButton(
              onPressed: _loadCategoryData,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    return Container(
      child: isSummaryView
          ? _buildSubscriptionSummary()
          : _buildSubscriptionForm(),
    );
  }

  Future<void> _fetchLandingData() async {
    try {
      final authProvider = Provider.of<AuthProviderService>(context, listen: false);
      final token = await authProvider.getCurrentUserToken();
      if (token != null) {
        final response = await SubscriptionApiService.getLandingData(token, '가격');
        if (response.statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          setState(() {
            subscriptionData = data;
          });
        } else {
          print('Landing data fetch failed with status: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error fetching landing data: $e');
    }
  }

  Widget _buildSubscriptionSummary() {
    if (subscriptionData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final subPriceList = (subscriptionData!['sub_price_list'] as List?) ?? [];
    final subIndexList = (subscriptionData!['sub_index_list'] as List?) ?? [];

    int totalAmount = 0;
    for (var item in subPriceList) {
      final priceStr = item['price']?.toString() ?? '0';
      final price = int.tryParse(priceStr) ?? 0;
      totalAmount += price;
    }
    for (var item in subIndexList) {
      final priceStr = item['price']?.toString() ?? '0';
      final price = int.tryParse(priceStr) ?? 0;
      totalAmount += price;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      '입금 확인이 되면 자동으로 품목 정보가 보입니다.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      '결제 금액',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${NumberFormat.currency(locale: "ko_KR", symbol: "").format(totalAmount)}원',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF11C278),
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      '입금정보',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '국민은행',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '123456-78-123456',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '(주)에스앤이컴퍼니',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    const Text(
                      '구독 품목',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(
                        color: const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(
                            color: Color(0xFFF6F6F6),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '품목',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '구분',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '기간',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '시장',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '가격',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...subPriceList.map((item) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['variety'] ?? ''),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('가격'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['category_a'] ?? ''),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['category_b'] ?? ''),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${NumberFormat.currency(locale: "ko_KR", symbol: "").format(int.tryParse(item['price']?.toString() ?? '0') ?? 0)} 원',
                              ),
                            ),
                          ],
                        )).toList(),
                        ...subIndexList.map((item) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['variety'] ?? ''),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('지수'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['category_a'] ?? ''),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['category_b'] ?? ''),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${NumberFormat.currency(locale: "ko_KR", symbol: "").format(int.tryParse(item['price']?.toString() ?? '0') ?? 0)} 원',
                              ),
                            ),
                          ],
                        )).toList(),
                      ],
                    ),
                    const SizedBox(height: 60),

                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 26),
                          backgroundColor: const Color(0xFF00AF66),
                        ),
                        onPressed: () {
                          _convertApiDataToSelectedItems();
                          setState(() {
                            isSummaryView = false;
                          });
                        },
                        child: const Text(
                          '수정하기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _prepareSubscriptionData() {
    final subPriceList = selectedItems
        .where((item) => item is ProductSelection)
        .map((item) => item as ProductSelection)
        .map((item) => {
              "category_a": item.term,
              "category_b": item.market,
              "category_c": item.product.filters.category,
              "category_d": item.product.filters.subtype,
              "category_e": item.product.filters.detail,
              "category_f": item.product.name,  // variety와 동일한 값 사용
              "variety": item.product.name,
              "price": item.product.price[item.selectedPrice].toString(),  // 문자열로 변환
            })
        .toList();

    final subIndexList = selectedItems
        .where((item) => item is IndexSelection)
        .map((item) => item as IndexSelection)
        .map((item) {
          // 선택된 기간에 해당하는 가격 인덱스 찾기
          final termIndex = item.index.filters.terms.indexOf(item.term);
          final price = termIndex != -1 && termIndex < item.index.price.length
              ? item.index.price[termIndex]
              : item.index.price[0];
              
          return {
            "category_a": item.term,
            "category_b": item.type,
            "category_c": item.index.filters.category,
            "category_d": item.index.filters.detail,
            "category_e": item.index.filters.subDetail,  // 레벨 6 데이터 추가
            "category_f": item.index.name,
            "variety": item.index.name,
            "price": price.toString(),  // 문자열로 변환
          };
        })
        .toList();

    final data = {
      "sub_price_list": subPriceList,
      "sub_index_list": subIndexList,
    };

    return data;
  }

  void _convertApiDataToSelectedItems() {
    if (subscriptionData == null) return;

    selectedItems.clear();
    final subPriceList = (subscriptionData!['sub_price_list'] as List?) ?? [];
    final subIndexList = (subscriptionData!['sub_index_list'] as List?) ?? [];

    isEditMode = true;

    for (var item in subPriceList) {
      final priceStr = item['price']?.toString() ?? '0';
      final price = int.tryParse(priceStr) ?? 0;
      
      final product = Product(
        name: item['variety'] ?? '',
        price: [price],
        filters: ProductFilters(
          terms: [item['category_a'] ?? ''],
          markets: [item['category_b'] ?? ''],
          category: item['category_c'] ?? '',
          subtype: item['category_d'] ?? '',
          detail: item['category_e'] ?? '',
        ),
      );

      selectedItems.add(ProductSelection(
        product: product,
        term: item['category_a'] ?? '',
        market: item['category_b'] ?? '',
        selectedPrice: 0,
      ));
    }

    for (var item in subIndexList) {
      final priceStr = item['price']?.toString() ?? '0';
      final price = int.tryParse(priceStr) ?? 0;
      
      final index = Index(
        name: item['variety'] ?? '',
        price: [price],
        filters: IndexFilters(
          terms: [item['category_a'] ?? ''],
          category: item['category_c'] ?? '',
          subtype: item['category_b'] ?? '',
          detail: item['category_d'] ?? '',
          subDetail: item['category_e'] ?? '',
        ),
      );

      selectedItems.add(IndexSelection(
        index: index,
        term: item['category_a'] ?? '',
        type: item['category_b'] ?? '',
      ));
    }
  }

  List<Product> getFilteredProducts() {
    if (priceData?.items.isEmpty ?? true) {
      return [];
    }

    final allProducts = priceData!.items;

    final filteredProducts = allProducts.where((product) {
      final filters = product.filters;
      
      bool termMatch = selectedTerm == null || filters.terms.contains(selectedTerm);
      bool marketMatch = selectedMarket == null || 
          (filters.markets?.contains(selectedMarket) ?? true);
      
      bool subtypeMatch = selectedCategory == null || filters.subtype == selectedCategory;
      bool categoryMatch = selectedSubtype == null || filters.category == selectedSubtype;
      bool detailMatch = selectedDetail == null || filters.detail == selectedDetail;

      return termMatch && marketMatch && subtypeMatch && categoryMatch && detailMatch;
    }).toList();

    return filteredProducts;
  }

  Widget _buildSubscriptionForm() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildOptionButton(
                            '가격',
                            selectedMode == '가격',
                                () => onModeChanged('가격'),
                          ),
                        ),
                        Expanded(
                          child: _buildOptionButton(
                            '지수',
                            selectedMode == '지수',
                                () => onModeChanged('지수'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (selectedMode == '가격') ...[
                      Row(
                        children: [
                          for (final term in getOptionsForLevel(2))
                            Expanded(
                              child: _buildOptionButton(
                                term,
                                selectedTerm == term,
                                    () => onTermSelected(term),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          for (final market in getOptionsForLevel(3))
                            Expanded(
                              child: _buildOptionButton(
                                market,
                                selectedMarket == market,
                                    () => onMarketSelected(market),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          for (final category in getOptionsForLevel(4))
                            Expanded(
                              child: _buildOptionButton(
                                category,
                                selectedCategory == category,
                                    () => onCategorySelected(category),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (selectedCategory != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                '선택하세요',
                                getOptionsForLevel(5),
                                selectedSubtype,
                                (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedSubtype = value;
                                      selectedDetail = null;
                                      _updateSelectedItems();
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildDropdown(
                                '선택하세요',
                                getOptionsForLevel(6),
                                selectedDetail,
                                (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedDetail = value;
                                      _updateSelectedItems();
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 40),

                      if (hasAllLevelsSelected) ...[
                        Container(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          alignment: Alignment.center,
                          child: _buildGrid<Product>(
                            items: getFilteredProducts(),
                            getName: (product) => product.name,
                          ),
                        ),
                      ],
                    ] else
                      ...[
                        Row(
                          children: [
                            for (final term in getOptionsForLevel(2))
                              Expanded(
                                child: _buildOptionButton(
                                  term,
                                  selectedIndexTerm == term,
                                      () => onIndexTermSelected(term),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            for (final type in getOptionsForLevel(3))
                              Expanded(
                                child: _buildOptionButton(
                                  type,
                                  selectedType == type,
                                      () => onTypeSelected(type),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            for (final category in getOptionsForLevel(4))
                              Expanded(
                                child: _buildOptionButton(
                                  category,
                                  selectedIndexCategory == category,
                                      () => onIndexCategorySelected(category),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (selectedIndexCategory != null) ...[
                          _buildLevel5AndIndicesDropdowns(),
                          const SizedBox(height: 16),
                        ],

                        // if (hasAllLevelsSelected) ...[
                        //   Container(
                        //     constraints: const BoxConstraints(maxWidth: 1200),
                        //     alignment: Alignment.center,
                        //     child: _buildGrid<Index>(
                        //       items: getFilteredIndices(),
                        //       getName: (index) => index.name,
                        //     ),
                        //   ),
                        // ],
                      ],

                    const SizedBox(height: 40),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),

                    const SizedBox(height: 40),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      alignment: Alignment.center,
                      child: _buildSelectedItemsTable(),
                    ),

                    const SizedBox(height: 40),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${NumberFormat.currency(locale: "ko_KR", symbol: "").format(calculateTotalPrice())} 원',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '구독 시작일 : 결제일 기준',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Checkbox(
                          value: allAgreed,
                          onChanged: (bool? value) {
                            updateAgreementStatus(all: value);
                          },
                          activeColor: const Color(0xFF1E357D),
                        ),
                        const Text('전체동의')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: agreeServiceTerms,
                              onChanged: (bool? value) {
                                updateAgreementStatus(service: value);
                              },
                              activeColor: const Color(0xFF1E357D),
                            ),
                            const Text('예측 데이터 구독 서비스 이용 약관 (필수)'),
                          ],
                        ),
                        GestureDetector(
                          onTap: () =>
                              _handleViewTerms1(() {
                                setState(() {
                                  agreeServiceTerms = true;
                                  allAgreed = agreeServiceTerms &&
                                      agreeServiceAdditionalTerms;
                                });
                              }),
                          child: const Text(
                              '보기',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: agreeServiceAdditionalTerms,
                              onChanged: (bool? value) {
                                updateAgreementStatus(additional: value);
                              },
                              activeColor: const Color(0xFF1E357D),
                            ),
                            const Text('예측 데이터 구독 서비스 부가 약관 (필수)'),
                          ],
                        ),
                        GestureDetector(
                          onTap: () =>
                              _handleViewTerms2(() {
                                setState(() {
                                  agreeServiceAdditionalTerms = true;
                                  allAgreed = agreeServiceTerms &&
                                      agreeServiceAdditionalTerms;
                                });
                              }),
                          child: const Text(
                              '보기',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              )
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 26),
                            backgroundColor: allAgreed
                                ? const Color(0xFF1E357D)
                                : const Color(0xFFDDE1E6),
                          ),
                          onPressed: allAgreed
                              ? () async {
                            if (selectedItems.isEmpty) {
                              _showSelectItemAlert();
                            } else {
                              await _subscribe();
                            }
                          }
                              : null,
                          child: const Text(
                            '구독하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Index> getAvailableIndices() {
    if (indexData == null) return [];

    return indexData!.indices.where((index) {
      // 현재 선택된 값들과 일치하는 indices만 반환
      if (selectedIndexTerm != null && !index.filters.terms.contains(selectedIndexTerm)) {
        return false;
      }
      if (selectedType != null && index.filters.subtype != selectedType) {
        return false;
      }
      if (selectedIndexCategory != null && index.filters.category != selectedIndexCategory) {
        return false;
      }
      if (selectedIndexDetail != null && index.filters.detail != selectedIndexDetail) {
        return false;
      }
      if (selectedIndexSubDetail != null && index.filters.subDetail != selectedIndexSubDetail) {
        return false;
      }
      return true;
    }).toList();
  }

  Widget _buildLevel5AndIndicesDropdowns() {
    final level5Options = getOptionsForLevel(5);
    final availableIndices = getAvailableIndices();
    final indicesOptions = availableIndices.map((index) => index.name).toList();

    return Row(
      children: [
        // 레벨 5 드롭다운
        Expanded(
          child: _buildDropdown(
            '선택하세요',
            level5Options,
            selectedIndexDetail,
            (value) {
              if (value != null) {
                setState(() {
                  selectedIndexDetail = value;
                  // indices 선택 초기화
                  selectedIndexSubDetail = null;
                });
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        // indices 드롭다운
        Expanded(
          child: _buildDropdown(
            '품목 선택',
            indicesOptions,
            selectedIndexSubDetail,
            selectedIndexDetail == null
                ? null  // 레벨 5가 선택되지 않았으면 비활성화
                : (value) {
                    if (value != null) {
                      setState(() {
                        selectedIndexSubDetail = value;
                        // 선택된 index를 찾아서 테이블에 추가
                        final selectedIndex = availableIndices.firstWhere(
                          (index) => index.name == value,
                        );
                        
                        _addIndexToTable(selectedIndex);
                      });
                    }
                  },
          ),
        ),
      ],
    );
  }
}