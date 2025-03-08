import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Caja de Herramientas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Caja de Herramientas')),
      drawer: _buildDrawer(context),
      body: _buildBody(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menú Principal',
              style: TextStyle(color: Color.fromARGB(255, 43, 43, 43), fontSize: 24),
            ),
          ),
          _menuItem(context, Icons.person, 'Predecir Género', const PredecirGenero()),
          _menuItem(context, Icons.cake, 'Predecir Edad', const PredecirEdad()),
          _menuItem(context, Icons.school, 'Lista de Universidad', const UniversityList()),
          _menuItem(context, Icons.cloud, 'Clima en RD', const WeatherInfo()),
          _menuItem(context, Icons.catching_pokemon, 'Pokemones', const PokemonInfo()),
          _menuItem(context, Icons.web, 'WordPress', const WordPressNews()),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, Widget destination) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Contrátame',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/Perfil.jpg'),
          ),
          const SizedBox(height: 20),
          const Text(
            '¡Hola! Soy Juan Manuel, un desarrollador de software',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            'Si te ha gustado esta aplicación y necesitas un desarrollador para tu próximo proyecto, ¡no dudes en contactarme!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          const Text(
            'Datos de Contacto:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Email: juanm.2004.sd@gmail.com',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            'Teléfono: 829-431-9206',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
          Image.asset(
            'assets/caja.png',
            width: 500,
            height: 500,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}


Widget _menuItem(BuildContext context, IconData icon, String title, Widget page) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    },
  );
}

// ---------------------- PREDECIR GÉNERO ----------------------
class PredecirGenero extends StatefulWidget {
  const PredecirGenero({super.key});

  @override
  _PredecirGeneroState createState() => _PredecirGeneroState();
}

class _PredecirGeneroState extends State<PredecirGenero> {
  final TextEditingController _nameController = TextEditingController();
  String _gender = '';
  Color _backgroundColor = Colors.white;

