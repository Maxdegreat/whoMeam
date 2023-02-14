import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whomeam/enums/bottom_nav.dart';

part 'bottomnav_state.dart';

class BottomnavCubit extends Cubit<BottomnavState> {
  BottomnavCubit()
      : super(const BottomnavState(
            selectedItem: BottomNavItem.feed, showBottomNav: true));

  void showBottomNav(bool b) => emit(state.copyWith(showBottomNav: b));

  void updateSelectedItem(BottomNavItem item) {
    if (item != state.selectedItem) {
      emit(BottomnavState(selectedItem: item, showBottomNav: true));
    }
  }
}
