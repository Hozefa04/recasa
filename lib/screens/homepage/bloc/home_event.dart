part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadNFTs extends HomeEvent {
  final String address;
  const LoadNFTs(this.address);

  @override
  List<Object> get props => [address];
}