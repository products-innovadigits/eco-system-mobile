import 'package:flutter/cupertino.dart';
import 'package:eco_system/main_pages/models/status_model.dart';
import 'package:eco_system/network/mapper.dart';

abstract class AppState {}

class Start extends AppState {}

class Done extends AppState {
  Mapper? model;
  List<Widget>? cards;
  List<dynamic>? list;
  bool? reload;
  bool? loading;

  Done({this.model, this.cards, this.list, this.reload = true , this.loading = false});
}


class FollowResponseDone extends AppState {
  Mapper? model;

  FollowResponseDone({this.model});
}

class UserInfoDoneState extends AppState {
  final Mapper? model;
  final List<Widget>? requestsCard;
  final List<Widget>? shortCutsCard;

  UserInfoDoneState({this.requestsCard, this.shortCutsCard, this.model});
}

class GroupsDoneState extends AppState {
  List<Widget>? cards;
  List<Widget>? otherCards;

  GroupsDoneState({this.cards, this.otherCards});
}

class GroupInfoDoneState extends AppState {
  List<Widget>? cards;

  GroupInfoDoneState({this.cards});
}

class FindUserDoneState extends AppState {
  List<Widget>? cards;

  FindUserDoneState({this.cards});
}

class FindUserPageDoneState extends AppState {
  List<Widget>? followingListCards;
  List<Widget>? recentSearchCards;

  FindUserPageDoneState({this.recentSearchCards, this.followingListCards});
}

class SettingDoneState extends AppState {
  List<Widget>? cards;

  SettingDoneState({this.cards});
}

class MoreRequestsDoneState extends AppState {
  List<Widget>? cards;

  MoreRequestsDoneState({this.cards});
}

class NotificationDoneState extends AppState {
  List<Widget>? cards;

  NotificationDoneState({this.cards});
}

class SingleUserRequestDoneState extends AppState {
  List<Widget>? myRequests;
  List<Widget>? otherRequests;
  List<StatusModel>? status;

  SingleUserRequestDoneState(
      {this.myRequests, this.otherRequests, this.status});
}

class RequestsDoneState extends AppState {
  List<Widget>? requests;

  RequestsDoneState({this.requests});
}

class ApprovalsDoneState extends AppState {
  List<Widget>? approvals;

  ApprovalsDoneState({this.approvals});
}

class Error extends AppState {}

class Loading extends AppState {}

class Empty extends AppState {
  final bool? initial;

  Empty({this.initial});
}
