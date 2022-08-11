part of 'fractionalize_bloc.dart';

abstract class FractionalizeEvent extends Equatable {
  const FractionalizeEvent();

  @override
  List<Object> get props => [];
}

class FractionalizeNFT extends FractionalizeEvent {
  final String fractions;
  final String contract;
  final String tokenId;
  const FractionalizeNFT(this.fractions, this.contract, this.tokenId);

  @override
  List<Object> get props => [fractions, contract, tokenId];
}
