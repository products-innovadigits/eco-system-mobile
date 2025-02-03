class SearchEngine{
  String? query;
  String? id;
  int? currentPage;
  String? filter;
  Object? object ;
  var baseId="";
  bool isLoading = true ;
  SearchEngine(this.baseId,{this.query , this.id ,this.filter = "", this.isLoading = true ,this.currentPage =0 , this.object});
  SearchEngine.withNoId({this.query ,this.currentPage = 0,this.filter = "",  this.object} );

  updateCurrentPage(int page)=> this.currentPage = page;

  toJson(){
    Map data = {};
    data["query"] = query ;
    data["baseId"] = baseId ;
    data["id"] = id ;
    data["current_page"] = currentPage ;
    return data ;
  }
}