part of 'connect_bloc.dart';

abstract class ConnectEvent extends Equatable {
  const ConnectEvent();

  @override
  List<Object> get props => [];
}

class ConnectWallet extends ConnectEvent {
  const ConnectWallet();

  @override
  List<Object> get props => [];
}