import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/app_colors.dart';
import '../database/firestore_service.dart';
import '../database/task.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/count_card.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService service = FirestoreService();

  late final Stream<List<Task>> tasksStream = service.getTasks();

  void addTask(String title) {
    service.addTask(title);
  }

  void toggleTask(Task task) {
    service.updateStatus(task.id!, !task.isDone);
  }

  void deleteTask(Task task) {
    service.deleteTask(task.id!);
  }

  void editTask(Task task, String newTitle) {
    service.updateTitle(task.id!, newTitle);
  }

  Future<void> openAddTaskScreen() async {
    String? title = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (title != null) {
      addTask(title);
    }
  }

  Future<void> openEditTaskScreen(Task task) async {
    String? newTitle = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(initialTitle: task.title),
      ),
    );

    if (newTitle != null) {
      editTask(task, newTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(),
      body: StreamBuilder<List<Task>>(
        stream: tasksStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong\n${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Task> tasks = snapshot.data!;
          int doneCount = tasks.where((t) => t.isDone).length;
          int todoCount = tasks.length - doneCount;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome ${widget.userName}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textDark,
                        ),
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          CountCard(
                            color: AppColors.green,
                            icon: Icons.check_box_outlined,
                            count: doneCount,
                            label: 'Done',
                          ),
                          const Gap(8),
                          CountCard(
                            color: AppColors.purple,
                            icon: Icons.pending_actions,
                            count: todoCount,
                            label: 'To-Do',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                if (tasks.isEmpty)
                  Container(
                    width: double.infinity,
                    height: 160,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No tasks for today!',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(4),
                        Text(
                          'Tap the + button to add your first one.',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          task: tasks[index],
                          onTap: () => toggleTask(tasks[index]),
                          onLongPress: () => deleteTask(tasks[index]),
                          onEdit: () => openEditTaskScreen(tasks[index]),
                          onDelete: () => deleteTask(tasks[index]),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: InkWell(
        onTap: openAddTaskScreen,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Icon(Icons.note_add_outlined, color: Colors.white),
        ),
      ),
    );
  }
}
