import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'fractionalize_event.dart';
part 'fractionalize_state.dart';

class FractionalizeBloc extends Bloc<FractionalizeEvent, FractionalizeState> {
  FractionalizeBloc() : super(FractionalizeInitial()) {
    on<FractionalizeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
