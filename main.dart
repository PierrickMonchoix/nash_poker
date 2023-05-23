import 'dart:core';

class Scalar {
  double _body;

  Scalar(this._body);

  Scalar operator +(Scalar other) {
    Scalar ret = Scalar(0);
    ret._body = _body + other._body;
    return ret;
  }

  Scalar operator -(Scalar other) {
    Scalar ret = Scalar(0);
    ret._body = _body - other._body;
    return ret;
  }

  Scalar operator *(Scalar other) {
    Scalar ret = Scalar(0);
    ret._body = _body * other._body;
    return ret;
  }

  Scalar operator /(Scalar other) {
    Scalar ret = Scalar(0);
    ret._body = _body / other._body;
    return ret;
  }

  bool operator >(Scalar other) {
    return _body > other._body;
  }

  bool operator <(Scalar other) {
    return _body < other._body;
  }

  bool compare(Scalar other) {
    return (_body - other._body).abs() < 0.00001;
  }
}

class FloatChip {
  double _body;

  FloatChip(this._body);

  FloatChip operator +(FloatChip other) {
    FloatChip ret = FloatChip(0);
    ret._body = _body + other._body;
    return ret;
  }

  FloatChip operator -(FloatChip other) {
    FloatChip ret = FloatChip(0);
    ret._body = _body - other._body;
    return ret;
  }

  FloatChip operator *(covariant Scalar Scalar) {
    FloatChip ret = FloatChip(0);
    ret._body = _body * Scalar._body;
    return ret;
  }

  bool operator >(FloatChip other) {
    return _body > other._body;
  }

  bool operator <(FloatChip other) {
    return _body < other._body;
  }

  bool compare(FloatChip other) {
    return (_body - other._body).abs() < 0.00001;
  }
}

class IntChip {
  int _body;

  IntChip(this._body);

  IntChip operator +(IntChip other) {
    IntChip ret = IntChip(0);
    ret._body = _body + other._body;
    return ret;
  }

  // plus equal (++)
  void pe(IntChip other) {
    _body += other._body;
  }

  // plus plus (++)
  void pp() {
    _body++;
  }

  IntChip operator -(IntChip other) {
    IntChip ret = IntChip(0);
    ret._body = _body - other._body;
    return ret;
  }

  FloatChip operator *(covariant Scalar Scalar) {
    FloatChip ret = FloatChip(0);
    ret._body = _body * Scalar._body;
    return ret;
  }

  bool operator >(IntChip other) {
    return _body > other._body;
  }

  bool operator <(IntChip other) {
    return _body < other._body;
  }

  bool operator >=(IntChip other) {
    return _body >= other._body;
  }

  bool operator <=(IntChip other) {
    return _body <= other._body;
  }

  bool operator ==(covariant IntChip other) {
    return _body == other._body;
  }
}

class FloatStrength {
  double _body;

  FloatStrength(this._body);

  FloatStrength operator +(FloatStrength other) {
    FloatStrength ret = FloatStrength(0);
    ret._body = _body + other._body;
    return ret;
  }

  FloatStrength operator -(FloatStrength other) {
    FloatStrength ret = FloatStrength(0);
    ret._body = _body - other._body;
    return ret;
  }

  FloatStrength operator *(covariant Scalar Scalar) {
    FloatStrength ret = FloatStrength(0);
    ret._body = _body * Scalar._body;
    return ret;
  }

  bool operator >(FloatStrength other) {
    return _body > other._body;
  }

  bool operator <(FloatStrength other) {
    return _body < other._body;
  }
}

class IntStrength {
  int _body;

  IntStrength(this._body);

  IntStrength operator +(IntStrength other) {
    IntStrength ret = IntStrength(0);
    ret._body = _body + other._body;
    return ret;
  }

  // plus equal (++)
  void pe(IntStrength other) {
    _body += other._body;
  }

  // plus plus (++)
  void pp() {
    _body++;
  }

  IntStrength operator -(IntStrength other) {
    IntStrength ret = IntStrength(0);
    ret._body = _body - other._body;
    return ret;
  }

