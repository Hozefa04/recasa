import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recasa/screens/landing/bloc/connect_bloc.dart';
import 'package:recasa/utils/app_methods.dart';

part 'fractionalize_event.dart';
part 'fractionalize_state.dart';

class FractionalizeBloc extends Bloc<FractionalizeEvent, FractionalizeState> {
  String? walletAddress;

  FractionalizeBloc() : super(const FractionalizeInitial()) {
    on<FractionalizeNFT>((event, emit) async => _fractionalize(event, emit));
  }

  Future<void> _fractionalize(
      FractionalizeNFT event, Emitter<FractionalizeState> emit) async {
    emit(const SetApprovalState());
    walletAddress = BlocProvider.of<ConnectBloc>(event.context).walletAddress;
    // walletAddress = "0x8F4cb4272c6AC594553199c4bc42658cFF66E5E1";
    if (walletAddress != null) {
      // try {
      //   emit(const SetApprovalState());
      //   await AppMethods.setApproval(event.contract, walletAddress!);
      //   try {
      //     emit(const TransferTokenState());
      //     // String newTokenId = AppMethods.getTokenId(event.tokenId);
      //     String newTokenId = int.parse(event.tokenId.substring(2), radix: 16).toString();
      //     await AppMethods.transferMainToken(
      //       event.contract,
      //       BigInt.from(int.parse(newTokenId)),
      //       walletAddress!,
      //     );
      //     try {
      //       emit(const FractionalizationState());
      //       await AppMethods.fractionalize(
      //         BlocProvider.of<ConnectBloc>(event.context).walletAddress!,
      //         BigInt.from(int.parse(event.fractions)),
      //         event.uri,
      //       );
      //     } catch (e) {
      //       debugPrint("Mint error: " + e.toString());
      //       emit(const FractionalizeFailureState());
      //     }
      //   } catch (e) {
      //     debugPrint("Transfer error: " + e.toString());
      //     emit(const TransferTokenFailureState());
      //   }

      // } catch (e) {
      //   debugPrint("Approval error: " + e.toString());
      //   emit(const FractionalizeFailureState());
      // }
      emit(const FractionalizationState());
      await AppMethods.storeData(event.contract, event.tokenId);
      await AppMethods.fractionalize(
        BlocProvider.of<ConnectBloc>(event.context).walletAddress!,
        BigInt.from(int.parse(event.fractions)),
        event.uri,
      );
      emit(const FractionalizeSuccessState());
    } else {
      emit(const WalletErrorState());
    }
  }
}
