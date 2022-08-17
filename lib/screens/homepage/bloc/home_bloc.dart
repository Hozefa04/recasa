import 'package:alchemy_web3/alchemy_web3.dart';
import 'package:bloc/bloc.dart';
// ignore: implementation_imports
import 'package:either_dart/src/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../utils/app_strings.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<LoadNFTs>((event, emit) async => _loadNFTs(event, emit));
  }

  Future<void> _loadNFTs(LoadNFTs event, Emitter<HomeState> emit) async {
    try {
      emit(const NFTsLoading());
      final alchemy = Alchemy();
      alchemy.init(
        httpRpcUrl: AppStrings.polygonEndpoint,
        wsRpcUrl: AppStrings.webSocketUrl,
        verbose: true,
      );

      final Either<RpcResponse, EnhancedNFTResponse> result =
          await alchemy.enhanced.nft.getNFTs(owner: event.address);

      if (result.right.ownedNfts.length > 0) {
        emit(NFTsLoaded(
          result.right.ownedNfts,
          result.right.ownedNfts.length,
        ));
      } else {
        emit(const EmptyNFTs());
      }
    } catch (e) {
      debugPrint("NFT Load Error: " + e.toString());
    }
  }
}