  FloatStrength operator *(covariant Scalar Scalar) {
    FloatStrength ret = FloatStrength(0);
    ret._body = _body * Scalar._body;
    return ret;
  }

  bool operator >(IntStrength other) {
    return _body > other._body;
  }

  bool operator <(IntStrength other) {
    return _body < other._body;
  }

  bool operator >=(IntStrength other) {
    return _body >= other._body;
  }

  bool operator <=(IntStrength other) {
    return _body <= other._body;
  }

  bool operator ==(covariant IntStrength other) {
    return _body == other._body;
  }
}

void assertTrue(bool condition, String description) {
  if (true == condition) {
    print("test OK : " + description);
  } else {
    print("/!\\ : test KO : " + description);
  }
}

void main() {
  print("~~~~~~~~~~~~~~~~~~~~\n");
  test__StrategyA();
  test__StrategyB();
  test__winrateDef();
  test__esperanceB();
  print("\n~~~~~~~~~~~~~~~~~~~~");
}

int MIN_STRENGTH = 0;
int MAX_STRENGTH = 2;

int MIN_SIZING = 0;
int MAX_SIZING = 10;

enum ChoixB { fold, call }

typedef Range = List<IntStrength>;

Scalar winrateDef({required IntStrength strengthDef, required Range rangeAtk}) {
  Scalar ret = Scalar(0.0);
  for (IntStrength element in rangeAtk) {
    if (strengthDef >= element) {
      ret = ret + Scalar(1.0);
    }
  }
  ret = ret / Scalar(rangeAtk.length.toDouble());
  return ret;
}

void test__winrateDef() {
  Range rangeAtk = [IntStrength(0), IntStrength(1), IntStrength(2)];
  IntStrength strengthDef = IntStrength(1);
  assertTrue(
      winrateDef(strengthDef: strengthDef, rangeAtk: rangeAtk)
          .compare(Scalar(2 / 3)),
      "winrateDef(strengthDef: strengthDef, rangeAtk: rangeAtk).compare(Scalar(2/3))");
}

class StrategyA {
  //strA -> sizingA
  Map<int, int> _map = {};

  StrategyA({Map<int, int>? map}) {
    if (map != null) {
      _map = map;
    } else {
      for (IntStrength strA = IntStrength(MIN_STRENGTH);
          strA <= IntStrength(MAX_STRENGTH);
          strA.pp()) {
        _map[strA._body] = IntChip(0)._body;
      }
    }
  }

  void set({required IntStrength strA, required IntChip sizingA}) {
    _map[strA._body] = sizingA._body;
  }

  IntChip f({required IntStrength strA}) {
    return IntChip(_map[strA._body]!);
  }

  Range getRange({required IntChip sizingA}) {
    Range ret = [];
    _map.forEach((key, value) {
      if (value == sizingA._body) {
        ret.add(IntStrength(key));
      }
    });
    if (ret.length == 0) {
      print("WARNING, range empty");
      print("_map : $_map");
      print("sizingA : ${sizingA._body}");
    }
    return ret;
  }
}

void test__StrategyA() {
  StrategyA strategyA = StrategyA();
  strategyA.set(strA: IntStrength(0), sizingA: IntChip(0));
  strategyA.set(strA: IntStrength(1), sizingA: IntChip(10));
  assertTrue(strategyA.f(strA: IntStrength(0)) == IntChip(0),
      "strategyA.f(strA:IntStrength(0)) == IntChip(0)");
  assertTrue(strategyA.f(strA: IntStrength(1)) == IntChip(10),
      "strategyA.f(strA:IntStrength(1)) == IntChip(10)");
  assertTrue(
      (strategyA.getRange(sizingA: IntChip(10))[0] == IntStrength(1)) &&
          (strategyA.getRange(sizingA: IntChip(10)).length == 1),
      "(strategyA.getRange(sizingA : IntChip(10))[0] == IntStrength(1)) && (strategyA.getRange(sizingA : IntChip(10)).length == 1)");
}

class StrategyB {
  // str -> chip -> choix
  Map<int, Map<int, int>> _map = {};

