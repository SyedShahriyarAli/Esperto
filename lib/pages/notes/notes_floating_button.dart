import 'package:flutter/cupertino.dart';
import '../../widgets/fast_color_picker.dart';
import 'package:esperto/models/notes.dart';
import 'package:esperto/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../utils/custom_rect_tween.dart';

class AddNoteButton extends StatelessWidget {
  const AddNoteButton({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: _heroAddNote,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: DarkTheme.blueColor,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: const Icon(
              Icons.add,
              color: DarkTheme.fontColor,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}

const String _heroAddNote = 'add-Note-hero';

class AddNotePopupCard extends StatefulWidget {
  const AddNotePopupCard({Key? key}) : super(key: key);

  @override
  State<AddNotePopupCard> createState() => _AddNotePopupCardState();
}

class _AddNotePopupCardState extends State<AddNotePopupCard> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Color _color = DarkTheme.backColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddNote,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: _color,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: DarkTheme.borderColor)),
                      cursorColor: DarkTheme.borderColor,
                      style: const TextStyle(color: DarkTheme.fontColor),
                    ),
                    TextField(
                      controller: descriptionController,
                      style: const TextStyle(color: DarkTheme.fontColor),
                      decoration: const InputDecoration(
                          hintText: 'Write a note',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: DarkTheme.borderColor)),
                      cursorColor: DarkTheme.borderColor,
                      maxLines: 8,
                    ),
                    FastColorPicker(
                      icon: Icons.color_lens,
                      selectedColor: _color,
                      onColorSelected: (color) {
                        setState(() {
                          _color = color;
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          var id = const Uuid().v4();
                          Box notes = Hive.box<Note>('notes');
                          if (titleController.text == "" &&
                              descriptionController.text == "") {
                            // showSnackbar(context, "Empty Note Discarded");
                            return;
                          }
                          Note note = Note(
                              id: id,
                              title: titleController.text,
                              description: descriptionController.text,
                              color: _color.toString());
                          notes.put(id, note);
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                DarkTheme.borderColor)),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
