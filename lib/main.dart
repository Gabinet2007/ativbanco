import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ativ_database.dart';
import 'ativ_user.dart';
import 'splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atividade Banco',
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buffet Barni!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Encomendar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExemploInicial()),
                );
              },
            ),
            SizedBox(height: 20), // Espaço entre os botões
            ElevatedButton(
              child: Text('Ver Pedidos'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PedidosPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ExemploInicial extends StatefulWidget {
  ExemploInicial({Key? key}) : super(key: key);
  @override
  _ExemploInicial createState() => _ExemploInicial();
}

class _ExemploInicial extends State<ExemploInicial> {
  late DatabaseHandler handler;
  var _checkboxValue1 = false;
  var _checkboxValue2 = false;
  var _checkboxValue3 = false;
  var _radioValue = 1;
  final _currentSliderValue = 5;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB();
  }

  Future<int> salvarPedido() async {
    String carne = _radioValue == 1
        ? "Gado"
        : _radioValue == 2
            ? "Porco"
            : "Frango";

    String ponto = "";
    if (_checkboxValue1) ponto += "Mal passada ";
    if (_checkboxValue2) ponto += "Ao ponto ";
    if (_checkboxValue3) ponto += "Bem passada";
    ponto = ponto.trim();

    String data = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : "";
    String hora = _selectedTime != null
        ? "${_selectedTime!.hour}:${_selectedTime!.minute}"
        : "";

    print('*** INFORMAÇÕES DO PEDIDO ***');
    print('Tipo de Carne: $carne');
    print('Ponto da Carne: $ponto');
    print('Data: $data');
    print('Hora: $hora');
    print('Quantidade no Slider: $_currentSliderValue');
    print('==========================');

    User user = User(
        carne: carne,
        slider: _currentSliderValue.round(),
        data: data,
        hora: hora,
        ponto: ponto); // O id será gerado automaticamente pelo banco de dados

    List<User> listOUsers = [user];
    return await handler.insertUser(listOUsers);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime.now().add(Duration(days: 1095)),
    );
    setState(() {
      if (selectedDate != null) {
        _selectedDate = selectedDate;
        print(_selectedDate);
      }
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    setState(() {
      if (selectedTime != null) {
        _selectedTime = selectedTime;
        print(_selectedTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stepper(
          currentStep: _currentStep,
          steps: [
            Step(
              title: Text('Selecione o tipo de carne'),
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Gado"),
                      Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int? inValue) {
                          setState(() {
                            _radioValue = inValue!;
                            print(_radioValue);
                          });
                        },
                      ),
                      Text("Porco"),
                      Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: (int? inValue) {
                          setState(() {
                            _radioValue = inValue!;
                            print(_radioValue);
                          });
                        },
                      ),
                      Text("Frango"),
                      Radio(
                        value: 3,
                        groupValue: _radioValue,
                        onChanged: (int? inValue) {
                          setState(() {
                            _radioValue = inValue!;
                            print(_radioValue);
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Step(
              title: Text('Selecione o ponto de cozimento'),
              content: Column(
                children: [
                  Checkbox(
                    value: _checkboxValue1,
                    onChanged: (bool? inValue) {
                      setState(() {
                        _checkboxValue1 = inValue!;
                        print(_checkboxValue1);
                      });
                    },
                  ),
                  Text("Carne: Mal passada"),
                  Checkbox(
                    value: _checkboxValue2,
                    onChanged: (bool? inValue) {
                      setState(() {
                        _checkboxValue2 = inValue!;
                        print(_checkboxValue2);
                      });
                    },
                  ),
                  Text("Carne: Ao ponto"),
                  Checkbox(
                    value: _checkboxValue3,
                    onChanged: (bool? inValue) {
                      setState(() {
                        _checkboxValue3 = inValue!;
                        print(_checkboxValue3);
                      });
                    },
                  ),
                  Text("Carne: Bem passada"),
                ],
              ),
            ),
            Step(
              title: Text('Selecione a data e hora'),
              content: Column(
                children: [
                  ElevatedButton(
                    child: Text("Selecionar data"),
                    onPressed: () => _selectDate(context),
                  ),
                  _selectedDate != null
                      ? Text(
                          "Data selecionada: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}")
                      : Text(""),
                  ElevatedButton(
                    child: Text("Selecionar tempo"),
                    onPressed: () => _selectTime(context),
                  ),
                  _selectedTime != null
                      ? Text(
                          "Tempo selecionado: ${_selectedTime!.hour}:${_selectedTime!.minute}")
                      : Text(""),
                ],
              ),
            ),
            Step(
              title: Text('Resumo'),
              content: Column(
                children: [
                  Text(
                      "Tipo de carne: ${_radioValue == 1 ? "Gado" : _radioValue == 2 ? "Porco" : "Frango"}"),
                  Text("Ponto de cozimento: "),
                  _checkboxValue1 ? Text("Mal passada") : Text(""),
                  _checkboxValue2 ? Text("Ao ponto") : Text(""),
                  _checkboxValue3 ? Text("Bem passada") : Text(""),
                  Text(
                      "Data selecionada: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : ""}"),
                  Text(
                      "Tempo selecionado: ${_selectedTime != null ? "${_selectedTime!.hour}:${_selectedTime!.minute}" : ""}"),
                  ElevatedButton(
                    onPressed: () async {
                      int result = await salvarPedido(); // salva pedido
                      if (result > 0) {
                        // se sucesso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Informações salvas!')),
                        );
                        print('Informações salvas!');
                      } else {
                        // se paiar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao salvar o pedido!')),
                        );
                        print('Erro ao salvar o pedido!');
                      }
                    },
                    child: Text('Enviar Pedido'),
                  ),
                ],
              ),
            ),
          ],
          onStepTapped: (int newIndex) => setState(() {
            _currentStep = newIndex;
          }),
          onStepContinue: () {
            setState(() {
              if (_currentStep < 3) {
                _currentStep += 1;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (_currentStep > 0) {
                _currentStep -= 1;
              }
            });
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
          tooltip: 'Voltar',
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SliderWidget()),
                  );
                },
                child: Text('Número de pessoas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliderExample();
  }
}

class SliderExample extends StatefulWidget {
  const SliderExample({Key? key}) : super(key: key);

  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  late DatabaseHandler handler;
  double _currentSliderValue = 5;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        tooltip: 'Voltar',
      ),
      appBar: AppBar(title: const Text('Quantidade de pessoas')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Slider(
            value: _currentSliderValue,
            max: 100,
            divisions: 100,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
          ElevatedButton(
            child: Text('Confirmar'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SliderPessoas(sliderValue: _currentSliderValue),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SliderPessoas extends StatelessWidget {
  final double sliderValue;

  SliderPessoas({required this.sliderValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        tooltip: 'Voltar',
      ),
      appBar: AppBar(title: Text('Valor pessoas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransitionExampleApp(),
            Text('O valor a pagar será: ${(sliderValue.round()) * 80} reais'),
            ElevatedButton(
              child: Text('Salvar Pedido'),
              onPressed: () async {
                DatabaseHandler handler = DatabaseHandler();
                await handler.initializeDB();
                final result =
                    await handler.updateSliderValue(sliderValue.round());

                if (result > 0) {
                  print('*** ATUALIZAÇÃO DO PEDIDO ***');
                  print('Novo número de pessoas: ${sliderValue.round()}');
                  print('Novo valor total: R\$ ${(sliderValue.round()) * 80}');
                  print('================================');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pedido adicionado com sucesso!')),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PedidosPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao adicionar o pedido!')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> _savePedido(BuildContext context) async {
    final ancestral = context.findAncestorStateOfType<_ExemploInicial>();
    if (ancestral != null) {
      return await ancestral.salvarPedido();
    }
    return null;
  }
}

class RotationTransitionExampleApp extends StatelessWidget {
  const RotationTransitionExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RotationTransitionExample();
  }
}

class RotationTransitionExample extends StatefulWidget {
  const RotationTransitionExample({super.key});

  @override
  State<RotationTransitionExample> createState() =>
      _RotationTransitionExampleState();
}

class _RotationTransitionExampleState extends State<RotationTransitionExample>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: const Padding(
        padding: EdgeInsets.all(70.0),
        child: Text("Obrigado pela escolha!"),
      ),
    );
  }
}

// EXIBIR PEDIDOS
class PedidosPage extends StatefulWidget {
  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todos os Pedidos')),
      body: FutureBuilder<List<User>>(
        future: _fetchPedidos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar pedidos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum pedido encontrado'));
          }

          List<User> pedidos = snapshot.data!;
          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];
              return Dismissible(
                key: Key(pedido.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.blue,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.edit, color: Colors.white),
                ),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    setState(() {
                      pedidos.removeAt(index);
                    });
                    _deletePedido(pedido.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pedido excluído')),
                    );
                  }
                },
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPedidoPage(pedido: pedido),
                      ),
                    ).then((_) => setState(() {}));
                    return false;
                  }
                  return true;
                },
                child: ListTile(
                  title: Text('Carne: ${pedido.carne}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${pedido.id}'),
                      Text('Data: ${pedido.data}, Hora: ${pedido.hora}'),
                      Text('Ponto: ${pedido.ponto}'),
                      Text('Número de pessoas: ${pedido.slider}'),
                      Text('Valor total: R\$ ${pedido.slider * 80}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<User>> _fetchPedidos() async {
    return await handler.getAllUsers();
  }

  Future<void> _deletePedido(int? id) async {
    if (id != null) {
      await handler.deleteUser(id);
    }
  }
}
class EditPedidoPage extends StatefulWidget {
  final User pedido;

  EditPedidoPage({required this.pedido});

  @override
  _EditPedidoPageState createState() => _EditPedidoPageState();
}

class _EditPedidoPageState extends State<EditPedidoPage> {
  late TextEditingController _carneController;
  late TextEditingController _pontoController;
  late TextEditingController _dataController;
  late TextEditingController _horaController;
  late TextEditingController _sliderController;

  @override
  void initState() {
    super.initState();
    _carneController = TextEditingController(text: widget.pedido.carne);
    _pontoController = TextEditingController(text: widget.pedido.ponto);
    _dataController = TextEditingController(text: widget.pedido.data);
    _horaController = TextEditingController(text: widget.pedido.hora);
    _sliderController = TextEditingController(text: widget.pedido.slider.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Pedido')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _carneController,
              decoration: InputDecoration(labelText: 'Carne'),
            ),
            TextField(
              controller: _pontoController,
              decoration: InputDecoration(labelText: 'Ponto'),
            ),
            TextField(
              controller: _dataController,
              decoration: InputDecoration(labelText: 'Data'),
            ),
            TextField(
              controller: _horaController,
              decoration: InputDecoration(labelText: 'Hora'),
            ),
            TextField(
              controller: _sliderController,
              decoration: InputDecoration(labelText: 'Número de pessoas'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              child: Text('Salvar Alterações'),
              onPressed: () async {
                User updatedPedido = User(
                  id: widget.pedido.id,
                  carne: _carneController.text,
                  ponto: _pontoController.text,
                  data: _dataController.text,
                  hora: _horaController.text,
                  slider: int.parse(_sliderController.text),
                );
                await DatabaseHandler().updateUser(updatedPedido);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _carneController.dispose();
    _pontoController.dispose();
    _dataController.dispose();
    _horaController.dispose();
    _sliderController.dispose();
    super.dispose();
  }
}

