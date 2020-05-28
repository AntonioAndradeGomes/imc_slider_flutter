import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imc_slider/bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _altura = 100;

  HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = new HomeBloc();
    //_homeBloc.onChangedAltura(100);
    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  IconData iconeResultado(double imc) {
    if (imc < 18.5 || imc > 25) {
      return FontAwesomeIcons.solidThumbsDown;
    } else {
      return FontAwesomeIcons.solidThumbsUp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<EstadosBloc>(
              stream: _homeBloc.outEstado,
              initialData: EstadosBloc(estado: Estados.CALCULANDO),
              builder: (context, snapshot) {
                if (snapshot.data.estado == Estados.CALCULANDO) {
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        FontAwesomeIcons.solidHeart,
                        size: MediaQuery.of(context).size.height * 0.25,
                        color: Colors.teal,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Calculadora de IMC',
                        style: const TextStyle(
                          color: Colors.teal,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      StreamBuilder<bool>(
                        stream: _homeBloc.outCarregando,
                        initialData: false,
                        builder: (context, snapshot) {
                          if (snapshot.data) {
                            return new CircularProgressIndicator();
                          } else {
                            return new Column(
                              children: <Widget>[
                                const Text(
                                  'Altura (m)',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                StreamBuilder<double>(
                                    stream: _homeBloc.outAltura,
                                    initialData: 100.0,
                                    builder: (context, snapshot) {
                                      return Column(
                                        children: <Widget>[
                                          new Container(
                                            padding: EdgeInsets.only(
                                                left: 16, right: 16),
                                            child: new Slider(
                                              min: 70.0,
                                              max: 280.0,
                                              onChanged:
                                                  _homeBloc.onChangedAltura,
                                              divisions: 110,
                                              activeColor: Colors.teal,
                                              value: snapshot.data,
                                              inactiveColor: Colors.grey,
                                              label: snapshot.data
                                                      .toStringAsFixed(0) +
                                                  ' cm',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          new Text(
                                            ((snapshot.data) / 100)
                                                    .toStringAsFixed(2) +
                                                ' m',
                                            style: const TextStyle(
                                              color: Colors.teal,
                                              fontSize: 18,
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  'Peso (kg)',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                StreamBuilder<double>(
                                    stream: _homeBloc.outPeso,
                                    initialData: 30.0,
                                    builder: (context, snapshot) {
                                      return Column(
                                        children: <Widget>[
                                          new Container(
                                            padding: EdgeInsets.only(
                                                left: 16, right: 16),
                                            child: new Slider(
                                              min: 15.0,
                                              max: 150.0,
                                              onChanged:
                                                  _homeBloc.onChangedPeso,
                                              divisions: 100,
                                              activeColor: Colors.teal,
                                              inactiveColor: Colors.grey,
                                              value: snapshot.data,
                                              label: snapshot.data
                                                      .toStringAsFixed(0) +
                                                  ' kg',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          new Text(
                                            snapshot.data.toStringAsFixed(0) +
                                                ' kg',
                                            style: const TextStyle(
                                              color: Colors.teal,
                                              fontSize: 18,
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                                const SizedBox(
                                  height: 35,
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                      height: 50,
                                      width: 150,
                                      child: new RaisedButton(
                                        onPressed: () {
                                          _homeBloc.submit();
                                        },
                                        textColor: Colors.white,
                                        color: Colors.teal,
                                        elevation: 0,
                                        child: const Text(
                                          'Calcular',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      )
                    ],
                  );
                } else {
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        iconeResultado(snapshot.data.resultado),
                        size: 150,
                        color: Colors.teal,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      new Text(
                        'Resultado: ' +
                            snapshot.data.resultado.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.teal,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      new Text(
                        snapshot.data.textoResultado,
                        style: const TextStyle(
                          color: Colors.teal,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            height: 50,
                            width: 280,
                            child: new RaisedButton.icon(
                              label: const Text('Calcular Novamente', style: const TextStyle(fontSize: 18),),
                              onPressed: () {
                                _homeBloc.calcularNovamente();
                              },
                              textColor: Colors.white,
                              color: Colors.teal,
                              elevation: 0,
                              icon: Icon(Icons.arrow_back_ios),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
