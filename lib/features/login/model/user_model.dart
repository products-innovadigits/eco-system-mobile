import 'package:eco_system/network/mapper.dart';

class UserModel extends SingleMapper {
  String? accessToken;
  int? expiresIn;
  GSettings? gSettings;
  int? agentId;
  String? firstName;
  String? userId;
  String? middleName;
  String? lastName;
  String? scope;
  String? message;
  UserData? userData;
  Permissions? permissions;

  UserModel(
      {this.accessToken,
      this.expiresIn,
      this.gSettings,
      this.agentId,
      this.firstName,
      this.middleName,
      this.userId,
      this.lastName,
      this.message,
      this.scope,
      this.permissions,
      this.userData});

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    print(json["user_data"]);
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    message = json['message'];
    gSettings = json['g_settings'] != null
        ? new GSettings.fromJson(json['g_settings'])
        : null;
    agentId = json['agent_id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    scope = json['scope'];
    userData =
        json["user_data"] != null ? UserData.fromJson(json["user_data"]) : null;
    permissions =
        json["permissions"] != null ? Permissions.fromJson(json["permissions"]) : null;
    return UserModel(
        accessToken: accessToken,
        expiresIn: expiresIn,
        scope: scope,
        firstName: firstName,
        message: message,
        middleName: middleName,
        lastName: lastName,
        agentId: agentId,
        userId: userId,
        gSettings: gSettings,
        permissions: permissions,
        userData: userData);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    if (this.gSettings != null) {
      data['g_settings'] = this.gSettings!.toJson();
    }
    data['agent_id'] = this.agentId;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['scope'] = this.scope;
    data['user_id'] = this.userId;
    data["user_data"] = this.userData;
    data["permissions"] = this.permissions;
    return data;
  }
}

