part of 'bottomnav_cubit.dart';

class BottomnavState extends Equatable {
  final BottomNavItem selectedItem;
  final bool showBottomNav;

  const BottomnavState(
      {required this.selectedItem, required this.showBottomNav});

  @override
  List<Object> get props => [
        selectedItem,
        showBottomNav,
      ];

  BottomnavState copyWith({
    BottomNavItem? selectedItem,
    bool? showBottomNav,
  }) {
    return BottomnavState(
        selectedItem: selectedItem ?? this.selectedItem,
        showBottomNav: showBottomNav ?? this.showBottomNav);
  }
}
