part of 'recasa_bloc.dart';

abstract class RecasaState extends Equatable {
  const RecasaState();

  @override
  List<Object> get props => [];
}

class RecasaInitial extends RecasaState {
  const RecasaInitial();

  @override
  List<Object> get props => [];
}

class NFTsLoading extends RecasaState {
  const NFTsLoading();

  @override
  List<Object> get props => [];
}

class NFTsLoaded extends RecasaState {
  final List<EnhancedNFT> nfts;
  final int length;
  const NFTsLoaded(this.nfts, this.length);

  @override
  List<Object> get props => [nfts, length];
}

class EmptyNFTs extends RecasaState {
  const EmptyNFTs();

  @override
  List<Object> get props => [];
}

class NFTsError extends RecasaState {
  const NFTsError();

  @override
  List<Object> get props => [];
}
