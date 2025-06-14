import 'package:bloc/bloc.dart';
import 'package:finder/features/home/presentation/widget/search_news_integration.dart';
import 'package:finder/features/price_predication/presentation/backend_integration.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  int choiseIndex = 0;
  PredictHouseParams params = PredictHouseParams();
  SearchNewsParams searchParams = SearchNewsParams();

  // Method to update the choice index and emit a new state
  void updateChoiceIndex(int newIndex) {
    choiseIndex = newIndex;
    emit(HomeUpdated(choiseIndex)); // Emit a new state to trigger a UI update
  }

  void updateSearchParams({
    String? q,
    num? minPrice,
    String? listingType,
  }) {
    searchParams = SearchNewsParams(
      q: q ?? searchParams.q,
      minPrice: minPrice ?? searchParams.minPrice,
      listingType: listingType ?? searchParams.listingType,
    );
    emit(HomeSearchParamsUpdated(searchParams));
  }

  void updateParams({
    String? priceCategory,
    String? type,
    String? furnishing,
    String? completionStatus,
    String? community,
    String? city,
    int? sizeSqft,
    int? totalRooms,
    int? propertyAge,
  }) {
    params = PredictHouseParams(
      priceCategory: priceCategory ?? params.priceCategory,
      type: type ?? params.type,
      furnishing: furnishing ?? params.furnishing,
      completionStatus: completionStatus ?? params.completionStatus,
      community: community ?? params.community,
      city: city ?? params.city,
      sizeSqft: sizeSqft ?? params.sizeSqft,
      totalRooms: totalRooms ?? params.totalRooms,
      propertyAge: propertyAge ?? params.propertyAge,
    );
    emit(HomeParamsUpdated(params));
  }
}
