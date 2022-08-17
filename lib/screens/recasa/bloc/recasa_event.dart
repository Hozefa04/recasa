part of 'recasa_bloc.dart';

abstract class RecasaEvent extends Equatable {
  const RecasaEvent();

  @override
  List<Object> get props => [];
}

class LoadRecasaNFTs extends RecasaEvent {
  final String address;
  const LoadRecasaNFTs(this.address);

  @override
  List<Object> get props => [address];
}