  StrategyB() {
    for (IntStrength strB = IntStrength(MIN_STRENGTH);
        strB <= IntStrength(MAX_STRENGTH);
        strB.pp()) {
      _map[strB._body] = {};
      for (IntChip sizingA = IntChip(MIN_SIZING);
          sizingA <= IntChip(MAX_SIZING);
          sizingA.pp()) {
        _map[strB._body]![sizingA._body] = ChoixB.fold.index;
      }
    }
  }

  void set(
      {required IntStrength strB,
      required IntChip sizingA,
      required ChoixB choixB}) {
    _map[strB._body]![sizingA._body] = choixB.index;
  }

  ChoixB f({required IntStrength strB, required IntChip sizingA}) {
    return ChoixB.values[_map[strB._body]![sizingA._body]!];
  }
}

void test__StrategyB() {
  StrategyB strategyB = StrategyB();
  strategyB.set(strB: IntStrength(0), sizingA: IntChip(0), choixB: ChoixB.call);
  strategyB.set(strB: IntStrength(1), sizingA: IntChip(2), choixB: ChoixB.fold);
  assertTrue(
      strategyB.f(strB: IntStrength(0), sizingA: IntChip(0)) == ChoixB.call,
      "strategyB.f(strB: IntStrength(0), sizingA: IntChip(0)) == ChoixB.call");
  assertTrue(
      strategyB.f(strB: IntStrength(1), sizingA: IntChip(2)) == ChoixB.fold,
      "strategyB.f(strB: IntStrength(1), sizingA: IntChip(2)) == ChoixB.fold");
}

FloatChip esperanceB(
    {required IntStrength strB,
    required IntChip sizingA,
    required ChoixB choixB,
    required StrategyA strategyA,
    required IntChip pot}) // TODO : tester ca
{
  FloatChip ret = FloatChip(0.0);
  if (choixB == ChoixB.call) {
    ret = (pot + sizingA) *
            winrateDef(
                strengthDef: strB,
                rangeAtk: strategyA.getRange(sizingA: sizingA)) +
        (IntChip(0) - sizingA) *
            (Scalar(1.0) -
                winrateDef(
                    strengthDef: strB,
                    rangeAtk: strategyA.getRange(sizingA: sizingA)));
  } // else : value stay 0.0

  return ret;
}

void test__esperanceB() {
  MAX_STRENGTH = 1;
  assertTrue(
      esperanceB(
              strB: IntStrength(1),
              sizingA: IntChip(0),
              choixB: ChoixB.fold,
              strategyA: StrategyA(),
              pot: IntChip(3))
          .compare(FloatChip(0.0)),
      "test__esperanceB_1");
  assertTrue(
      esperanceB(
              strB: IntStrength(1),
              sizingA: IntChip(0),
              choixB: ChoixB.call,
              strategyA: StrategyA(),
              pot: IntChip(3))
          .compare(FloatChip(3.0)),
      "test__esperanceB_2");
  assertTrue(
      esperanceB(
              strB: IntStrength(0),
              sizingA: IntChip(0),
              choixB: ChoixB.call,
              strategyA: StrategyA(),
              pot: IntChip(3))
          .compare(FloatChip(1.5)),
      "test__esperanceB_3");
  assertTrue(
      esperanceB(
              strB: IntStrength(0),
              sizingA: IntChip(5),
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5}),
              pot: IntChip(3))
          .compare(FloatChip(1.5)),
      "test__esperanceB_4");
  MAX_STRENGTH = 2;
  assertTrue(
      esperanceB(
              strB: IntStrength(0),
              sizingA: IntChip(5),
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5, 2: 5}),
              pot: IntChip(3))
          .compare(FloatChip(-2 / 3)),
      "test__esperanceB_5");
  MAX_STRENGTH = 3;
  assertTrue(
      esperanceB(
              strB: IntStrength(0),
              sizingA: IntChip(5),
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5, 2: 5, 3: 10}),
              pot: IntChip(3))
          .compare(FloatChip(-2 / 3)),
      "test__esperanceB_6");
}
