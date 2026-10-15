import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/app_colors.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/gradient_button.dart';

class EditTaskScreen extends StatefulWidget {
  final String initialTitle;
  final bool initialIsDone;

  const EditTaskScreen({
    super.key,
    required this.initialTitle,
    this.initialIsDone = false,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController titleController;

  late bool isDone;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    isDone = widget.initialIsDone;
  }

  void saveChanges() {
    String title = titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task')),
      );
      return;
    }

    Navigator.pop(context, title);
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Widget statusButton({
    required String text,
    required IconData icon,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const Gap(6),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(6),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Task',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Icon(Icons.edit_note, size: 30, color: AppColors.textDark),
              ],
            ),
            const Gap(22),
            TextField(
              controller: titleController,
              autofocus: true,
              minLines: 4,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'What needs to be done?',
                hintStyle: const TextStyle(
                  color: Color(0xFF5B6B8A),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Gap(18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                statusButton(
                  text: 'To Do',
                  icon: Icons.pending_actions,
                  color: AppColors.purple,
                  selected: !isDone,
                  onTap: () {
                    setState(() {
                      isDone = false;
                    });
                  },
                ),
                const Gap(12),
                statusButton(
                  text: 'Done',
                  icon: Icons.check_circle_outline,
                  color: AppColors.green,
                  selected: isDone,
                  onTap: () {
                    setState(() {
                      isDone = true;
                    });
                  },
                ),
              ],
            ),
            const Gap(18),
            GradientButton(
              text: 'Save changes',
              height: 54,
              onTap: saveChanges,
            ),
          ],
        ),
      ),
    );
  }
}
