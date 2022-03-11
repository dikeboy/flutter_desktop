import 'package:flutter/material.dart';
import 'package:flutter_desktop/base/BasicPage.dart';
import 'package:undo_textfield/undo_textfield.dart';
class  UndoTextField extends BasicState {
  var urlController = RedoTextEditController();

  @override
  void initState() {
    super.initState();
    urlController.initState();

  }
  @override
  Widget createContent() {
    return TextField(
      controller: urlController,
      focusNode: urlController.forcusNode,
      decoration: InputDecoration(
        labelText: 'ctrl+z undo ctrl+shift+z redo',
      ),
    );
  }

}