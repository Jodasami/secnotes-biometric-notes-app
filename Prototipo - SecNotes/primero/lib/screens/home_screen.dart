import 'package:flutter/material.dart';
import '../storage/notes_storage.dart';
import 'login_screen.dart';
import 'dart:math';
import '../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // TODO -- Creamos una lista de Widgets para poder simular las notas
  final NotesStorage storage = NotesStorage();
  List<Map<String, dynamic>> notes = [];

  final List<Color> noteColors = [
    Colors.yellow,
    Colors.orange,
    Colors.green,
    Colors.pink,
    Colors.blue,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final loadedNotes = await storage.loadNotes();

    setState(() {
      notes = loadedNotes;
    });
  }

  // TODO -- Esto es un metodo que nos permite agregar un contenedor al momento de
  // TODO -- presionar el "boton flotante"
  void _agregarNota() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nueva nota'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Tu nota'),
        ),
        actions: [
          TextButton(
            child: const Text('Guardar'),
            onPressed: () async {

              final random = Random();

              notes.add({
                "content": controller.text,
                "color": noteColors[random.nextInt(noteColors.length)].value
              });

              await storage.saveNotes(notes);

              setState(() {});

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nota guardada')),
              );
            },
          ),
        ],
      ),
    );
  }


  // TODO ----------------------- INTERFAZ -----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis notas',
          style: TextStyle(color: Colors.white)),backgroundColor: Colors.blue,),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: notes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columnas
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {

            var note = notes[index];

            return NoteCard(
              note: note,
              onTap: () {
                final controller = TextEditingController(text: note["content"]);

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Editar nota'),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: 'Editar nota'),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Guardar'),
                        onPressed: () async {

                          notes[index]["content"] = controller.text;

                          await storage.saveNotes(notes);

                          setState(() {});

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Nota actualizada')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              onLongPress: () async {
                notes.removeAt(index);
                await storage.saveNotes(notes);
                setState(() {});
              },
            );

          },
        ),
      ),

      // TODO -- Este es el "boton flotante" que activa el metodo de agregar notas a la lista de notas
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _agregarNota,
        child: const Icon(Icons.note_add, color: Colors.white),
      ),

      // TODO -- Aqui se agregan los elementos de la barra de navegacion
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // TODO -- Por defecto estamos en el 0 (izquierda - Modo oscuro)

        onTap: (index) { // TODO -- "Onclick"

          if (index == 2) { // TODO -- Si es la opción de cerrar sesión
            // TODO -- Cerrar sesión y volver al login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );

            // TODO -- Mostramos un mensaje emergente (inferior)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sesión cerrada')),
            );

          } else if (index == 1) { // TODO -- Si elegimos la opción de información
            // TODO -- Mostramos una "ventana emergente"
            showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                  title: Text('Información'),
                  content: Text('SecNotes es una app de notas con autenticación biométrica. (DEMO)')
              ),
            );
          }
        },

        // TODO -- Aqui se agregan los elementos de la barra de navegacion
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dark_mode), label: 'Modo Oscuro'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Información'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Cerrar sesión'),
        ],
      ),


    );
  }
}