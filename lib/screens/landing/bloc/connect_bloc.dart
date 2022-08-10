import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import '../../../utils/app_methods.dart';

part 'connect_event.dart';
part 'connect_state.dart';

class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {
  String? address;
  int? chainId;
  SessionStatus? sessionStatus;

  String? get walletAddress => address;

  ConnectBloc() : super(const ConnectInitial()) {
    on<ConnectWallet>((event, emit) async => _connectWallet(event, emit));
  }

  Future<void> _connectWallet(
      ConnectWallet event, Emitter<ConnectState> emit) async {
    emit(const WalletConnecting());
    try {
      await connectWallet();
      if (sessionStatus?.accounts[0] != null) {
        emit(const WalletConnected());
      } else {
        emit(const WalletError());
      }
    } catch (e) {
      debugPrint("Wallet connect error: " + e.toString());
      emit(const WalletError());
    }
  }

  Future<void> connectWallet() async {
    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'Recasa',
        description: 'Recasa Developer App',
        // url: 'https://unitaslink.com/',
        // icons: [
        //   'https://unitaslink.com/wp-content/uploads/2022/05/SiteLogo.png'
        // ],
      ),
    );

    // Subscribe to events
    connector.on('connect', (session) {
      debugPrint("connect: " + session.toString());

      address = sessionStatus?.accounts[0];
      chainId = sessionStatus?.chainId;

      debugPrint("Address: " + address!);
      debugPrint("Chain Id: " + chainId.toString());
    });

    connector.on('session_request', (payload) {
      debugPrint("session request: " + payload.toString());
    });

    connector.on('disconnect', (session) {
      debugPrint("disconnect: " + session.toString());
    });

    // Create a new session
    if (!connector.connected) {
      sessionStatus = await connector.createSession(
        chainId: 137,
        onDisplayUri: (uri) {
          AppMethods.openUrl(uri);
        },
      );
    }
  }
}
