part of 'sale_bloc.dart';

abstract class SaleEvent extends Equatable {
  const SaleEvent();

  @override
  List<Object> get props => [];
}

class GetNFTInfo extends SaleEvent {
  final String nftId;
  final BuildContext context;
  const GetNFTInfo(this.nftId, this.context);

  @override
  List<Object> get props => [nftId, context];
}

class AddForSale extends SaleEvent {
  final DocumentSnapshot doc;
  final String price;
  final BuildContext context;
  const AddForSale(this.doc, this.price, this.context);

  @override
  List<Object> get props => [doc, price, context];
}
