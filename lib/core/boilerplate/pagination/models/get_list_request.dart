import '../../../params/base_params.dart';

class GetListRequest extends BaseParams {
  int? page;
  int? results;
  // String? order;

  GetListRequest({
    this.page,
    this.results,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (page != null) data['page'] = page;
    if (results != null) data['results'] = results;
    // if (order != null) data['order'] = order;
    return data;
  }
}
