class Filter {
  final String? filterType;
  bool isSelected;
  Filter({this.filterType, this.isSelected = false});
}

List<Filter> filterList = [
  Filter(
    filterType: "A-Z",
  ),
  Filter(filterType: "Temp ↑"),
  Filter(filterType: "Temp ↓"),
];
List<Filter> selectedFilterList = [];
