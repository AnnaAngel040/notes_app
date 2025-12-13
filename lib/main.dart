import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_page.dart';
import 'services/notes_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('notesBox');
  await Hive.openBox('authBox');

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
      ),
      home: AuthGate(),
    );
  }
}

// ----------------------------------------------------------
// AUTH GATE
// ----------------------------------------------------------
class AuthGate extends StatelessWidget {
  AuthGate({super.key});
  final authBox = Hive.box('authBox');

  @override
  Widget build(BuildContext context) {
    final currentUser = authBox.get('currentUser');
    return currentUser != null ? const NotesHomePage() : const LoginPage();
  }
}

// ----------------------------------------------------------
// NOTES PAGE
// ----------------------------------------------------------
class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  final NotesService notesService = NotesService();

  List<String> notes = [];
  List<String> filteredNotes = [];

  final TextEditingController noteController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
    searchController.addListener(filterNotes);
  }

  void _loadNotes() {
    notes = notesService.getNotes();
    filteredNotes = List.from(notes);
  }

  // ---------------- SEARCH ----------------
  void filterNotes() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredNotes = notes
          .where((n) => n.toLowerCase().contains(query))
          .toList();
    });
  }

  // ---------------- ADD ----------------
  void addNote() {
    if (noteController.text.isNotEmpty) {
      setState(() {
        notesService.addNote(noteController.text);
        _loadNotes();
        filterNotes();
      });
      noteController.clear();
      Navigator.pop(context);
    }
  }

  void openAddNoteDialog() {
    noteController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text("Add Note",
            style: TextStyle(color: Colors.tealAccent)),
        content: TextField(
          controller: noteController,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(onPressed: addNote, child: const Text("Add")),
        ],
      ),
    );
  }

  // ---------------- EDIT ----------------
  void openEditNoteDialog(int filteredIndex) {
    final realIndex = notes.indexOf(filteredNotes[filteredIndex]);
    noteController.text = notes[realIndex];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text("Edit Note",
            style: TextStyle(color: Colors.tealAccent)),
        content: TextField(
          controller: noteController,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                notesService.editNote(realIndex, noteController.text);
                _loadNotes();
                filterNotes();
              });
              noteController.clear();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // ---------------- DELETE ----------------
  void deleteNote(int filteredIndex) {
    final realIndex = notes.indexOf(filteredNotes[filteredIndex]);
    setState(() {
      notesService.deleteNote(realIndex);
      _loadNotes();
      filterNotes();
    });
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes App",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.tealAccent),
            onPressed: () {
              Hive.box('authBox').delete('currentUser');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search notes",
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(child: Text("No notes"))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredNotes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => openEditNoteDialog(index),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                const Color.fromARGB(255, 136, 94, 170),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 22),
                                child: Text(
                                  filteredNotes[index],
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, size: 18),
                                  onPressed: () =>
                                      deleteNote(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