class GSettings {
  String? id;
  String? companyName;
  String? companyType;
  String? email;
  String? currency;
  String? phone;
  String? physicalAddress;
  String? postalAddress;
  String? websiteUrl;
  String? postalCode;
  String? logo;
  dynamic favicon;
  String? dateFormat;
  String? amountThousandSeparator;
  String? amountDecimalSeparator;
  String? amountDecimal;
  String? theme;
  dynamic language;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  GSettings(
      {this.id,
      this.companyName,
      this.companyType,
      this.email,
      this.currency,
      this.phone,
      this.physicalAddress,
      this.postalAddress,
      this.websiteUrl,
      this.postalCode,
      this.logo,
      this.favicon,
      this.dateFormat,
      this.amountThousandSeparator,
      this.amountDecimalSeparator,
      this.amountDecimal,
      this.theme,
      this.language,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  GSettings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    companyType = json['company_type'];
    email = json['email'];
    currency = json['currency'];
    phone = json['phone'];
    physicalAddress = json['physical_address'];
    postalAddress = json['postal_address'];
    websiteUrl = json['website_url'];
    postalCode = json['postal_code'];
    logo = json['logo'];
    favicon = json['favicon'];
    dateFormat = json['date_format'];
    amountThousandSeparator = json['amount_thousand_separator'];
    amountDecimalSeparator = json['amount_decimal_separator'];
    amountDecimal = json['amount_decimal'];
    theme = json['theme'];
    language = json['language'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['company_type'] = this.companyType;
    data['email'] = this.email;
    data['currency'] = this.currency;
    data['phone'] = this.phone;
    data['physical_address'] = this.physicalAddress;
    data['postal_address'] = this.postalAddress;
    data['website_url'] = this.websiteUrl;
    data['postal_code'] = this.postalCode;
    data['logo'] = this.logo;
    data['favicon'] = this.favicon;
    data['date_format'] = this.dateFormat;
    data['amount_thousand_separator'] = this.amountThousandSeparator;
    data['amount_decimal_separator'] = this.amountDecimalSeparator;
    data['amount_decimal'] = this.amountDecimal;
    data['theme'] = this.theme;
    data['language'] = this.language;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class UserData {
  UserData({
    this.id,
    this.agentId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.phone,
    this.email,
    this.registrationDate,
    this.idNumber,
    this.city,
    this.state,
    this.country,
    this.postalAddress,
    this.physicalAddress,
    this.residentialAddress,
    this.confirmed,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.rememberToken,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.nationalEstablishmentNo,
    this.representative,
    this.representativeId,
  });

  String? id;
  dynamic agentId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? phone;
  String? email;
  String? registrationDate;
  String? idNumber;
  String? city;
  String? state;
  String? country;
  String? postalAddress;
  String? physicalAddress;
  String? residentialAddress;
  int? confirmed;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  dynamic rememberToken;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? nationalEstablishmentNo;
  String? representative;
  String? representativeId;

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agentId = json['agent_id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    registrationDate = json['registration_date'];
    idNumber = json['id_number'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalAddress = json['postal_address'];
    physicalAddress = json['physical_address'];
    residentialAddress = json['residential_address'];
    confirmed = json['confirmed'];
    createdBy = json['created_by'];
    updatedBy = json['created_by'];
    deletedBy = json['deleted_by'];
    rememberToken = json['remember_token'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    nationalEstablishmentNo = json['national_establishment_no'];
    representative = json['representative'];
    representativeId = json['representative_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['agent_id'] = agentId;
    _data['first_name'] = firstName;
    _data['middle_name'] = middleName;
    _data['last_name'] = lastName;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['registration_date'] = registrationDate;
    _data['id_number'] = idNumber;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    _data['postal_address'] = postalAddress;
    _data['physical_address'] = physicalAddress;
    _data['residential_address'] = residentialAddress;
    _data['confirmed'] = confirmed;
    _data['created_by'] = createdBy;
    _data['updated_by'] = updatedBy;
    _data['deleted_by'] = deletedBy;
    _data['remember_token'] = rememberToken;
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['national_establishment_no'] = nationalEstablishmentNo;
    _data['representative'] = representative;
    _data['representative_id'] = representativeId;
    return _data;
  }
}






class Permissions {
  bool? editTenant;
  bool? cancelPayment;
  bool? approvePayment;
  bool? editLandlord;
  bool? manageSetting;
  bool? editProperty;
  bool? viewNotice;
  bool? viewInvoice;
  bool? createProperty;
  bool? createReading;
  bool? terminateLease;
  bool? createPayment;
  bool? editLease;
  bool? deleteLease;
  bool? deleteTenant;
  bool? viewPayment;
  bool? editProfile;
  bool? viewTenant;
  bool? deleteNotice;
  bool? viewReport;
  bool? createLandlord;
  bool? createTenant;
  bool? deleteProperty;
  bool? viewLease;
  bool? viewProperty;
  bool? createNotice;
  bool? waiveInvoice;
  bool? createLease;
  bool? deleteLandlord;
  bool? editReading;
  bool? viewReading;
  bool? editNotice;
  bool? deleteReading;
  bool? viewLandlord;

  Permissions(
      {this.editTenant,
        this.cancelPayment,
        this.approvePayment,
        this.editLandlord,
        this.manageSetting,
        this.editProperty,
        this.viewNotice,
        this.viewInvoice,
        this.createProperty,
        this.createReading,
        this.terminateLease,
        this.createPayment,
        this.editLease,
        this.deleteLease,
        this.deleteTenant,
        this.viewPayment,
        this.editProfile,
        this.viewTenant,
        this.deleteNotice,
        this.viewReport,
        this.createLandlord,
        this.createTenant,
        this.deleteProperty,
        this.viewLease,
        this.viewProperty,
        this.createNotice,
        this.waiveInvoice,
        this.createLease,
        this.deleteLandlord,
        this.editReading,
        this.viewReading,
        this.editNotice,
        this.deleteReading,
        this.viewLandlord});

  Permissions.fromJson(Map<String, dynamic> json) {
    editTenant = json['edit-tenant'] ?? false;
    cancelPayment = json['cancel-payment'] ?? false;
    approvePayment = json['approve-payment'] ?? false;
    editLandlord = json['edit-landlord'] ?? false;
    manageSetting = json['manage-setting'] ?? false;
    editProperty = json['edit-property'] ?? false;
    viewNotice = json['view-notice']?? false;
    viewInvoice = json['view-invoice']?? false;
    createProperty = json['create-property']?? false;
    createReading = json['create-reading']?? false;
    terminateLease = json['terminate-lease']?? false;
    createPayment = json['create-payment']?? false;
    editLease = json['edit-lease']?? false;
    deleteLease = json['delete-lease']?? false;
    deleteTenant = json['delete-tenant']?? false;
    viewPayment = json['view-payment']?? false;
    editProfile = json['edit-profile']?? false;
    viewTenant = json['view-tenant']?? false;
    deleteNotice = json['delete-notice']?? false;
    viewReport = json['view-report']?? false;
    createLandlord = json['create-landlord']?? false;
    createTenant = json['create-tenant']?? false;
    deleteProperty = json['delete-property']?? false;
    viewLease = json['view-lease']?? false;
    viewProperty = json['view-property']?? false;
    createNotice = json['create-notice']?? false;
    waiveInvoice = json['waive-invoice']?? false;
    createLease = json['create-lease']?? false;
    deleteLandlord = json['delete-landlord']?? false;
    editReading = json['edit-reading']?? false;
    viewReading = json['view-reading']?? false;
    editNotice = json['edit-notice']?? false;
    deleteReading = json['delete-reading']?? false;
    viewLandlord = json['view-landlord']?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['edit-tenant'] = this.editTenant;
    data['cancel-payment'] = this.cancelPayment;
    data['approve-payment'] = this.approvePayment;
    data['edit-landlord'] = this.editLandlord;
    data['manage-setting'] = this.manageSetting;
    data['edit-property'] = this.editProperty;
    data['view-notice'] = this.viewNotice;
    data['view-invoice'] = this.viewInvoice;
    data['create-property'] = this.createProperty;
    data['create-reading'] = this.createReading;
    data['terminate-lease'] = this.terminateLease;
    data['create-payment'] = this.createPayment;
    data['edit-lease'] = this.editLease;
    data['delete-lease'] = this.deleteLease;
    data['delete-tenant'] = this.deleteTenant;
    data['view-payment'] = this.viewPayment;
    data['edit-profile'] = this.editProfile;
    data['view-tenant'] = this.viewTenant;
    data['delete-notice'] = this.deleteNotice;
    data['view-report'] = this.viewReport;
    data['create-landlord'] = this.createLandlord;
    data['create-tenant'] = this.createTenant;
    data['delete-property'] = this.deleteProperty;
    data['view-lease'] = this.viewLease;
    data['view-property'] = this.viewProperty;
    data['create-notice'] = this.createNotice;
    data['waive-invoice'] = this.waiveInvoice;
    data['create-lease'] = this.createLease;
    data['delete-landlord'] = this.deleteLandlord;
    data['edit-reading'] = this.editReading;
    data['view-reading'] = this.viewReading;
    data['edit-notice'] = this.editNotice;
    data['delete-reading'] = this.deleteReading;
    data['view-landlord'] = this.viewLandlord;
    return data;
  }
}