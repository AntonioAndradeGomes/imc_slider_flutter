import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

enum Estados {CALCULANDO, CALCULADO}

class EstadosBloc{
  final Estados estado;
  final double resultado;
  final String textoResultado;
  EstadosBloc({@required this.estado, this.resultado, this.textoResultado});
}

class HomeBloc{
  final BehaviorSubject<EstadosBloc> _estadoController = new BehaviorSubject<EstadosBloc>.seeded(EstadosBloc(estado: Estados.CALCULANDO));

  Stream<EstadosBloc> get outEstado => _estadoController.stream;

  final _carregandoController = new BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outCarregando => _carregandoController.stream;

  final BehaviorSubject<double> _alturaController = new BehaviorSubject<double>.seeded(100.0);
  
  Function(double) get onChangedAltura => _alturaController.sink.add;

  Stream<double> get outAltura => _alturaController.stream;

  final BehaviorSubject<double> _pesoController = new BehaviorSubject<double>.seeded(15);

  Function(double) get onChangedPeso => _pesoController.sink.add;

  Stream<double> get outPeso => _pesoController.stream;

  submit() async{
    _carregandoController.add(true);
    final peso = _pesoController.value.round();
    final altura = _alturaController.value.round();
    double imc = peso/((altura/100)*(altura/100));
    String textoImc;
    if(imc < 18.5){
      textoImc = 'Abaixo do peso';
    }else if(imc >= 18.5 && imc <= 24.9){
      textoImc = 'Peso Normal';
    }else if(imc >= 25 && imc <=29.9){
      textoImc = 'Sobrepeso';
    }else if(imc >= 30 && imc <= 39.9){
      textoImc = 'Obesidade';
    }else{
      textoImc = 'Obesidade Grave';
    }
    await Future.delayed(const Duration(seconds: 2));
    _carregandoController.add(false);
    _estadoController.add(EstadosBloc(estado:Estados.CALCULADO, resultado: imc, textoResultado: textoImc));
  }

  void calcularNovamente() {
    _carregandoController.add(false);
    _estadoController.add(EstadosBloc(estado:Estados.CALCULANDO));
  }

  dispose(){
    _alturaController.close();
    _pesoController.close();
    _estadoController.close();
    _carregandoController.close();
  }

}