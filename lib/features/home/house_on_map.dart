import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:finder/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/constant/end_points/api_url.dart';
import 'package:finder/core/data_source/remote_data_source.dart';
import 'package:finder/core/http/http_method.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finder/core/params/base_params.dart';
import 'package:finder/core/repository/core_repository.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/core/usecase/usecase.dart';
import 'package:finder/core/utils/app_router.dart';
import 'package:finder/features/home/integration/house_model/house_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Add Geolocator package
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Add Google Maps package

class CustomMapRepository extends CoreRepository {
  Future<Result<ListHouseModel>> getMapHouse(
      {required GetMapHouseParams params}) async {
    final result = await RemoteDataSource.request(
      responseStr: 'ListMapHouse',
      queryParameters: params.toJson(),
      converter: (json) => ListHouseModel.fromJson(json['data']),
      method: HttpMethod.GET,
      url: getMapHouseUrl,
    );
    return call(result: result);
  }
}

class GetMapHouseParams extends BaseParams {
  final double lat;
  final double lon;
  final double raduis;
  GetMapHouseParams({
    required this.lat,
    required this.lon,
    required this.raduis,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'lat': 35,
      'lon': 140,
      'radius': 111,
    };
  }
}

class GetMapHouseUsecase extends UseCase<ListHouseModel, GetMapHouseParams> {
  final CustomMapRepository customMapRepository;
  GetMapHouseUsecase({
    required this.customMapRepository,
  });
  @override
  Future<Result<ListHouseModel>> call({required GetMapHouseParams params}) {
    return customMapRepository.getMapHouse(params: params);
  }
}

class CustomMapView extends StatefulWidget {
  const CustomMapView({super.key});

  @override
  _CustomMapViewState createState() => _CustomMapViewState();
}

class _CustomMapViewState extends State<CustomMapView> {
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(36.19, 43.99),
    zoom: 12.0,
  );

  Position? _currentPosition;
  BitmapDescriptor? _markerIcon;
  bool _isMarkerIconLoaded = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isMarkerIconLoaded) {
      _isMarkerIconLoaded = true;
      _loadMarkerIcon();
    }
  }

  Future<void> _loadMarkerIcon() async {
    try {
      final Uint8List markerImage = await _getBytesFromAsset(
        Assets.imagesHousePin,
        50,
      );
      _markerIcon = BitmapDescriptor.fromBytes(markerImage);
      if (mounted) setState(() {});
    } catch (e) {
      print('Error loading marker icon: $e');
      _markerIcon = BitmapDescriptor.defaultMarker;
    }
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    final ByteData data = await DefaultAssetBundle.of(context).load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
      _initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );
    });

    final controller = await _mapController.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GetModel(
                    useCaseCallBack: () {
                      return GetMapHouseUsecase(
                              customMapRepository: CustomMapRepository())
                          .call(
                        params: GetMapHouseParams(
                          lat: _currentPosition!.latitude,
                          lon: _currentPosition!.longitude,
                          raduis: 12,
                        ),
                      );
                    },
                    onError: () => const Text('Something went wronge'),
                    loading: const Center(child: CircularProgressIndicator()),
                    errorWidget: const Text('Something went wronge'),
                    onSuccess: (ListHouseModel houses) {
                      _markers.clear();
                      for (var House in houses.data) {
                        // for (var loc in House.location ?? []) {
                        _markers.add(
                          Marker(
                            markerId: MarkerId(
                                "${House.id}-${House.locationGeo?.coordinates?[0]}-${House.locationGeo?.coordinates?[1]}"),
                            position: LatLng(
                              double.tryParse(
                                      House.locationGeo?.coordinates?[0] ??
                                          '0') ??
                                  0,
                              double.tryParse(
                                      House.locationGeo?.coordinates?[1] ??
                                          '0') ??
                                  0,
                            ),
                            icon: _markerIcon ?? BitmapDescriptor.defaultMarker,
                            onTap: () {
                              // Show dialog or navigate to House
                              _showMarkerDialog(House, context);
                            },
                          ),
                        );
                        // }
                      }
                      setState(() {});
                    },
                    modelBuilder: (model) {
                      return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height - 32,
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            _mapController.complete(controller);
                          },
                          initialCameraPosition: _initialCameraPosition,
                          markers: _markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _showMarkerDialog(HouseModel house, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(house.title ?? 'No title'),
          actions: [
            TextButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                  GoRouter.of(context)
                      .push(AppRouter.kHouseDetailes, extra: house);
                },
                child: const Text('Open')),
          ],
        );
      },
    );
  }
}
