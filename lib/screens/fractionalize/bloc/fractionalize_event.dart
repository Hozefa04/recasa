part of 'fractionalize_bloc.dart';

abstract class FractionalizeEvent extends Equatable {
  const FractionalizeEvent();

  @override
  List<Object> get props => [];
}

class FractionalizeNFT extends FractionalizeEvent {
  final BuildContext context;
  final String fractions;
  final String contract;
  final String tokenId;
  final String uri;
  final String nftImage;
  final String nftName;
  final String nftDescription;
  const FractionalizeNFT(
    this.context,
    this.fractions,
    this.contract,
    this.tokenId,
    this.uri,
    this.nftImage,
    this.nftName,
    this.nftDescription,
  );

  @override
  List<Object> get props => [
        context,
        fractions,
        contract,
        tokenId,
        uri,
        nftImage,
        nftName,
        nftDescription,
      ];
}
