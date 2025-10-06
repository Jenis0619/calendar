import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CalendarTab extends StatefulWidget {
  final ValueChanged<int>? onSelectTab;
  const CalendarTab({super.key, this.onSelectTab});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  late DateTime _focused;
  DateTime? _selected;
  final Map<String, String> _notes = {}; // yyyy-MM-dd → text

  @override
  void initState() {
    super.initState();
    _focused = DateTime.now();
    _load();
  }

  /* ---------- persistence ---------- */
  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString('notes');
    if (raw != null) {
      setState(() => _notes.addAll(Map<String, String>.from(jsonDecode(raw))));
    }
  }

  Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('notes', jsonEncode(_notes));
  }

  /* ---------- add / edit note ---------- */
  void _addNote() {
    final day = DateFormat('yyyy-MM-dd').format(_selected!);
    final tec = TextEditingController(text: _notes[day] ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Note for ${DateFormat.yMMMMd().format(_selected!)}'),
        content: TextField(
          controller: tec,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'POTUS / world event …'),
        ),
        actions: [
          TextButton(onPressed: Navigator.of(context).pop, child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (tec.text.trim().isEmpty) {
                  _notes.remove(day);
                } else {
                  _notes[day] = tec.text.trim();
                }
                _save();
              });
              Navigator.of(context).pop();
            },
            child: const Text('SAVE')),
        ],
      ),
    );
  }

  /* ---------- delete note ---------- */
  void _deleteNote(DateTime day) {
    final key = DateFormat('yyyy-MM-dd').format(day);
    setState(() {
      _notes.remove(key);
      _save();
    });
  }

  /* ---------- UI ---------- */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        TableCalendar(
          focusedDay: _focused,
          firstDay: DateTime.utc(2017),
          lastDay: DateTime.utc(2040),
          selectedDayPredicate: (d) => isSameDay(_selected, d),
          onDaySelected: (sel, foc) {
            setState(() {
              _selected = sel;
              _focused = foc;
            });
          },
          eventLoader: (d) => _notes.containsKey(DateFormat('yyyy-MM-dd').format(d)) ? [1] : [],
          headerStyle: const HeaderStyle(formatButtonVisible: false),
          calendarStyle: const CalendarStyle(
            markerDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(height: 12),
        if (_selected != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.post_add),
                  label: const Text('POST EVENT'),
                  onPressed: _addNote,
                ),
                const Spacer(),
                Text(DateFormat.yMMMMd().format(_selected!),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _notes[DateFormat('yyyy-MM-dd').format(_selected!)] != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(_notes[DateFormat('yyyy-MM-dd').format(_selected!)]!),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteNote(_selected!),
                        ),
                      ),
                    ),
                  )
                : const Center(child: Text('No note for this day yet.')),
          ),
        ] else
          const Center(child: Text('Tap a day to add an event.')),
      ],
    );
  }
}