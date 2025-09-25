import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'global_state/state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GlobalState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

void _showEditLabelDialog(BuildContext context, GlobalState globalState, int index) {
  final TextEditingController controller = TextEditingController();
  controller.text = globalState.counters[index].label;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit Counter Label'),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Counter Label',
          hintText: 'Enter new label',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            globalState.updateCounterLabel(index, controller.text.trim());
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    ),
  );
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Counter List'),
            Text(
              'Drag to reorder • Double-tap title to edit',
              style: TextStyle(fontSize: 14, color: Colors.grey[300]),
            ),
          ],
        ),
      ),
      body: globalState.counters.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No counters yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Tap the + button to add one',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ReorderableListView.builder(
              itemCount: globalState.counters.length,
              onReorder: (oldIndex, newIndex) {
                globalState.reorderCounters(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final counter = globalState.counters[index];
                return Card(
                  key: ValueKey(counter.hashCode),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  color: counter.color,
                  child: InkWell(
                    onTap: () {
                      globalState.changeCounterColor(index);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.drag_handle,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onDoubleTap: () {
                                    _showEditLabelDialog(context, globalState, index);
                                  },
                                  child: Text(
                                    counter.label,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    'Value: ${counter.value}',
                                    key: ValueKey(counter.value),
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                radius: 20,
                                child: IconButton(
                                  icon: Icon(Icons.remove, color: Colors.white, size: 18),
                                  onPressed: () {
                                    globalState.decrementCounter(index);
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                radius: 20,
                                child: IconButton(
                                  icon: Icon(Icons.add, color: Colors.white, size: 18),
                                  onPressed: () {
                                    globalState.incrementCounter(index);
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                radius: 20,
                                child: IconButton(
                                  icon: Icon(Icons.edit, color: Colors.white, size: 18),
                                  onPressed: () {
                                    _showEditLabelDialog(context, globalState, index);
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              CircleAvatar(
                                backgroundColor: Colors.red.withOpacity(0.3),
                                radius: 20,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.white, size: 18),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete Counter'),
                                          content: Text('Are you sure you want to delete "${counter.label}"?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                globalState.removeCounter(index);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          globalState.addCounter();
        },
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Icon(Icons.add, key: ValueKey(globalState.counters.length)),
        ),
        tooltip: 'Add new counter',
      ),
    );
  }
}