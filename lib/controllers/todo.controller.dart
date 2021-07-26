import 'package:get/get.dart';
import 'package:my_app/models/todo.model.dart';
import 'package:my_app/services/todo.service.dart';

class TodoController extends GetxController {
  var todos = RxList<MTodo>();
  RxBool isLoading = false.obs;

  Future getList() async {
    try {
      isLoading = true.obs;
      final result = await TodoService.getTodos();
      result.sort((a, b) {
        return DateTime.parse(b.createdAt)
            .compareTo(DateTime.parse(a.createdAt));
      });
      // ignore: invalid_use_of_protected_member
      todos.value = result.value;
      isLoading = false.obs;
    } catch (e) {
      throw ("getList error");
    }
  }

  void add() {}

  Future<void> changeStatus(id, status) async {
    try {
      await TodoService.updateStatus({'id': id, 'status': status});
      var index = todos.indexWhere((todo) => todo.id == id);
      if (index < 0) return;
      todos[index].status = status;
      todos.refresh();
    } catch (e) {
      throw ("getList error");
    }
  }

  Future<void> delete(id) async {
    try {
      await TodoService.deleteTodo(id);
      var index = todos.indexWhere((todo) => todo.id == id);
      if (index < 0) return;
      todos.removeAt(index);
    } catch (e) {
      print("Error _deleteTodo");
    }
  }
}
