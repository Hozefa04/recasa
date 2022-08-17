import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web3/flutter_web3.dart';

part 'connect_event.dart';
part 'connect_state.dart';

class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {
  String? address;
  int? chainId;

  String? get walletAddress => address;
  set setAddress(String walletAddress) => address = walletAddress;

  ConnectBloc() : super(const ConnectInitial()) {
    on<ConnectWallet>((event, emit) async => _connectWallet(event, emit));
  }

  Future<void> _connectWallet(
      ConnectWallet event, Emitter<ConnectState> emit) async {
    emit(const WalletConnecting());
    try {
      if (ethereum != null) {
        try {
          final accs = await ethereum!.requestAccount();
          if (accs[0].isNotEmpty) {
            address = accs[0];
            print(accs[0]);
            emit(const WalletConnected());
          } else {
            emit(const WalletError());
          }
        } on EthereumUserRejected {
          print('User rejected the modal');
        }
      }
    } catch (e) {
      debugPrint("Wallet connect error: " + e.toString());
      emit(const WalletError());
    }
  }
}
