import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class TalentPoolModel extends SingleMapper {
  List<CandidateModel>? data;
  int? statusCode;
  String? message;
  Meta? meta;

  TalentPoolModel({
    this.data,
    this.statusCode,
    this.message,
    this.meta,
  });

  TalentPoolModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(CandidateModel.fromJson(v));
      });
    }
    statusCode = json['status_code'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return TalentPoolModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.map((e) => e.toJson()).toList();
    }
    data['status_code'] = statusCode;
    data['message'] = message;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class CandidateModel extends SingleMapper {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? status;
  String? source;
  int? chancesCount;
  String? jobTitle;
  String? createdAt;
  String? createdAtListedView;
  bool? addTag;
  String? tagValue;
  List<CurrencyModel>? tags;
  LastChanceModel? lastChance;
  List<dynamic>? matching;
  ResumeModel? resume;
  ProfileModel? profile;

  CandidateModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.status,
    this.source,
    this.chancesCount,
    this.jobTitle,
    this.createdAt,
    this.createdAtListedView,
    this.addTag,
    this.tagValue,
    this.tags,
    this.lastChance,
    this.matching,
    this.resume,
    this.profile,
  });

  CandidateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    status = json['status'];
    source = json['source'];
    chancesCount = json['chances_count'];
    jobTitle = json['job_title'];
    createdAt = json['created_at'];
    createdAtListedView = json['created_at_listed_view'];
    addTag = json['addTag'];
    tagValue = json['tagValue'];
    tags = json['tags'] != null
        ? (json['tags'] as List).map((e) => CurrencyModel.fromJson(e)).toList()
        : [];
    lastChance = json['last_chance'] != null
        ? LastChanceModel.fromJson(json['last_chance'])
        : null;
    matching = json['matching'] ?? [];
    resume =
        json['resume'] != null ? ResumeModel.fromJson(json['resume']) : null;
    profile =
        json['profile'] != null ? ProfileModel.fromJson(json['profile']) : null;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CandidateModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['status'] = status;
    data['source'] = source;
    data['chances_count'] = chancesCount;
    data['job_title'] = jobTitle;
    data['created_at'] = createdAt;
    data['created_at_listed_view'] = createdAtListedView;
    data['addTag'] = addTag;
    data['tagValue'] = tagValue;
    data['tags'] = tags != null ? tags!.map((e) => e.toJson()).toList() : [];
    if (lastChance != null) data['last_chance'] = lastChance!.toJson();
    data['matching'] = matching;
    if (resume != null) data['resume'] = resume!.toJson();
    if (profile != null) data['profile'] = profile!.toJson();
    return data;
  }
}

class ResumeModel {
  int? id;
  String? name;
  String? originalName;
  String? url;
  String? mimeType;
  String? type;
  dynamic parentId;
  int? size;
  String? ext;
  dynamic width;
  dynamic height;
  String? createdAt;
  String? createdTime;
  String? updatedAt;

  ResumeModel({
    this.id,
    this.name,
    this.originalName,
    this.url,
    this.mimeType,
    this.type,
    this.parentId,
    this.size,
    this.ext,
    this.width,
    this.height,
    this.createdAt,
    this.createdTime,
    this.updatedAt,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'],
      name: json['name'],
      originalName: json['original_name'],
      url: json['url'],
      mimeType: json['mime_type'],
      type: json['type'],
      parentId: json['parent_id'],
      size: json['size'],
      ext: json['ext'],
      width: json['width'],
      height: json['height'],
      createdAt: json['created_at'],
      createdTime: json['created_time'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'original_name': originalName,
        'url': url,
        'mime_type': mimeType,
        'type': type,
        'parent_id': parentId,
        'size': size,
        'ext': ext,
        'width': width,
        'height': height,
        'created_at': createdAt,
        'created_time': createdTime,
        'updated_at': updatedAt,
      };
}

class ProfileModel {
  String? gender;
  dynamic expectedSalary;
  CurrencyModel? currency;
  String? location;
  dynamic noticePeriod;
  String? linkedin;
  List<EducationModel>? education;
  List<ExperienceModel>? experience;
  List<CertificateModel>? certificates;
  List<String>? skills;
  String? createdAt;

  ProfileModel({
    this.gender,
    this.expectedSalary,
    this.currency,
    this.location,
    this.noticePeriod,
    this.linkedin,
    this.education,
    this.experience,
    this.certificates,
    this.skills,
    this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      gender: json['gender'],
      expectedSalary: json['expected_salary'],
      currency: json['currency'] != null
          ? CurrencyModel.fromJson(json['currency'])
          : null,
      location: json['location'],
      noticePeriod: json['notice_period'],
      linkedin: json['linkedin'],
      education: (json['education'] as List?)
          ?.map((e) => EducationModel.fromJson(e))
          .toList(),
      experience: (json['experience'] as List?)
          ?.map((e) => ExperienceModel.fromJson(e))
          .toList(),
      certificates: (json['certificates'] as List?)
          ?.map((e) => CertificateModel.fromJson(e))
          .toList(),
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'gender': gender,
        'expected_salary': expectedSalary,
        'currency': currency?.toJson(),
        'location': location,
        'notice_period': noticePeriod,
        'linkedin': linkedin,
        'education': education?.map((e) => e.toJson()).toList(),
        'experience': experience?.map((e) => e.toJson()).toList(),
        'certificates': certificates?.map((e) => e.toJson()).toList(),
        'skills': skills,
        'created_at': createdAt,
      };
}

class EducationModel {
  String? degree;
  String? school;
  String? endDate;
  String? startDate;
  String? fieldStudy;

  EducationModel(
      {this.degree,
      this.school,
      this.endDate,
      this.startDate,
      this.fieldStudy});

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      degree: json['degree'],
      school: json['school'],
      endDate: json['end_date'],
      startDate: json['start_date'],
      fieldStudy: json['field_study'],
    );
  }

  Map<String, dynamic> toJson() => {
        'degree': degree,
        'school': school,
        'end_date': endDate,
        'start_date': startDate,
        'field_study': fieldStudy,
      };
}

class ExperienceModel {
  String? title;
  String? company;
  String? endDate;
  String? industry;
  String? startDate;

  ExperienceModel(
      {this.title, this.company, this.endDate, this.industry, this.startDate});

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      title: json['title'],
      company: json['company'],
      endDate: json['end_date'],
      industry: json['industry'],
      startDate: json['start_date'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'company': company,
        'end_date': endDate,
        'industry': industry,
        'start_date': startDate,
      };
}

class CertificateModel {
  String? date;
  String? name;
  String? orginization;

  CertificateModel({this.date, this.name, this.orginization});

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      date: json['date'],
      name: json['name'],
      orginization: json['orginization'],
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'name': name,
        'orginization': orginization,
      };
}

class CurrencyModel {
  dynamic id;
  dynamic name;

  CurrencyModel({this.id, this.name});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class LastChanceModel {
  int? id;
  String? name;
  int? stageId;
  String? stageName;
  String? stageColor;
  String? stageType;

  LastChanceModel({
    this.id,
    this.name,
    this.stageId,
    this.stageName,
    this.stageColor,
    this.stageType,
  });

  factory LastChanceModel.fromJson(Map<String, dynamic> json) {
    return LastChanceModel(
      id: json['id'],
      name: json['name'],
      stageId: json['stage_id'],
      stageName: json['stage_name'],
      stageColor: json['stage_color'],
      stageType: json['stage_type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'stage_id': stageId,
        'stage_name': stageName,
        'stage_color': stageColor,
        'stage_type': stageType,
      };
}
