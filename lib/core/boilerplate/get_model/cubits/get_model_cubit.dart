import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../results/result.dart';

part 'get_model_state.dart';

typedef UsecaseCallBack = Future<Result> Function(); //dynamic data:params

class GetModelCubit<Model> extends Cubit<GetModelState> {
  final UsecaseCallBack getData;
  GetModelCubit(this.getData) : super(GetModelInitial());

  getModel() async {
    emit(Loading());
    Result response;
    try {
      response =
          await getData(); // response = await GetExampleUseCase(ExampleRepository()).call(params: params);
      if (response.hasDataOnly) {
        // print(
        // 'success only response response errrorrrrr is : ${response.error}');
        emit(GetModelSuccessfully(model: response.data));
      } else if (response.hasErrorOnly) {
        // print(
        // 'errror only response response errrorrrrr is : ${response.error}');
        emit(Error(message: response.error ?? ''));
      } else {
        // print('errrorrrrr is : $response');
        emit(Error(message: 'some thing went wrong'));
      }
    } catch (e) {
      // print('sssss is : $e');
      emit(Error(message: 'some thing went wrong $e'));
    }
  }
}
