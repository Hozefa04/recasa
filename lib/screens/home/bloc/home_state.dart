part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
  
  @override
  List<Object> get props => [];
}

class NFTsLoading extends HomeState {
  const NFTsLoading();
  
  @override
  List<Object> get props => [];
}

class NFTsLoaded extends HomeState {
  const NFTsLoaded();
  
  @override
  List<Object> get props => [];
}

class EmptyNFTs extends HomeState {
  const EmptyNFTs();
  
  @override
  List<Object> get props => [];
}

class NFTsError extends HomeState {
  const NFTsError();
  
  @override
  List<Object> get props => [];
}
