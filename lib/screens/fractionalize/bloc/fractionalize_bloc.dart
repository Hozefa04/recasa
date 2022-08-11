import 'package:bloc/bloc.dart';
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
    // walletAddress = BlocProvider.of<ConnectBloc>(event.context).walletAddress;
    walletAddress = "0x8f4cb4272c6ac594553199c4bc42658cff66e5e1";
    if (walletAddress != null) {
      // await AppMethods.setApproval(event.contract);
      try {
        await AppMethods.setApproval(event.contract);
      } catch (e) {
        debugPrint("Fractionalize error: " + e.toString());
        emit(const FractionalizeFailureState());
      }
    } else {
      emit(const WalletErrorState());
    }
  }
}
