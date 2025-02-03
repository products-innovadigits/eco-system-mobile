
abstract class AppEvent {
  Object? arguments;

  AppEvent(this.arguments);
}

class Click extends AppEvent {
  Click({Object? arguments}) : super(arguments);
}

class GetTenants extends AppEvent {
  GetTenants({Object? arguments}) : super(arguments);
}

class GetTenantTypes extends AppEvent{
  GetTenantTypes({Object? arguments}) : super(arguments);
}

class Filter extends AppEvent{
  Filter(Object? arguments) : super(arguments);
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

class GetInvoices extends AppEvent{
  GetInvoices({Object? arguments}) : super(arguments);
}

class GetProperties extends AppEvent {
  GetProperties({Object? arguments}) : super(arguments);
}

class GetUnitDetails extends AppEvent{
  GetUnitDetails({Object? arguments}) : super(arguments);
}

class GetAllPayments extends AppEvent{
  GetAllPayments({Object? arguments}) : super(arguments);
}

class ChangePayment extends AppEvent{
  ChangePayment({Object? arguments}) : super(arguments);
}

class Approve extends AppEvent{
  Approve({Object? arguments}) : super(arguments);
}
class Cancel extends AppEvent{
  Cancel({Object? arguments}) : super(arguments);
}
class Receipt extends AppEvent{
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
