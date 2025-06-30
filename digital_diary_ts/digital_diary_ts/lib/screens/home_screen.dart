import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';
import '../models/diary_entry.dart';
import 'edit_entry_screen.dart';
import 'calendar_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<DiaryEntry> _entries = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() {
      _isLoading = true;
    });
    List<DiaryEntry> entries = await _dbHelper.getEntries();
    setState(() {
      _entries = entries;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  Future<void> _deleteEntry(int id) async {
    await _dbHelper.deleteEntry(id);
    _loadEntries();
  }

  Widget _buildEntryCard(DiaryEntry entry) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditEntryScreen(entry: entry),
          ),
        );
        _loadEntries();
      },
      child: Hero(
        tag: 'entry_${entry.id}',
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            title: Text(
              entry.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                entry.content.length > 100
                    ? '${entry.content.substring(0, 100)}...'
                    : entry.content,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: const Text('Your Digital Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalendarScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book_outlined,
                          size: 100, color: Colors.deepPurple.withOpacity(0.3)),
                      const SizedBox(height: 20),
                      const Text(
                        "No entries yet.\nTap + to add your first note!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _entries.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    return Dismissible(
                      key: Key(entry.id.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        _deleteEntry(entry.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Entry deleted successfully')),
                        );
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.redAccent,
                        child:
                            const Icon(Icons.delete, color: Colors.white, size: 28),
                      ),
                      child: _buildEntryCard(entry),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Add Note"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditEntryScreen()),
          );
          _loadEntries();
        },
      ),
    );
  }
}
