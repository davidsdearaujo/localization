import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization_ui/home/domain/entities/language_file.dart';
import 'package:localization_ui/home/presenter/states/file_state.dart';
import 'package:localization_ui/home/presenter/stores/file_store.dart';
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

  Set<String> keys(List<LanguageFile> languages) {
    final list = <String>{};

    for (var lang in languages) {
      list.addAll(lang.keys);
    }

    return list;
  }

  final saveFileKeySet = LogicalKeySet(
    LogicalKeyboardKey.meta, // Replace with control on Windows
    LogicalKeyboardKey.keyS,
  );

  @override
  Widget build(BuildContext context) {
    final store = context.watch<FileStore>();
    final state = store.value;

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
          title: InkWell(
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
                  Text(state.directory != null ? '${basename(state.directory!)}${_hasEdited ? '*' : ''}' : 'Selecione um diretório'),
                  Icon(Icons.mode_edit_outline_rounded),
                ],
              ),
            ),
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
          width: double.infinity,
          child: SingleChildScrollView(
            child: DataTable(
              border: TableBorder.all(),
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Chaves',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                for (var lang in state.languages)
                  DataColumn(
                    label: Text(
                      lang.nameWithoutExtension,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
              rows: <DataRow>[
                for (var key in keys(state.languages))
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        InkWell(
                          onTap: () {
                            _dialogUpdateKeyName(key);
                          },
                          child: Text(key, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      for (var lang in state.languages)
                        DataCell(
                          TextFormField(
                            decoration: InputDecoration.collapsed(hintText: ''),
                            onChanged: (value) {
                              lang.set(key, value);
                              setState(() {
                                _hasEdited = true;
                              });
                            },
                            initialValue: lang.read(key),
                          ),
                        ),
                    ],
                  ),
              ],
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
      ),
    );
  }

  Future<void> _dialogAddKeyName() async {
    showDialog(
      context: context,
      builder: (context) {
        var key = '';
        return AlertDialog(
          title: Text('Nome da Chave'),
          content: TextField(
            inputFormatters: [RemoveSpace()],
            onChanged: (value) => key = value,
            decoration: InputDecoration(
              labelText: 'Chave',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
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
              child: Text('Salvar'),
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
          title: Text('Editar Chave'),
          content: TextFormField(
            inputFormatters: [RemoveSpace()],
            initialValue: oldKey,
            onChanged: (value) => key = value,
            decoration: InputDecoration(
              labelText: 'Chave',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (oldKey != key) {
                  _hasEdited = true;
                  context.read<FileStore>().editKey(oldKey, key);
                }
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
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
