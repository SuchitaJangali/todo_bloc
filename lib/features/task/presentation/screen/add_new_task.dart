import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_new/core/extension/context_extensions.dart';
import 'package:todo_bloc_new/features/task/domain/entities/category.dart';
import 'package:todo_bloc_new/features/task/domain/entities/task.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      );
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formkey = GlobalKey<FormState>();
  String tittle = "";
  String selectedPriority = '1';
  Category? selectedCategory;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            context.read<TaskBloc>().add(const GetAllTasksEvents());
            Navigator.pop(context);
          },
        ),
        // title: const Text("Add Task", style: TextStyle(color: Colors.white)),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskFailure) {
            return Center(child: Text(state.error));
          } else if (state is TaskSuccess) {
            if (state.tasks?.isEmpty ?? false) {
              return const Center(child: Text('No tasks available.'));
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tittle",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Enter Task Title",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.trim().isNotEmpty) tittle = value;
                      },
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Please enter tittle ";
                        }
                        tittle = value!;
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Task Date (S
                    GestureDetector(
                      onTap: () => _pickDate(context),
                      child: _StaticFormRow(
                        icon: Icons.access_time,
                        label: "Task Date",
                        value:
                            "${selectedDate.day.toString().padLeft(2, '0')} - "
                            "${selectedDate.month.toString().padLeft(2, '0')} - "
                            "${selectedDate.year}",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Task Category (Dropdown)
                    InkWell(
                      onTap: () {
                        showCategoryPickerDialog(
                          context: context,
                          categories: state.category ?? [],
                          onCategorySelected: (category) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.category, size: 20, color: Colors.white),
                          const SizedBox(width: 12),
                          Text("Task Category",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white70)),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                if (selectedCategory?.imagePath?.isNotEmpty ??
                                    false)
                                  Image(
                                      height: 30,
                                      width: 30,
                                      color: Color(
                                          selectedCategory?.color ?? 0000),
                                      image: AssetImage(
                                          selectedCategory?.imagePath ?? "")),
                                SizedBox(width: 8),
                                Text(selectedCategory?.name ?? ""),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Task Priority (Dropdown)
                    _DropdownFormRow(
                      icon: Icons.flag_outlined,
                      label: "Task Priority",
                      value: selectedPriority,
                      items: ['1', '2', '3'],
                      onChanged: (val) =>
                          setState(() => selectedPriority = val!),
                    ),

                    const Spacer(),

                    // Add Task Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!(_formkey.currentState?.validate() ?? false)) {
                            return;
                          }
                          if (selectedCategory == null || (tittle.isEmpty)) {
                            return context.showError("Please Select Category");
                          }
                          _formkey.currentState?.save();
                          context.read<TaskBloc>().add(AddTaskEvent(Task(
                                title: tittle,
                                description: 'hey',
                                isCompleted: false,
                                createdAt: selectedDate,
                                category: selectedCategory ?? Category(),
                                priority: int.parse(selectedPriority),
                              )));
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Add Task",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Welcome to your task manager!'));
          }
        },
      ),
    );
  }
}

void showCategoryPickerDialog({
  required BuildContext context,
  required List<Category> categories,
  required Function(Category) onCategorySelected,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Category',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Close dialog
                      onCategorySelected(category); // Return selected
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Color(category.color ?? 0000).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              height: 40,
                              width: 40,
                              category.imagePath ?? "assets/img/img.png",
                              color: Color(category.color ?? 0xFF000000),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          category.name ?? "",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}

// Static (non-interactive) form row
class _StaticFormRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StaticFormRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.white),
        const SizedBox(width: 12),
        Text(label,
            style: const TextStyle(fontSize: 16, color: Colors.white70)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(value, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class _DropdownFormRow extends StatelessWidget {
  final IconData icon;
  final String? value;
  final String label;
  final List<String?> items;
  final ValueChanged<String?> onChanged;

  const _DropdownFormRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isValidValue = value != null && items.contains(value);

    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.white),
        const SizedBox(width: 12),
        Text(label,
            style: const TextStyle(fontSize: 16, color: Colors.white70)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButton<String>(
            value: isValidValue ? value : null, // ✅ Fix: avoid mismatched value
            dropdownColor: Colors.grey[900],
            underline: const SizedBox(),
            icon: const Icon(Icons.flag_outlined, color: Colors.white),
            style: const TextStyle(color: Colors.white),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item ?? ""),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
