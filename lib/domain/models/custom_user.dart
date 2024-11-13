import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  String uid;
  String email;
  String memberType;
  String companyName;
  String businessAddress;
  String? deliveryAddress;
  String? representativeName;
  String? businessType;
  String? businessField;
  String? uploadedFileURL;
  String? contactPersonName;
  String? contactPersonPhoneNumber;
  String? contactPersonEmail;
  Timestamp? createDate;
  String? companyTelNumber;
  String? businessRegistrationNumber;
  String? memberTypeName;
  Map<String, dynamic> notificationPreferences;
  String? partnerCompany;
  String? industryType;
  String? item;
  String? phoneNumber;
  String? faxNumber;
  String? recommendingCompany;
  String? accountNumber;
  String? bankName;
  String? paymentPreferences;
  String? transactionHistory;
  String? partnerCompanyId;
  Timestamp? modifiedDate;
  String? modifiedBy;
  bool isRequiredTermsAgreed;
  bool isPrivacyPolicyAgreed;
  bool isEmailMarketingAgreed;
  bool isSMSMarketingAgreed;
  bool isAccepted;

  CustomUser({
    required this.uid,
    required this.email,
    this.memberType = '',
    this.companyName = '',
    this.businessAddress = '',
    this.deliveryAddress,
    this.representativeName,
    this.businessType,
    this.businessField,
    this.uploadedFileURL,
    this.contactPersonName,
    this.contactPersonPhoneNumber,
    this.contactPersonEmail,
    this.createDate,
    this.companyTelNumber,
    this.businessRegistrationNumber,
    this.memberTypeName,
    required this.notificationPreferences,
    this.partnerCompany,
    this.industryType,
    this.item,
    this.phoneNumber,
    this.faxNumber,
    this.recommendingCompany,
    this.accountNumber,
    this.bankName,
    this.paymentPreferences,
    this.transactionHistory,
    this.partnerCompanyId,
    this.modifiedDate,
    this.modifiedBy,
    required this.isRequiredTermsAgreed,
    required this.isPrivacyPolicyAgreed,
    required this.isEmailMarketingAgreed,
    required this.isSMSMarketingAgreed,
    this.isAccepted = false,
  });

  factory CustomUser.fromDocument(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    try {
      return CustomUser(
        uid: doc.id,
        email: data['email'] ?? '',
        memberType: data['memberType'] ?? '',
        companyName: data['companyName'] ?? '',
        businessAddress: data['businessAddress'] ?? '',
        deliveryAddress: data['deliveryAddress'] != null ? data['deliveryAddress'] as String : null,
        representativeName: data['representativeName'] != null ? data['representativeName'] as String : null,
        businessType: data['businessType'] != null ? data['businessType'] as String : null,
        businessField: data['businessField'] != null ? data['businessField'] as String : null,
        uploadedFileURL: data['uploadedFileURL'] != null ? data['uploadedFileURL'] as String : null,
        contactPersonName: data['contactPersonName'] != null ? data['contactPersonName'] as String : null,
        contactPersonPhoneNumber: data['contactPersonPhoneNumber'] != null ? data['contactPersonPhoneNumber'] as String : null,
        contactPersonEmail: data['contactPersonEmail'] != null ? data['contactPersonEmail'] as String : null,
        createDate: data['createDate'] != null ? data['createDate'] as Timestamp : null,
        companyTelNumber: data['companyTelNumber'] != null ? data['companyTelNumber'] as String : null,
        businessRegistrationNumber: data['businessRegistrationNumber'] != null ? data['businessRegistrationNumber'] as String : null,
        memberTypeName: data['memberTypeName'] != null ? data['memberTypeName'] as String : null,
        notificationPreferences: data['notificationPreferences'] != null ? Map<String, dynamic>.from(data['notificationPreferences']) : {},
        partnerCompany: data['partnerCompany'] != null ? data['partnerCompany'] as String : null,
        industryType: data['industryType'] != null ? data['industryType'] as String : null,
        item: data['item'] != null ? data['item'] as String : null,
        phoneNumber: data['phoneNumber'] != null ? data['phoneNumber'] as String : null,
        faxNumber: data['faxNumber'] != null ? data['faxNumber'] as String : null,
        recommendingCompany: data['recommendingCompany'] != null ? data['recommendingCompany'] as String : null,
        accountNumber: data['accountNumber'] != null ? data['accountNumber'] as String : null,
        bankName: data['bankName'] != null ? data['bankName'] as String : null,
        paymentPreferences: data['paymentPreferences'] != null ? data['paymentPreferences'] as String : null,
        transactionHistory: data['transactionHistory'] != null ? data['transactionHistory'] as String : null,
        partnerCompanyId: data['partnerCompanyId'] != null ? data['partnerCompanyId'] as String : null,
        modifiedDate: data['modifiedDate'] != null ? data['modifiedDate'] as Timestamp : null,
        modifiedBy: data['modifiedBy'] != null ? data['modifiedBy'] as String : null,
        isRequiredTermsAgreed: data['isRequiredTermsAgreed'] ?? false,
        isPrivacyPolicyAgreed: data['isPrivacyPolicyAgreed'] ?? false,
        isEmailMarketingAgreed: data['isEmailMarketingAgreed'] ?? false,
        isSMSMarketingAgreed: data['isSMSMarketingAgreed'] ?? false,
        isAccepted: data['isAccepted'] ?? false,
      );
    } catch (e) {
      print("Error in fromDocument: $e");
      print("Document data: $data");
      rethrow;
    }
  }



  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'memberType': memberType,
      'companyName': companyName,
      'businessAddress': businessAddress,
      'deliveryAddress': deliveryAddress,
      'representativeName': representativeName,
      'businessType': businessType,
      'businessField': businessField,
      'uploadedFileURL': uploadedFileURL,
      'contactPersonName': contactPersonName,
      'contactPersonPhoneNumber': contactPersonPhoneNumber,
      'contactPersonEmail': contactPersonEmail,
      'createDate': createDate,
      'companyTelNumber': companyTelNumber,
      'businessRegistrationNumber': businessRegistrationNumber,
      'memberTypeName': memberTypeName,
      'notificationPreferences': notificationPreferences,
      'partnerCompany': partnerCompany,
      'industryType': industryType,
      'item': item,
      'phoneNumber': phoneNumber,
      'faxNumber': faxNumber,
      'recommendingCompany': recommendingCompany,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'paymentPreferences': paymentPreferences,
      'transactionHistory': transactionHistory,
      'partnerCompanyId': partnerCompanyId,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'isRequiredTermsAgreed': isRequiredTermsAgreed,
      'isPrivacyPolicyAgreed': isPrivacyPolicyAgreed,
      'isEmailMarketingAgreed': isEmailMarketingAgreed,
      'isSMSMarketingAgreed': isSMSMarketingAgreed,
      'isAccepted': isAccepted,
    };
  }
}
