part of '../RiderMap/rider_map_controller.dart';

abstract class RiderMapState{
const RiderMapState();
}


class Initial extends RiderMapState {
  const Initial();
}

class Loading extends RiderMapState {
  const Loading();
}

class Loaded extends RiderMapState {

}

class Error extends RiderMapState {}