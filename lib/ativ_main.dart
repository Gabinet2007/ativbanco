import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ativ_database.dart';
import 'ativ_user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo Inicial',
      home: HomePage(),
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
        child: ElevatedButton(
          child: Text('Encomendar'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExemploInicial()),
            );
          },
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
  double _currentSliderValue = 5;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB();
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

    User user = User(
        carne: carne,
        slider: _currentSliderValue.round(),
        data: data,
        hora: hora,
        ponto: ponto);

    List<User> listOUsers = [user];
    return await this.handler.insertUser(listOUsers);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 1095)),
    );
    setState(() {
      if (selectedDate != null) {
        _selectedDate = selectedDate;
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
                      });
                    },
                  ),
                  Text("Carne: Mal passada"),
                  Checkbox(
                    value: _checkboxValue2,
                    onChanged: (bool? inValue) {
                      setState(() {
                        _checkboxValue2 = inValue!;
                      });
                    },
                  ),
                  Text("Carne: Ao ponto"),
                  Checkbox(
                    value: _checkboxValue3,
                    onChanged: (bool? inValue) {
                      setState(() {
                        _checkboxValue3 = inValue!;
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
                ],
              ),
            )
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
                onPressed: () async {
                  int result = await salvarPedido();
                  if (result > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pedido salvo com sucesso!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao salvar o pedido.')),
                    );
                  }
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
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
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
                  builder: (context) => SliderPessoas(sliderValue: _currentSliderValue),
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
          ],
        ),
      ),
    );
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
