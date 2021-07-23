import 'dart:async';

Timer setTimeout(callback, [int duration = 800]) {
  return Timer(Duration(milliseconds: duration), callback);
}

void clearTimeout(Timer t) {
  t.cancel();
}
