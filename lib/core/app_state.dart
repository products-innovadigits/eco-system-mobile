import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:eco_system/network/mapper.dart';

abstract class AppState {
  Map<String, dynamic> toJson();
}

class Start extends AppState {
  Start();
  @override
  Map<String, dynamic> toJson() => {"state": "Start"};
}

class Done extends AppState {
  Mapper? model;
  List<Widget>? cards;
  List<Mapper>? list;
  bool? reload;
  bool? loading;
  dynamic data;

  Done(
      {this.model,
        this.data,
        this.cards,
        this.list,
        this.reload = true,
        this.loading = false});

  @override
  Map<String, dynamic> toJson() => {
    "state": "Done",
    "model": jsonEncode(model?.toJson()),
    "list": jsonEncode(list?.map((e) => e.toJson()).toList()),
    "data": data is List<dynamic>
        ? jsonEncode(data?.map((e) => e.toJson()).toList())
        : jsonEncode(model?.toJson()),
    "cards": jsonEncode(cards),
    "reload": jsonEncode(reload),
    "loading": jsonEncode(loading),
  };
}

class Error extends AppState {
  @override
  Map<String, dynamic> toJson() => {"state": "Error"};
}

class Loading extends AppState {
  int? progress;
  int? total;
  Loading({this.progress, this.total});
  @override
  Map<String, dynamic> toJson() => {"state": "Loading"};
}

class Empty extends AppState {
  final bool? initial;
  Empty({this.initial});
  @override
  Map<String, dynamic> toJson() => {"state": "Empty"};
}
