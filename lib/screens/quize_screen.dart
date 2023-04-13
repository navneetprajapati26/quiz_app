import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quizze_provider.dart';

class QuizeScreen extends StatefulWidget {
  const QuizeScreen({Key? key}) : super(key: key);

  @override
  State<QuizeScreen> createState() => _QuizeScreenState();
}

class _QuizeScreenState extends State<QuizeScreen> {
  int currentQuestionIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final quizzProvider = Provider.of<QuizzesProvider?>(context, listen: false);
    quizzProvider!.fetchQuizzesData();
  }

  PageController pageController = PageController();

  void nextQuestion() {
    final quizzProvider = Provider.of<QuizzesProvider?>(context, listen: false);
    setState(() {
      if (currentQuestionIndex < quizzProvider!.results!.length - 0) {
        currentQuestionIndex++;
        int index = currentQuestionIndex++;


        pageController.jumpTo(index.toDouble());
        pageController.animateToPage(index, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
      } else {
        // Quiz has ended, you can perform any action here, e.g. show results
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Quiz Over'),
              content: Text("your score is:- " + score.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  String ans = "";

  int score = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(ans);
    return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        // body: Text("ujala"),);
        body: Consumer<QuizzesProvider>(builder: (context, quizz, child) {
          return (quizz.results == null)
              ? Center(
                  child: Text("loding ..."),
                )
              : Column(
                  children: [
                    Container(
                      height: size.height - 200,
                      // color: Colors.redAccent,
                      child: PageView.builder(
                          controller: pageController,
                          itemCount: quizz.results!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    // questions[currentQuestionIndex]['question'],
                                    quizz.results![index].question.toString(),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: (size.height / 3) - 58,
                                        // color: Colors.redAccent,
                                        child: ListView.builder(
                                          itemCount: quizz.results![index]
                                              .incorrectAnswers!.length,
                                          itemBuilder:
                                              (BuildContext context, int i) {
                                            String option = quizz
                                                .results![index]
                                                .incorrectAnswers![i]
                                                .toString()
                                                .toString();
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Color(0x89ffa443),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ListTile(
                                                  title: Text(option),
                                                  onTap: () {
                                                    if (option ==
                                                        quizz.results![index]
                                                            .correctAnswer
                                                            .toString()) {
                                                      // Handle correct answer

                                                      score--;

                                                      setState(() {});
                                                      ans = "Correct!";
                                                      print(ans);
                                                    } else {
                                                      // Handle incorrect answer
                                                      setState(() {
                                                        ans = "Incorrect!";
                                                      });
                                                      print(ans);
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0x89ffa443),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ListTile(
                                          title: Text(quizz
                                              .results![index].correctAnswer
                                              .toString()),
                                          onTap: () {
                                            score++;
                                            setState(() {});
                                            ans = "Correct!";
                                            print(ans);
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "$ans",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                    //SizedBox(height: 10,),
                    CupertinoButton(
                        child: Container(
                          height: 50,
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Color(0xffff8300),
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          child: Text(
                            "Next Qustion",
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () {
                          ans = "";
                          nextQuestion();
                        })
                  ],
                );
        }));
  }
}
