import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_data_table_plus/lazy_data_table_plus.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:localization_ui/src/home/presenter/states/file_state.dart';
import 'package:localization_ui/src/home/presenter/stores/file_store.dart';
import 'package:path/path.dart' hide context;
import 'package:provider/provider.dart';

class SaveIntent extends Intent {}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isPicked = false;
  var _hasEdited = false;
  final searchTextController = TextEditingController(text: '');
  String get _searchText => searchTextController.text;

  @override
  void initState() {
    super.initState();
    final store = context.read<FileStore>();
    store.addListener(() {
      final state = store.value;
      if (state is ErrorFileState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  final saveFileKeySet = LogicalKeySet(
    LogicalKeyboardKey.meta, // Replace with control on Windows
    LogicalKeyboardKey.keyS,
  );

  @override
  Widget build(BuildContext context) {
    final store = context.watch<FileStore>();
    final state = store.value;

    final keys = state.keys.where((key) {
      if (_searchText.isEmpty || key.contains(_searchText)) {
        return true;
      }

      for (var lang in state.languages) {
        final text = lang.read(key).toLowerCase();
        if (text.contains(_searchText.toLowerCase())) {
          return true;
        }
      }
      return false;
    }).toSet();

    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        saveFileKeySet: SaveIntent(),
      },
      actions: {
        SaveIntent: CallbackAction(onInvoke: (e) {
          _hasEdited = false;
          store.saveLanguages();
        }),
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _isPicked
                    ? null
                    : () async {
                        setState(() {
                          _isPicked = true;
                        });
                        final selectedDirectory = await FilePicker.platform.getDirectoryPath();
                        _isPicked = false;
                        if (selectedDirectory != null) {
                          store.setDirectoryAndLoad(selectedDirectory);
                        } else {
                          setState(() {});
                        }
                      },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.directory != null ? '${basename(state.directory!)}${_hasEdited ? '*' : ''}' : 'select-a-directory'.i18n()),
                      SizedBox(width: 7),
                      Icon(Icons.mode_edit_outline_rounded),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                ),
                child: TextField(
                  controller: searchTextController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white54),
                    hintText: 'search'.i18n() + '...',
                    suffixIcon: _searchText.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                searchTextController.text = '';
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
          actions: [
            if (store is LoadingFileState)
              Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: LazyDataTable(
            tableDimensions: LazyDataTableDimensions(
              cellHeight: 50,
              cellWidth: 300,
              columnHeaderHeight: 50,
              rowHeaderWidth: 220,
            ),
            tableTheme: LazyDataTableTheme(
              columnHeaderBorder: Border.all(color: Colors.black38),
              rowHeaderBorder: Border.all(color: Colors.black38),
              cellBorder: Border.all(color: Colors.black12),
              cornerBorder: Border.all(color: Colors.black38),
              columnHeaderColor: Colors.grey[100],
              rowHeaderColor: Colors.grey[100],
              cellColor: Colors.white,
              cornerColor: Colors.grey[100],
            ),
            columns: state.languages.length,
            rows: keys.length,
            columnHeaderBuilder: (int columnIndex) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  state.languages[columnIndex].nameWithoutExtension,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            rowHeaderBuilder: (int rowIndex) {
              final key = keys.elementAt(rowIndex);
              return InkWell(
                onLongPress: () {
                  Clipboard.setData(new ClipboardData(text: key));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('clipboard-text'.i18n())));
                },
                onTap: () {
                  _dialogUpdateKeyName(key);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      key,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
            dataCellBuilder: (int rowIndex, int columnIndex) {
              final key = keys.elementAt(rowIndex);
              final lang = state.languages[columnIndex];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: ValueKey('$key$columnIndex'),
                  decoration: InputDecoration.collapsed(hintText: ''),
                  onChanged: (value) {
                    lang.set(key, value);
                    setState(() {
                      _hasEdited = true;
                    });
                  },
                  initialValue: lang.read(key),
                ),
              );
            },
            cornerWidget: Center(
              child: Text(
                'keys'.i18n(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(Icons.add),
              onPressed: state.languages.isEmpty ? null : _dialogAddKeyName,
            ),
            SizedBox(height: 10),
            CustomFloatButton(
              child: Icon(Icons.save_outlined),
              animate: _hasEdited,
              onPressed: state.languages.isEmpty
                  ? null
                  : () {
                      _hasEdited = false;
                      store.saveLanguages();
                    },
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 25,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Future<void> _dialogAddKeyName() async {
    showDialog(
      context: context,
      builder: (context) {
        var key = '';
        return AlertDialog(
          title: Text('key-name'.i18n()),
          content: TextField(
            textInputAction: TextInputAction.send,
            onSubmitted: (_) {
              if (key.isEmpty) {
                return;
              }
              context.read<FileStore>().addNewKey(key);
              _hasEdited = true;
              Navigator.of(context).pop();
            },
            inputFormatters: [RemoveSpace()],
            onChanged: (value) => key = value,
            decoration: InputDecoration(
              labelText: 'key'.i18n(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel'.i18n()),
            ),
            TextButton(
              onPressed: () {
                if (key.isEmpty) {
                  return;
                }
                context.read<FileStore>().addNewKey(key);
                _hasEdited = true;
                Navigator.of(context).pop();
              },
              child: Text('save'.i18n()),
            )
          ],
        );
      },
    );
  }

  Future<void> _dialogUpdateKeyName(String oldKey) async {
    showDialog(
      context: context,
      builder: (context) {
        var key = '';
        return AlertDialog(
          title: Text('edit-key'.i18n()),
          content: TextFormField(
            textInputAction: TextInputAction.send,
            onFieldSubmitted: (text) {
              if (oldKey != key) {
                _hasEdited = true;
                context.read<FileStore>().editKey(oldKey, key);
              }
              Navigator.of(context).pop();
            },
            inputFormatters: [RemoveSpace()],
            initialValue: oldKey,
            onChanged: (value) => key = value,
            decoration: InputDecoration(
              labelText: 'key'.i18n(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel'.i18n()),
            ),
            TextButton(
              onPressed: () {
                if (oldKey != key) {
                  _hasEdited = true;
                  context.read<FileStore>().editKey(oldKey, key);
                }
                Navigator.of(context).pop();
              },
              child: Text('save'.i18n()),
            )
          ],
        );
      },
    );
  }
}

class CustomFloatButton extends StatefulWidget {
  final bool animate;
  final Widget? child;
  final void Function()? onPressed;
  const CustomFloatButton({Key? key, this.animate = false, this.onPressed, this.child}) : super(key: key);

  @override
  _CustomFloatButtonState createState() => _CustomFloatButtonState();
}

class _CustomFloatButtonState extends State<CustomFloatButton> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant CustomFloatButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate) {
      controller.repeat(reverse: true);
    } else {
      controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color.lerp(Colors.blue, Colors.red, controller.value),
      child: widget.child,
      onPressed: widget.onPressed,
    );
  }
}

class RemoveSpace extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    return newValue.copyWith(
      text: text,
      selection: TextSelection.fromPosition(
        TextPosition(offset: text.length),
      ),
    );
  }
}
