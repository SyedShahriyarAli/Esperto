import 'package:esperto/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../theme.dart';
import '../../utils/custom_rect_tween.dart';
import '../../widgets/fast_color_picker.dart';

class NotePopupCard extends StatefulWidget {
  const NotePopupCard({Key? key, required this.note}) : super(key: key);
  final Note note;
  @override
  State<NotePopupCard> createState() => _NotePopupCardState();
}

class _NotePopupCardState extends State<NotePopupCard> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Color color = DarkTheme.backColor;

  @override
  void initState() {
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
    color = Color(
        int.parse(widget.note.color.split('(0x')[1].split(')')[0], radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Hero(
        tag: widget.note.title,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
        child: Material(
          color: color,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    style: const TextStyle(color: DarkTheme.fontColor),
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(color: DarkTheme.borderColor),
                      border: InputBorder.none,
                    ),
                    cursorColor: DarkTheme.fontColor,
                  ),
                  TextFormField(
                    style: const TextStyle(color: DarkTheme.fontColor),
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: DarkTheme.borderColor),
                      hintText: 'Write a note ..',
                      border: InputBorder.none,
                    ),
                    cursorColor: DarkTheme.fontColor,
                    maxLines: 8,
                  ),
                  FastColorPicker(
                    icon: Icons.color_lens,
                    selectedColor: color,
                    onColorSelected: (color) {
                      setState(() {
                        this.color = color;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Box notes = Hive.box<Note>('notes');
                          notes.delete(widget.note.id);
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                DarkTheme.borderColor)),
                        child: const Text('Delete'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Box notes = Hive.box<Note>('notes');
                          if (titleController.text == "" &&
                              descriptionController.text == "") {
                            // showSnackbar(context, "Empty Note Discarded");
                            return;
                          }
                          Note note = Note(
                              id: widget.note.id,
                              title: titleController.text,
                              description: descriptionController.text,
                              color: color.toString());
                          notes.put(widget.note.id, note);
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                DarkTheme.borderColor)),
                        child: const Text('Done'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
