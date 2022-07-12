import 'package:esperto/models/notes.dart';
import 'package:esperto/theme.dart';
import 'package:esperto/pages/notes/notes_floating_button.dart';
import 'package:esperto/utils/hero_dialogue_route.dart';
import 'package:esperto/pages/notes/notes_popup_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final notesCollection = Hive.box<Note>('notes');
  List<Note> notes = <Note>[];
  final searchController = TextEditingController();
  bool listView = false;

  _NotesPageState() {
    notes = notesCollection.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: DarkTheme.backColor,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        title: SafeArea(
          top: false,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 40,
            child: TextField(
                autofocus: false,
                cursorColor: DarkTheme.borderColor,
                controller: searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  setState(() {
                    notes = notesCollection.values
                        .where((e) => e.title
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .toList();
                  });
                },
                onChanged: (value) {
                  setState(() {
                    notes = notesCollection.values
                        .where((e) => e.title
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .toList();
                  });
                },
                style: const TextStyle(
                    height: 1, fontSize: 14.0, color: DarkTheme.fontColor),
                textAlignVertical: const TextAlignVertical(y: 0.6),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 15),
                    filled: true,
                    fillColor: DarkTheme.backColor,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(
                            color: DarkTheme.borderColor,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(
                            color: DarkTheme.borderColor,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    hintStyle: const TextStyle(
                      color: DarkTheme.fontColor,
                    ),
                    suffixIcon: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          notes
                                  .where((e) => e.selected == true)
                                  .toList()
                                  .isNotEmpty
                              ? Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        // splashColor: Colors.transparent,
                                        child: const Icon(
                                            FontAwesomeIcons.trash,
                                            size: 20,
                                            color: DarkTheme.borderColor),
                                        onTap: () {
                                          Box<Note> notesCollection =
                                              Hive.box<Note>('notes');
                                          notesCollection.deleteAll(notes
                                              .where((e) => e.selected == true)
                                              .toList()
                                              .map((e) => e.id)
                                              .toList());
                                          setState(() {
                                            notes =
                                                notesCollection.values.toList();
                                          });
                                        }),
                                  ),
                                )
                              : const Text(""),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    // splashColor: Colors.transparent,
                                    child: Icon(
                                        listView
                                            ? Icons.table_rows
                                            : Icons.grid_view,
                                        color: DarkTheme.borderColor),
                                    onTap: () => setState(() {
                                          listView = !listView;
                                        })),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    prefixIcon:
                        const Icon(Icons.search, color: DarkTheme.borderColor),
                    hintText: "Search")),
          ),
        ),
      ),
      backgroundColor: DarkTheme.backColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: notes.isEmpty
                ? const Center(
                    child: Text(
                    "Add Your First Note By Tapping + Button. Double Tap To Select A Note 😉",
                    style:
                        TextStyle(color: DarkTheme.borderColor, fontSize: 24),
                    textAlign: TextAlign.center,
                  ))
                : !listView
                    ? StaggeredGridView.countBuilder(
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        itemCount: notes.length,
                        itemBuilder: (context, index) => NoteCard(
                          onLongPress: () {
                            setState(() {
                              notes[index].selected = !notes[index].selected;
                            });
                          },
                          note: notes[index],
                          onTap: () async {
                            await Navigator.of(context).push(
                              HeroDialogRoute(
                                fullscreenDialog: false,
                                builder: (context) => Center(
                                  child: NotePopupCard(note: notes[index]),
                                ),
                              ),
                            );
                            setState(() {
                              notes = notesCollection.values.toList();
                            });
                          },
                        ),
                        staggeredTileBuilder: (index) =>
                            const StaggeredTile.fit(1),
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 8,
                        ),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: notes.length,
                        itemBuilder: (context, index) => NoteCard(
                          onLongPress: () {
                            setState(() {
                              notes[index].selected = !notes[index].selected;
                            });
                          },
                          note: notes[index],
                          onTap: () async {
                            await Navigator.of(context).push(
                              HeroDialogRoute(
                                fullscreenDialog: false,
                                builder: (context) => Center(
                                  child: NotePopupCard(note: notes[index]),
                                ),
                              ),
                            );
                            setState(() {
                              notes = notesCollection.values.toList();
                            });
                          },
                        ),
                      ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: AddNoteButton(
              onTap: () async {
                await Navigator.of(context)
                    .push(HeroDialogRoute(builder: (context) {
                  return const AddNotePopupCard();
                }));
                setState(() {
                  notes = notesCollection.values.toList();
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard(
      {Key? key,
      required this.note,
      required this.onTap,
      required this.onLongPress})
      : super(key: key);

  final Note note;
  final Function() onTap;
  final Function() onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: Color(
              int.parse(note.color.split('(0x')[1].split(')')[0], radix: 16)),
          border: Border.all(
              width: note.selected ? 2 : 1,
              color: note.selected
                  ? Colors.blue[100]!
                  : Color(int.parse(note.color.split('(0x')[1].split(')')[0],
                              radix: 16)) ==
                          DarkTheme.backColor
                      ? DarkTheme.borderColor
                      : Color(int.parse(
                          note.color.split('(0x')[1].split(')')[0],
                          radix: 16))),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              Text(
                note.description,
                maxLines: 14,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
