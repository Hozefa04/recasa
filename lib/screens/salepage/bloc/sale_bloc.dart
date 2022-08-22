import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recasa/utils/app_methods.dart';

import '../../landing/bloc/connect_bloc.dart';

part 'sale_event.dart';
part 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  String? walletAddress;
  SaleBloc() : super(const SaleInitial()) {
    on<GetNFTInfo>((event, emit) async => _loadNFT(event, emit));
    on<AddForSale>((event, emit) async => _addForSale(event, emit));
  }

  Future<void> _loadNFT(GetNFTInfo event, Emitter<SaleState> emit) async {
    emit(const NFTLoadingState());
    try {
      walletAddress = BlocProvider.of<ConnectBloc>(event.context).walletAddress;
      if (walletAddress != null) {
        DocumentSnapshot doc = await AppMethods.getRecasaNFT(
          event.nftId,
          walletAddress!,
        );
        emit(NFTLoadedState(doc));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(const NFTLoadErrorState());
    }
  }

  Future<void> _addForSale(AddForSale event, Emitter<SaleState> emit) async {
    emit(const NFTForSaleState());
    try {
      walletAddress = BlocProvider.of<ConnectBloc>(event.context).walletAddress;
      if (walletAddress != null) {
        await AppMethods.addForSale(
          event.doc,
          event.price,
          walletAddress!,
        );
        emit(const NFTForSaleAddedState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(const NFTForSaleErrorState());
    }
  }
}
