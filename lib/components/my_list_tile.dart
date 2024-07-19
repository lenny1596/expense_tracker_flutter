import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String trailing;
  final void Function(BuildContext)? onEdit;
  final void Function(BuildContext)? onDelete;

  const MyListTile({
    super.key,
    required this.title,
    required this.trailing,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // edit option
          SlidableAction(
            onPressed: onEdit,
            icon: Icons.edit,
            backgroundColor: Colors.grey.shade800,
          ),
          // delete option
          SlidableAction(
            onPressed: onDelete,
            icon: Icons.delete,
            backgroundColor: Colors.redAccent.shade700,
          ),
        ],
      ),
      child: ListTile(
        tileColor: Colors.grey[900],
        title: Text(title),
        textColor: Colors.white,
        trailing: Text(trailing),
      ),
    );
  }
}
