class Meta {
  int? currPage;
  int? count;
  int? total;
  int? countPage;
  int? limit;
  int? lastPage;


  Meta({this.currPage, this.countPage, this.limit});

  Meta.fromJson(Map<String, dynamic> json) {
    currPage = json['current_page'];
    count = json['count'];
    total = json['total'];
    countPage = json['pages_count'];
    lastPage = json['last_page'];
    limit = json['limit'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['curr_page'] = currPage;
    data['count'] = count;
    data['total'] = total;
    data['count_page'] = countPage;
    data['last_page'] = lastPage;
    data['limit'] = limit;
    return data;
  }
}
