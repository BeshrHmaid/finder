import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../results/result.dart';
import '../models/get_list_request.dart';

part 'pagination_state.dart';

typedef RepositoryCallBack = Future<Result>? Function(dynamic data);

class PaginationCubit<ListModel> extends Cubit<PaginationState> {
  final RepositoryCallBack getData;

  PaginationCubit(this.getData) : super(PaginationInitial());
  List<ListModel> list = [];
  Map<String, dynamic> params = {};
  int results = 10;
  int page = 0;

  getList({bool loadMore = false}) async {
    if (!loadMore) {
      page = 0;
      emit(Loading());
    } else {
      page++;
    }

    var requestData = GetListRequest(
      results: results,
      page: page,
    );
    var response = await getData(requestData);

    if (response == null) {
      emit(PaginationInitial());
    } else {
      if (response.hasDataOnly) {
        if (loadMore) {
          list.addAll(response.data);
        } else {
          if (kDebugMode) {
            print(response.data);
          }
          list = response.data;
        }

        emit(GetListSuccessfully(
            list: list.toSet().toList(),
            noMoreData:
                (response.data.toSet().toList() as List<ListModel>).isEmpty &&
                    loadMore));
      } else if (response.hasErrorOnly) {
        if (response.error != null) {
          emit(Error(response.error ?? ''));
        }
        emit(Error('Some Thing went wrong'));
      } else {
        emit(PaginationInitial());
      }
    }
  }
}
