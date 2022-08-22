part of 'sale_bloc.dart';

abstract class SaleState extends Equatable {
  const SaleState();
  
  @override
  List<Object> get props => [];
}

class SaleInitial extends SaleState {
  const SaleInitial();
  
  @override
  List<Object> get props => [];
}

class NFTLoadingState extends SaleState {
  const NFTLoadingState();
  
  @override
  List<Object> get props => [];
}

class NFTLoadedState extends SaleState {
  final DocumentSnapshot doc;
  const NFTLoadedState(this.doc);
  
  @override
  List<Object> get props => [doc];
}

class NFTLoadErrorState extends SaleState {
  const NFTLoadErrorState();
  
  @override
  List<Object> get props => [];
}

class NFTForSaleState extends SaleState {
  const NFTForSaleState();
  
  @override
  List<Object> get props => [];
}

class NFTForSaleAddedState extends SaleState {
  const NFTForSaleAddedState();
  
  @override
  List<Object> get props => [];
}

class NFTForSaleErrorState extends SaleState {
  const NFTForSaleErrorState();
  
  @override
  List<Object> get props => [];
}
