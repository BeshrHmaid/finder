// import 'package:flutter/cupertino.dart';
// import '../data_source/model.dart';
//
// class ModelsFactory {
//   // Singleton handling.
//   static ModelsFactory? _instance;
//
//   static ModelsFactory? getInstance() {
//     if (_instance != null) return _instance;
//     _instance = ModelsFactory();
//     return _instance;
//   }
//
//   // Mapping each model name with the actual value using fromJson factory method.
//   final Map<String, dynamic Function(Map<String, dynamic>)> _modelsMap = {};
//
//   // Register the model in the map.
//   void registerModel(
//     String modelName,
//     dynamic Function(Map<String, dynamic>) modelCreator,
//   ) {
//     debugPrint('in register $modelName');
//     //_modelsMap.putIfAbsent(modelName, () => modelCreator);
//     _modelsMap.update(
//       modelName,
//       (value) => modelCreator,
//       ifAbsent: () => modelCreator,
//     );
//   }
//
//   // Generate the desired T model.
//   T createModel<T>(json, {required String strString, bool? withOutResponse}) {
//     try {
//       if (withOutResponse != null)
//       {
//         if (withOutResponse) {
//           return BaseModel as T;
//         } else {
//           final modelName = T.toString();
//           debugPrint('T value : $T');
//           debugPrint('in create model : ${T.toString()} , ${_modelsMap.containsKey(modelName)}');
//           assert(_modelsMap.containsKey(modelName));
//           final model = _modelsMap[modelName]!(json) as T;
//           return model;
//         }
//       }
//       else {
//         final modelName = T.toString();
//         debugPrint('T value : $T');
//         debugPrint('strString value : $strString');
//         debugPrint('in create model : ${T.toString()} , ${_modelsMap.containsKey(strString)}');
//         assert(_modelsMap.containsKey(strString));
//         final model = (_modelsMap[strString]!(json) as T);
//         return model;
//       }
//     } catch (e) {
//       debugPrint('exceed(models.factory) : $e');
//       rethrow;
//     }
//   }
// }
