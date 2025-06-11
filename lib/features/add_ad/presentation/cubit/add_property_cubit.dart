import 'package:bloc/bloc.dart';
import 'package:finder/features/add_ad/data/usecase/add_ad_usecase.dart';
import 'package:meta/meta.dart';

part 'add_property_state.dart';

class AddPropertyCubit extends Cubit<AddPropertyState> {
  AddPropertyCubit() : super(AddPropertyInitial());
  AddAdParams params = AddAdParams(
    description: null,
    listingType: null,
    location: null,
    pics: null,
    price: null,
    title: null,
  );
  void updateAddParams(AddAdParams newParams) {
    params = newParams;
    emit(AddAdParamsUpdate(params: params));
  }
}
