part of 'connect_bloc.dart';

abstract class ConnectState extends Equatable {
  const ConnectState();

  @override
  List<Object> get props => [];
}

class ConnectInitial extends ConnectState {
  const ConnectInitial();

  @override
  List<Object> get props => [];
}

class WalletConnecting extends ConnectState {
  const WalletConnecting();

  @override
  List<Object> get props => [];
}

class WalletConnected extends ConnectState {
  const WalletConnected();

  @override
  List<Object> get props => [];
}

class WalletError extends ConnectState {
  const WalletError();

  @override
  List<Object> get props => [];
}
