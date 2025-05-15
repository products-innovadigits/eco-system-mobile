import 'package:eco_system/utility/export.dart';

abstract class AppEvent {
  Object? arguments;

  AppEvent(this.arguments);
}

class Click extends AppEvent {
  Click({Object? arguments}) : super(arguments);
}

class Select extends AppEvent {
  Select({Object? arguments}) : super(arguments);
}

class Sort extends AppEvent {
  Sort({Object? arguments}) : super(arguments);
}

class SelectTab extends AppEvent {
  SelectTab({Object? arguments}) : super(arguments);
}

class ShowDialog extends AppEvent {
  ShowDialog({Object? arguments}) : super(arguments);
}

class onTechSkillRate extends AppEvent {
  onTechSkillRate({Object? arguments}) : super(arguments);
}

class onKnowledgeRate extends AppEvent {
  onKnowledgeRate({Object? arguments}) : super(arguments);
}

class onCommunicationRate extends AppEvent {
  onCommunicationRate({Object? arguments}) : super(arguments);
}

class SelectTalent extends AppEvent {
  SelectTalent({Object? arguments}) : super(arguments);
}

class Remember extends AppEvent {
  Remember({Object? arguments}) : super(arguments);
}

class Expand extends AppEvent {
  Expand({Object? arguments}) : super(arguments);
}

class ToggleExpand extends AppEvent {
  ToggleExpand({Object? arguments}) : super(arguments);
}

class GetTenants extends AppEvent {
  GetTenants({Object? arguments}) : super(arguments);
}

class GetTenantTypes extends AppEvent {
  GetTenantTypes({Object? arguments}) : super(arguments);
}

class Filter extends AppEvent {
  Filter(super.arguments);
}

class Restart extends AppEvent {
  Restart({Object? arguments}) : super(arguments);
}

class Clear extends AppEvent {
  Clear({Object? arguments}) : super(arguments);
}

class Update extends AppEvent {
  Update({Object? arguments}) : super(arguments);
}

class Join extends AppEvent {
  Join({Object? arguments}) : super(arguments);
}

class Leave extends AppEvent {
  Leave({Object? arguments}) : super(arguments);
}

class RequestOperation extends AppEvent {
  RequestOperation({Object? arguments}) : super(arguments);
}

class DelegationUsers extends AppEvent {
  DelegationUsers({Object? arguments}) : super(arguments);
}

class FollowResponse extends AppEvent {
  FollowResponse({Object? arguments}) : super(arguments);
}

class GroupFollowRequest extends AppEvent {
  GroupFollowRequest({Object? arguments}) : super(arguments);
}

class Reverse extends AppEvent {
  Reverse({Object? arguments}) : super(arguments);
}

class Collapse extends AppEvent {
  Collapse({Object? arguments}) : super(arguments);
}

class GetUserStatus extends AppEvent {
  GetUserStatus({Object? arguments}) : super(arguments);
}

class GetTec extends AppEvent {
  GetTec({Object? arguments}) : super(arguments);
}

class GetSupportData extends AppEvent {
  GetSupportData({Object? arguments}) : super(arguments);
}

class GetGroupInfo extends AppEvent {
  GetGroupInfo({Object? arguments}) : super(arguments);
}

class ChangeView extends AppEvent {
  ChangeView({Object? arguments}) : super(arguments);
}

class GetSelfService extends AppEvent {
  GetSelfService({Object? arguments}) : super(arguments);
}

class GetNotification extends AppEvent {
  GetNotification({Object? arguments}) : super(arguments);
}

class GetDashboard extends AppEvent {
  GetDashboard({Object? arguments}) : super(arguments);
}

class GetInvoices extends AppEvent {
  GetInvoices({Object? arguments}) : super(arguments);
}

class GetProperties extends AppEvent {
  GetProperties({Object? arguments}) : super(arguments);
}

class GetUnitDetails extends AppEvent {
  GetUnitDetails({Object? arguments}) : super(arguments);
}

class GetAllPayments extends AppEvent {
  GetAllPayments({Object? arguments}) : super(arguments);
}

class ChangePayment extends AppEvent {
  ChangePayment({Object? arguments}) : super(arguments);
}

class Approve extends AppEvent {
  Approve({Object? arguments}) : super(arguments);
}

class Cancel extends AppEvent {
  Cancel({Object? arguments}) : super(arguments);
}

class Receipt extends AppEvent {
  Receipt({Object? arguments}) : super(arguments);
}

class GetProfile extends AppEvent {
  GetProfile({Object? arguments}) : super(arguments);
}

class ResendCode extends AppEvent {
  ResendCode({Object? arguments}) : super(arguments);
}

class AddToFav extends AppEvent {
  AddToFav({Object? arguments}) : super(arguments);
}

class InitCandidates extends AppEvent {
  final String? targetStage;
  final List<StageModel>? stages;
  final String? jobTitle;

  InitCandidates(
      {this.targetStage, this.stages, this.jobTitle})
      : super(null);
}

class ExpandSkills extends AppEvent {
  ExpandSkills({Object? arguments}) : super(arguments);
}

class ExpandKeywords extends AppEvent {
  ExpandKeywords({Object? arguments}) : super(arguments);
}

class PickSkill extends AppEvent {
  PickSkill({Object? arguments}) : super(arguments);
}

class PickKeyword extends AppEvent {
  PickKeyword({Object? arguments}) : super(arguments);
}

class RemoveSkill extends AppEvent {
  RemoveSkill({Object? arguments}) : super(arguments);
}

class RemoveKeywords extends AppEvent {
  RemoveKeywords({Object? arguments}) : super(arguments);
}

class TapSearch extends AppEvent {
  TapSearch({Object? arguments}) : super(arguments);
}

class Searching extends AppEvent {
  Searching({Object? arguments}) : super(arguments);
}

class CancelSearch extends AppEvent {
  CancelSearch({Object? arguments}) : super(arguments);
}

class UpdateRating extends AppEvent {
  final int index;
  final int rating;

  UpdateRating({required this.index, required this.rating}) : super(null);
}

class AddComment extends AppEvent {
  final int index;
  final String comment;

  AddComment({required this.index, required this.comment}) : super(null);
}

class ToggleCommentField extends AppEvent {
  final int index;

  ToggleCommentField({required this.index}) : super(null);
}
