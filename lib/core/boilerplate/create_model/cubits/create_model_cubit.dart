import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../results/result.dart';

part 'create_model_state.dart';

typedef UsecaseCallBack = Future<Result>? Function(dynamic data);

class CreateModelCubit<Model> extends Cubit<CreateModelState> {
  final UsecaseCallBack getData;
  CreateModelCubit(this.getData) : super(CreateModelInitial());

  // Create model method
  createModel({dynamic requestData}) async {
    emit(Loading());
    try {
      Result? response = await getData(requestData);

      // Check the response data
      if (response != null) {
        if (response.hasDataOnly) {
          print('qqqqqqq ${response.error}');
          emit(CreateModelSuccessfully(model: response.data));
        } else if (response.hasErrorOnly) {
          // If the response contains an error, emit the error message
          print('sssssss ${response.error}');
          String errorMessage = response.error ?? 'Something went wrong';
          emit(Error(message: errorMessage, error: response.error));
        } else {
          print('aaaaaa ${response.error}');
          emit(Error(message: 'Something went wrong'));
        }
      } else {
        emit(CreateModelInitial());
      }
    } catch (e) {
      // Emit error if exception occurs
      String errorMessage = e.toString();
      emit(Error(message: errorMessage));
    }
  }
}
