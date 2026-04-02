import 'package:ats_system/jobs/model/jobs_model.dart';
import 'package:ats_system/talent_pool/model/candidate_model.dart';

/// Marketing prototype payloads (no API).

Map<String, dynamic> _prototypeJobJson(
  int id,
  String title, {
  required List<Map<String, dynamic>> stages,
}) =>
    {
      'id': id,
      'title': title,
      'description':
          'Lead cross-functional initiatives and deliver measurable outcomes for our enterprise customers.',
      'address': 'Riyadh / Hybrid',
      'chance_type': 'Full-time',
      'department': 'Engineering',
      'work_place': 'Hybrid',
      'status': 'Open',
      'level': 'Senior',
      'created_at': '2026-01-15',
      'stages': stages,
    };

List<Map<String, dynamic>> _defaultStages({
  required int applied,
  required int interview,
  required int offer,
}) =>
    [
      {'type': 'Applied', 'count': applied, 'color': '#1565C0', 'width': '1'},
      {'type': 'Interview', 'count': interview, 'color': '#00897B', 'width': '1'},
      {'type': 'Offer', 'count': offer, 'color': '#F9A825', 'width': '1'},
    ];

JobsModel buildPrototypeJobsModel() {
  final jobs = [
    _prototypeJobJson(
      101,
      'Senior Flutter Engineer',
      stages: _defaultStages(applied: 44, interview: 12, offer: 3),
    ),
    _prototypeJobJson(
      102,
      'Product Designer',
      stages: _defaultStages(applied: 19, interview: 7, offer: 1),
    ),
    _prototypeJobJson(
      103,
      'Talent Acquisition Partner',
      stages: _defaultStages(applied: 58, interview: 22, offer: 5),
    ),
  ];
  return JobsModel.fromJson({
    'data': jobs,
    'status_code': 200,
    'message': 'OK',
    'meta': {
      'current_page': 1,
      'count': jobs.length,
      'total': jobs.length,
      'pages_count': 1,
      'last_page': 1,
      'limit': 20,
    },
  });
}

Map<String, dynamic> prototypeCandidateListItem(int id) => {
      'id': id,
      'name': id == 1
          ? 'Layla Al-Mansouri'
          : id == 2
              ? 'Omar Haddad'
              : 'Nadia Rahman',
      'email': 'candidate$id@prototype.eco',
      'phone': '+966500000$id',
      'status': 'Active',
      'source': 'LinkedIn',
      'chances_count': 2,
      'job_title': id == 1
          ? 'Mobile Lead'
          : id == 2
              ? 'UX Designer'
              : 'Data Analyst',
      'created_at': '2026-02-01',
      'created_at_listed_view': 'Feb 2026',
      'tags': [
        {'id': 1, 'name': 'Flutter'},
        {'id': 2, 'name': 'Agile'},
      ],
      'matching': <dynamic>[],
    };

TalentPoolModel buildPrototypeTalentPoolModel() {
  final items = [1, 2, 3, 4].map(prototypeCandidateListItem).toList();
  return TalentPoolModel.fromJson({
    'data': items,
    'status_code': 200,
    'message': 'OK',
    'meta': {
      'current_page': 1,
      'count': items.length,
      'total': items.length,
      'pages_count': 1,
      'last_page': 1,
      'limit': 20,
    },
  });
}

Map<String, dynamic> prototypeCandidateProfile(int id) => {
      'id': id,
      'name': 'Layla Al-Mansouri',
      'email': 'layla@prototype.eco',
      'phone': '+966501112233',
      'status': 'Screening',
      'source': 'Referral',
      'chances_count': 3,
      'job_title': 'Senior Mobile Engineer',
      'created_at': '2026-01-20',
      'created_at_listed_view': 'Jan 2026',
      'tags': [
        {'id': 3, 'name': 'Leadership'},
      ],
      'matching': <dynamic>[],
      'resume': {
        'id': 1,
        'name': 'cv.pdf',
        'original_name': 'Layla_CV.pdf',
        'url': 'https://example.com/cv.pdf',
        'mime_type': 'application/pdf',
        'type': 'resume',
        'size': 240000,
        'ext': 'pdf',
        'created_at': '2026-01-20',
      },
      'profile': {
        'gender': 'Female',
        'expected_salary': 28000,
        'location': 'Riyadh',
        'notice_period': '30 days',
        'linkedin': 'https://linkedin.com/in/prototype',
        'skills': ['Flutter', 'Dart', 'Bloc', 'CI/CD'],
        'education': [
          {
            'degree': 'B.Sc. Computer Science',
            'school': 'KFUPM',
            'field_study': 'CS',
            'start_date': '2014',
            'end_date': '2018',
          },
        ],
        'experience': [
          {
            'title': 'Lead Engineer',
            'company': 'Eco Systems',
            'start_date': '2021-03',
            'end_date': null,
            'industry': 'Technology',
          },
        ],
        'certificates': [],
      },
    };