  Future<void> _predictGender() async {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un nombre')),
      );
      return;
    }

    final Uri url = Uri.parse('https://api.genderize.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _gender = data['gender'] ?? 'unknown';
        _backgroundColor = _gender == 'male' ? Colors.blue : Colors.pink;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al conectar con la API')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predecir Género')),
      body: Container(
        color: _backgroundColor,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ingresa un nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictGender,
              child: const Text('Predecir Género'),
            ),
            const SizedBox(height: 20),
            Text(
              _gender.isNotEmpty ? 'Género: $_gender' : '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

// ---------------------- PREDECIR EDAD ----------------------
class PredecirEdad extends StatefulWidget {
  const PredecirEdad({super.key});

  @override
  _PredecirEdadState createState() => _PredecirEdadState();
}

class _PredecirEdadState extends State<PredecirEdad> {
  final TextEditingController _nameController = TextEditingController();
  String _edad = '';
  String _mensaje = '';
  String _imagen = 'assets/default.png';

  Future<void> _predictAge() async {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un nombre')),
      );
      return;
    }

    final Uri url = Uri.parse('https://api.agify.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      int edad = data['age'] ?? 0;
      setState(() {
        _edad = edad.toString();
        if (edad < 18) {
          _mensaje = 'Joven';
          _imagen = 'assets/joven.jpg';
        } else if (edad < 60) {
          _mensaje = 'Adulto';
          _imagen = 'assets/adulto.jpg';
        } else {
          _mensaje = 'Anciano';
          _imagen = 'assets/anciano.jpg';
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al conectar con la API')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predecir Edad')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ingresa un nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictAge,
              child: const Text('Predecir Edad'),
            ),
            const SizedBox(height: 20),
            _edad.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        'Edad: $_edad años',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _mensaje,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        _imagen,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

// ---------------------- Lista de universidad ----------------------
class UniversityList extends StatefulWidget {
  const UniversityList({super.key});

  @override
  _UniversityListState createState() => _UniversityListState();
}

class _UniversityListState extends State<UniversityList> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> universities = [];
  bool isLoading = false;

  Future<void> fetchUniversities(String country) async {
    setState(() {
      isLoading = true;
    });

    final formattedCountry = country.replaceAll(" ", "+");
    final url = Uri.parse('http://universities.hipolabs.com/search?country=$formattedCountry');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          universities = jsonDecode(response.body);
        });
      } else {
        setState(() {
          universities = [];
        });
      }
    } catch (e) {
      setState(() {
        universities = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Universidades')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Ingrese un país en inglés',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => fetchUniversities(_controller.text),
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: universities.length,
                      itemBuilder: (context, index) {
                        final university = universities[index];
                        return Card(
                          child: ListTile(
                            title: Text(university['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dominio: ${university['domains'][0]}'),
                                GestureDetector(
                                  onTap: () => launchURL(university['web_pages'][0]),
                                  child: Text(
                                    university['web_pages'][0],
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
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
      ),
    );
  }
}

class WeatherInfo extends StatefulWidget {
  const WeatherInfo({super.key});

  @override
  _WeatherInfoState createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  String temperature = "--";
  String weatherDescription = "Cargando...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    const apiKey = 'cebcd03673219c9201848de5925b2c31'; 
    const city = 'Santo Domingo';
    const url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=es';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temperature = "${data['main']['temp']}°C";
          weatherDescription = data['weather'][0]['description'];
        });
      } else {
        setState(() {
          weatherDescription = "Error al obtener el clima";
        });
      }
    } catch (e) {
      setState(() {
        weatherDescription = "No se pudo cargar el clima";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima en RD')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Card(
                elevation: 4,
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wb_sunny, size: 50, color: Colors.orange),
                      const SizedBox(height: 10),
                      Text(temperature, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(weatherDescription, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// Pokemon
class PokemonInfo extends StatefulWidget {
  const PokemonInfo({super.key});

  @override
  _PokemonInfoState createState() => _PokemonInfoState();
}

class _PokemonInfoState extends State<PokemonInfo> {
  String pokemonName = "";
  String imageUrl = "";
  int baseExperience = 0;
  List<String> abilities = [];
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();

  Future<void> fetchPokemonData() async {
    if (_controller.text.isEmpty) return;
    
    setState(() {
      isLoading = true;
    });

    final url = 'https://pokeapi.co/api/v2/pokemon/${_controller.text.toLowerCase()}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          pokemonName = data['name'];
          baseExperience = data['base_experience'];
          imageUrl = data['sprites']['front_default'];
          abilities = List<String>.from(data['abilities'].map((ability) => ability['ability']['name']));
        });
      } else {
        setState(() {
          pokemonName = "Pokémon no encontrado";
        });
      }
    } catch (e) {
      setState(() {
        pokemonName = "Error al obtener los datos";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Nombre del Pokémon'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchPokemonData,
              child: const Text('Buscar Pokémon'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : pokemonName.isNotEmpty
                    ? Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(20),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                pokemonName.toUpperCase(),
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              if (imageUrl.isNotEmpty)
                                Image.network(imageUrl, width: 100, height: 100),
                              const SizedBox(height: 10),
                              Text('Experiencia base: $baseExperience'),
                              const SizedBox(height: 10),
                              Text('Habilidades:'),
                              for (var ability in abilities)
                                Text(ability),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

//wordpress
class WordPressNews extends StatefulWidget {
  const WordPressNews({super.key});

  @override
  _WordPressNewsState createState() => _WordPressNewsState();
}

class _WordPressNewsState extends State<WordPressNews> {
  String logoUrl = "";
  List<Map<String, String>> news = [];
  bool isLoading = false;
  String errorMessage = '';

  final String siteUrl = 'https://austinkleon.com/';

  @override
  void initState() {
    super.initState();
    fetchWordPressData();
  }

  Future<void> fetchWordPressData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';  // Reset error message
    });

    try {
      final logoResponse = await http.get(Uri.parse('$siteUrl/wp-json/wp/v2/sites'));
      if (logoResponse.statusCode == 200) {
        final logoData = jsonDecode(logoResponse.body);
        setState(() {
          logoUrl = logoData['jetpack']['site_logo']['src'] ?? '';
        });
        print('Logo URL: $logoUrl');  // Depuración
      } else {
        print('Error al obtener logo: ${logoResponse.statusCode}');
        setState(() {
          errorMessage = 'No se pudo obtener el logo del sitio';
        });
      }

      final newsResponse = await http.get(Uri.parse('$siteUrl/wp-json/wp/v2/posts?per_page=3'));
      if (newsResponse.statusCode == 200) {
        final newsData = jsonDecode(newsResponse.body);
        print('Datos de noticias: $newsData');  // Depuración
        setState(() {
          if (newsData.isEmpty) {
            errorMessage = 'No hay noticias disponibles';
          }
          news = List<Map<String, String>>.from(newsData.map((item) {
            return {
              'title': item['title']['rendered'] ?? 'Sin título',
              'excerpt': item['excerpt']['rendered'] ?? 'Sin resumen',
              'link': item['link'] ?? '',
            };
          }));
        });
      } else {
        print('Error al obtener noticias: ${newsResponse.statusCode}');
        setState(() {
          errorMessage = 'Error al obtener las noticias';
        });
      }
    } catch (e) {
      print('Error de conexión o al procesar los datos: $e');
      setState(() {
        logoUrl = '';
        news = [];
        errorMessage = 'Ocurrió un error al cargar los datos. Detalle: $e';
  });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias de The Sartorialist')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      logoUrl.isNotEmpty
                          ? Image.network(logoUrl, width: 100)
                          : const SizedBox(),
                      const SizedBox(height: 20),
                      if (news.isNotEmpty) ...[
                        for (var article in news)
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article['title'] ?? 'Sin título',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    article['excerpt'] ?? 'Sin resumen',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      if (article['link'] != null && article['link']!.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WebViewPage(url: article['link']!),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Visitar noticia original'),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ] else
                        const Center(child: Text('No se encontraron noticias.')),
                    ],
                  ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticia Original')),
      body: Center(
        child: Text('Aquí se abriría el navegador web para mostrar la noticia: $url'),
      ),
    );
  }
}
