import 'package:equations/equations.dart';
//import 'dart:core';

class Solver {
  Solver(this.equation);
  final equation;

  Future solve() async {
    String equationWithoutWhiteSpace =
        equation.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    print('no white spaces:');
    print(equationWithoutWhiteSpace);

    final newton = Newton("$equationWithoutWhiteSpace", -1, maxSteps: 5);
    final solutions = await newton.solve();
    print(solutions);
    return solutions.guesses[solutions.guesses.length - 1];
  }
}
