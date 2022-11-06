import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
part 'rider_map_state.dart';
class RiderMapCubit extends Cubit<RiderMapState>{
  RiderMapCubit():super(const Initial());

 Future<void> getData()async{
    emit(const Loading());
    await Future.delayed(const Duration(milliseconds: 1400),(){
      log(1.00);
    });
    emit(Loaded());
  }


}