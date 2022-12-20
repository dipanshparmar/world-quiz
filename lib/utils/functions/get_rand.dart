import 'dart:math';

dynamic getRand(List<dynamic> list) {
  return list[Random().nextInt(list.length)];
}
