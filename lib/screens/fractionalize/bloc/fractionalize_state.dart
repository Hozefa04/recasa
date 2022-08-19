part of 'fractionalize_bloc.dart';

abstract class FractionalizeState extends Equatable {
  const FractionalizeState();
  
  @override
  List<Object> get props => [];
}

class FractionalizeInitial extends FractionalizeState {
  const FractionalizeInitial();
  
  @override
  List<Object> get props => [];
}

class SetApprovalState extends FractionalizeState {
  const SetApprovalState();
  
  @override
  List<Object> get props => [];
}

class FractionalizationState extends FractionalizeState {
  const FractionalizationState();
  
  @override
  List<Object> get props => [];
}

class FractionalizeSuccessState extends FractionalizeState {
  const FractionalizeSuccessState();
  
  @override
  List<Object> get props => [];
}

class FractionalizeFailureState extends FractionalizeState {
  const FractionalizeFailureState();
  
  @override
  List<Object> get props => [];
}

class WalletErrorState extends FractionalizeState {
  const WalletErrorState();
  
  @override
  List<Object> get props => [];
}

class TransferTokenState extends FractionalizeState {
  const TransferTokenState();
  
  @override
  List<Object> get props => [];
}

class TransferTokenFailureState extends FractionalizeState {
  const TransferTokenFailureState();
  
  @override
  List<Object> get props => [];
}