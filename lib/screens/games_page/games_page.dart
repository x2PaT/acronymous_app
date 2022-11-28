import 'package:acronymous_app/app/core/colors.dart';
import 'package:acronymous_app/app/core/enums.dart';
import 'package:acronymous_app/app/widgets/drawer.dart';
import 'package:acronymous_app/screens/games_page/cubit/games_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  String? _gameTypesEnum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select game'),
      ),
      drawer: const DrawerMaster(
        selectedElement: DrawerElements.games,
      ),
      body: BlocProvider(
        create: (context) => GamesPageCubit()..start(),
        child: BlocBuilder<GamesPageCubit, GamesPageState>(
          builder: (context, state) {
            return Column(
              children: [
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Acronyms Quiz'),
                      value: GamesTypesEnum.acronyms.name,
                      groupValue: _gameTypesEnum,
                      onChanged: (value) {
                        setState(() {
                          _gameTypesEnum = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Names Quiz'),
                      value: GamesTypesEnum.names.name,
                      groupValue: _gameTypesEnum,
                      onChanged: (value) {
                        setState(() {
                          _gameTypesEnum = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Random Letters Quiz'),
                      value: GamesTypesEnum.randomLetters.name,
                      groupValue: _gameTypesEnum,
                      onChanged: (value) {
                        setState(() {
                          setState(() {
                            _gameTypesEnum = value;
                          });
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Listen & Write Game'),
                      value: GamesTypesEnum.listen.name,
                      groupValue: _gameTypesEnum,
                      onChanged: (value) {
                        setState(() {
                          setState(() {
                            _gameTypesEnum = value;
                          });
                        });
                      },
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 130,
                          child: RotationTransition(
                            turns: const AlwaysStoppedAnimation(12 / 360),
                            child: Text('In progress',
                                style: TextStyle(
                                    color: AppColors.mainAppColor,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        RadioListTile<String>(
                          title: const Text('New Games'),
                          value: GamesTypesEnum.newGames.name,
                          groupValue: _gameTypesEnum,
                          onChanged: (value) {
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('In development, stay tuned')));
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<GamesPageCubit>(context)
                              .quizLenghtSubt();
                        },
                        icon: const Icon(Icons.remove)),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        state.quizLenghtValue.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<GamesPageCubit>(context)
                              .quizLenghtIncr();
                        },
                        icon: const Icon(Icons.add)),
                    const SizedBox(width: 15),
                  ],
                ),
                const SizedBox(height: 15),
                InkWell(
                    onTap: () {
                      if (_gameTypesEnum != null) {
                        if (_gameTypesEnum == GamesTypesEnum.listen.name) {
                          Navigator.of(context).pushNamed(
                            '/listenGame',
                            arguments: state.quizLenghtValue,
                          );
                        } else {
                          Navigator.of(context).pushNamed('/quiz', arguments: [
                            state.quizLenghtValue,
                            _gameTypesEnum.toString(),
                          ]);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Choose game type')));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Center(
                        child: Text(
                          'Start Game',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainAppColor),
                        ),
                      ),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
