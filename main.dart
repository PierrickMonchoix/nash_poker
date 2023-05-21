void assertTrue(bool condition, String description) {
  if (true == condition) {
    print("test OK : " + description);
  } else {
    print("/!\\ : test KO : " + description);
  }
}

void main() {
  print("~~~~~~~~~~~~~~~~~~~~\n");
  test__StrategyA_f();
  test__StrategyB_f();
  print("\n~~~~~~~~~~~~~~~~~~~~");
}

final int MIN_STRENGTH = 0;
final int MAX_STRENGTH = 2;
typedef Strength = int;

int MIN_SIZING = 0;
int MAX_SIZING = 10;
typedef SizingA = int;

enum ChoixB { call, fold }

class StrategyA {
  Map<Strength, SizingA> _map = {};

  StrategyA() {
    for (Strength strA = MIN_STRENGTH; strA <= MAX_STRENGTH; strA++) {
      _map[strA] = 0;
    }
  }

  void set({required Strength strA, required SizingA sizingA}) {
    _map[strA] = sizingA;
  }

  SizingA f({required Strength strA}) {
    return _map[strA]!;
  }
}

class StrategyB {
  Map<Strength, Map<SizingA, ChoixB>> _map = {};

  StrategyB() {
    for (Strength strB = MIN_STRENGTH; strB <= MAX_STRENGTH; strB++) {
      _map[strB] = {};
      for (SizingA sizingA = MIN_SIZING; sizingA <= MAX_SIZING; sizingA++) {
        _map[strB]![sizingA] = ChoixB.fold;
      }
    }
  }

  void set({required Strength strB, required SizingA sizingA, required ChoixB choixB}) {
    _map[strB]![sizingA] = choixB;
  }

  ChoixB f({required Strength strB, required SizingA sizingA}) {
    return _map[strB]![sizingA]!;
  }
}

void test__StrategyA_f() {
  StrategyA strategyA = StrategyA();
  strategyA.set(strA: 0, sizingA: 0);
  strategyA.set(strA: 1, sizingA: 10);
  assertTrue(strategyA.f(strA:0) == 0, "strategyA.f(strA:0) == 0");
  assertTrue(strategyA.f(strA:1) == 10, "strategyA.f(strA:1) == 10");
}

void test__StrategyB_f() {
  StrategyB strategyB = StrategyB();
  strategyB.set(strB: 0, sizingA: 0, choixB: ChoixB.call);
  strategyB.set(strB: 1, sizingA: 2, choixB: ChoixB.fold);
  assertTrue(strategyB.f(strB: 0, sizingA: 0) == ChoixB.call, "strategyB.f(strB: 0, sizingA: 0) == ChoixB.call");
  assertTrue(strategyB.f(strB: 1, sizingA: 2) == ChoixB.fold, "strategyB.f(strB: 1, sizingA: 2) == ChoixB.fold");
}
