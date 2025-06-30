import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../db/database_helper.dart';
import '../models/diary_entry.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<DateTime, List<DiaryEntry>> _events = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    List<DiaryEntry> entries = await _dbHelper.getEntries();
    Map<DateTime, List<DiaryEntry>> events = {};
    for (var entry in entries) {
      final date = DateTime.parse(entry.date).toLocal();
      final day = DateTime(date.year, date.month, date.day);
      events.putIfAbsent(day, () => []).add(entry);
    }
    setState(() {
      _events = events;
    });
  }

  List<DiaryEntry> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar View')),
      body: Column(
        children: [
          TableCalendar<DiaryEntry>(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay ?? _focusedDay)
                  .map((entry) => ListTile(
                        title: Text(entry.title),
                        subtitle: Text(entry.date),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
