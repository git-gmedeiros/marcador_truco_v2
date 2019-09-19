import 'package:flutter/material.dart';
import 'package:marcador_truco_v2/models/player.dart';
import 'package:screen/screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //var playerOne = Player(name: "Nós", score: 0, victories: 0);
  //var playerTwo = Player(name: "Eles", score: 0, victories: 0);

  Color corBotao = Colors.black;
  bool tela = false;

  List<Player> _players = [
    Player(name: "Nós", score: 0, victories: 0),
    Player(name: "Eles", score: 0, victories: 0)
  ];

  TextEditingController _nameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _resetPlayers();
  }

  void _resetPlayer({Player player, bool resetVictories = true}) {
    setState(() {
      player.score = 0;
      if (resetVictories) player.victories = 0;
    });
  }

  void _resetPlayers({bool resetVictories = true}) {
    _resetPlayer(player: _players[0], resetVictories: resetVictories);
    _resetPlayer(player: _players[1], resetVictories: resetVictories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Marcador Pontos (Truco!)"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (tela) {
                setState(() {
                  Screen.keepOn(false);
                  tela = false;
                  corBotao = Colors.black;
                });
              } else {
                setState(() {
                  Screen.keepOn(true);
                  tela = true;
                  corBotao = Colors.white;
                });
              }
            },
            icon: Icon(
              Icons.wb_sunny,
              color: corBotao,
            ),
          ),
          IconButton(
            onPressed: () {
              _showDialog(
                  title: 'Zerar pontuação',
                  message:
                      'Tem certeza que deseja começar novamente a pontuação?',
                  confirm: () {
                    _resetPlayers(resetVictories: false);
                  });
            },
            icon: Icon(Icons.subdirectory_arrow_left),
          ),
          IconButton(
            onPressed: () {
              _showDialog(
                  title: 'Zerar o jogo',
                  message: 'Tem certeza que deseja começar um novo jogo?',
                  confirm: () {
                    _resetPlayers();
                  });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(padding: EdgeInsets.all(20.0), child: _showPlayers()),
    );
  }

  Widget _showPlayers() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _showPlayerBoard(_players[0]),
        _showPlayerBoard(_players[1]),
      ],
    );
  }

  Widget _showPlayerBoard(Player player) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _showPlayerName(player),
          _showPlayerScore(player.score),
          _showPlayerVictories(player.victories),
          _showScoreButtons(player),
        ],
      ),
    );
  }

  Widget _showPlayerName(Player player) {
    return GestureDetector(
      child: Text(
        player.name.toUpperCase(),
        style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w500,
            color: Colors.deepOrange),
      ),
      onTap: () {
        setState(() {
          _resetName(player);
        });
      },
    );
  }

  void _resetName(Player player) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Trocar nome"),
            content: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Novo nome'),
                controller: _nameController,
                validator: (text) {
                  return text.isEmpty ? "Insira um nome!" : null;
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCEL"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.of(context).pop();
                    setState(() {
                      player.name = _nameController.text;
                    });
                    _nameController.text = "";
                  }
                },
              ),
            ],
          );
        });
  }

  Widget _showPlayerVictories(int victories) {
    return Text(
      "vitórias ( $victories )",
      style: TextStyle(fontWeight: FontWeight.w300),
    );
  }

  Widget _showPlayerScore(int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52.0),
      child: Text(
        "$score",
        style: TextStyle(fontSize: 120.0),
      ),
    );
  }

  Widget _buildRoundedButton(
      {String text, double size = 52.0, Color color, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(
          color: color,
          height: size,
          width: size,
          child: Center(
              child: Text(
            text,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget _showScoreButtons(Player player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildRoundedButton(
          text: '-1',
          color: Colors.black.withOpacity(0.1),
          onTap: () {
            setState(() {
              player.addScore(-1);
            });
          },
        ),
        _buildRoundedButton(
          text: '+1',
          color: Colors.deepOrangeAccent,
          onTap: () {
            setState(() {
              player.addScore(1);
            });
            if (_players[0].score == 11 && _players[1].score == 11) {
              _showDialog(
                  title: "Mão de Onze",
                  message:
                      "Chegou na mão de onze !!\n            Boa Sorte !!");
            } else if (player.score == 12) {
              _showDialog(
                  title: 'Fim do jogo',
                  message: '${player.name} ganhou!',
                  confirm: () {
                    setState(() {
                      player.victories++;
                    });

                    _resetPlayers(resetVictories: false);
                  },
                  cancel: () {
                    setState(() {
                      player.addScore(-1);
                    });
                  });
            }
          },
        ),
      ],
    );
  }

  void _showDialog(
      {String title, String message, Function confirm, Function cancel}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
          ],
        );
      },
    );
  }
}
