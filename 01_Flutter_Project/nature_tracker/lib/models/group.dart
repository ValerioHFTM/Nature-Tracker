import 'package:nature_tracker/models/trash_bin.dart';

class Group {
  final String name;
  final List<TrashBin> trashBins;

  Group({required this.name}) : trashBins = [];

  bool isAnyBinFull() {
    return trashBins.any((bin) => bin.isFull);
  }
}
