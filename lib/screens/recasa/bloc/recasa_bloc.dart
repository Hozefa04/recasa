import 'package:alchemy_web3/alchemy_web3.dart';
import 'package:bloc/bloc.dart';
// ignore: implementation_imports
import 'package:either_dart/src/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../utils/app_strings.dart';

part 'recasa_event.dart';
part 'recasa_state.dart';

class RecasaBloc extends Bloc<RecasaEvent, RecasaState> {
  RecasaBloc() : super(const RecasaInitial()) {
    on<LoadRecasaNFTs>((event, emit) async => _loadRecasaNFTs(event, emit));
  }

  Future<void> _loadRecasaNFTs(
      LoadRecasaNFTs event, Emitter<RecasaState> emit) async {
    try {
      emit(const NFTsLoading());
      final alchemy = Alchemy();
      alchemy.init(
        httpRpcUrl: AppStrings.polygonEndpoint,
        wsRpcUrl: AppStrings.webSocketUrl,
        verbose: true,
      );

      final Either<RpcResponse, EnhancedNFTResponse> result =
          await alchemy.enhanced.nft.getNFTs(
        owner: event.address,
      );

      if (result.right.ownedNfts.length > 0) {
        var recasaNFTs = result.right.ownedNfts.where((nft) {
          return nft.contract.address ==
              "0x57197bdc4ad36dfb4f22849dd5a2b437cd02192a";
        }).toList();
        emit(NFTsLoaded(
          recasaNFTs,
          recasaNFTs.length,
        ));
      } else {
        emit(const EmptyNFTs());
      }
    } catch (e) {
      emit(const NFTsError());
      debugPrint("NFT Load Error: " + e.toString());
    }
  }
}
