import 'dart:core';
import 'dart:ffi';

int MIN_POWER = 0;
int MAX_POWER = 2;

int MIN_SIZING = 0;
int MAX_SIZING = 10;

// Main ------------------------------------------------------------------------------------------------------ //

void main() {
  print("~~~~~~~~~~~~~~~~~~~~\n");
  test__StrategyA();
  test__StrategyB();
  test__winrateDef();
  test__esperanceB();
  test_globalEquityB();
  test_findBestStratB();

  print("\n~~~~~~~~~~~~~~~~~~~~");
}

// Test utils ------------------------------------------------------------------------------------------------------ //

void assertTrue(bool condition, String description) {
  if (true == condition) {
    print("test OK : " + description);
  } else {
    print("/!\\ : test KO : " + description);
  }
}

bool eqDouble(double a, double b)
{
  double diff = a - b;
  return diff.abs() < 0.000001;
}

// Unity definition ------------------------------------------------------------------------------------------------------ //

enum ChoixB { fold, call }

typedef Range = List<int>;

// Compute utils ------------------------------------------------------------------------------------------------------ //

double winrateDef({required int POWERDef, required Range rangeAtk}) {
  double ret = 0.0;
  for (int element in rangeAtk) {
    if (POWERDef >= element) {
      ret = ret + 1.0;
    }
  }
  ret = ret / rangeAtk.length.toDouble();
  return ret;
}

void test__winrateDef() {
  Range rangeAtk = [0, 1, 2];
  int POWERDef = 1;
  assertTrue(
      winrateDef(POWERDef: POWERDef, rangeAtk: rangeAtk) == 2 / 3,
      "winrateDef(POWERDef: POWERDef, rangeAtk: rangeAtk).compare(2/3))");
}

// Strategy A ------------------------------------------------------------------------------------------------------ //

class StrategyA {
  //pwrA -> sizingA
  Map<int, int> _map = {};

  // check by default
  StrategyA({Map<int, int>? map}) {
    if (map != null) {
      _map = map;
    } else {
      for (int pwrA = MIN_POWER;
          pwrA <= MAX_POWER;
          pwrA++) {
        _map[pwrA] = 0;
      }
    }
  }

  void set({required int pwrA, required int sizingA}) {
    _map[pwrA] = sizingA;
  }

  int f({required int pwrA}) {
    return _map[pwrA]!;
  }

  Range getRange({required int sizingA}) {
    Range ret = [];
    _map.forEach((key, value) {
      if (value == sizingA) {
        ret.add(key);
      }
    });
    if (ret.length == 0) {
      print("WARNING, range empty");
      print("_map : $_map");
      print("sizingA : ${sizingA}");
    }
    return ret;
  }

  List<int> getSizingList()
  {
    List<int> ret = [];
    ret.add(_map[MIN_POWER]!);
    for(int pwrA = MIN_POWER; pwrA <= MAX_POWER; pwrA++)
    {
      int sizingA = _map[pwrA]!;
      if(!ret.contains(sizingA))
      {
        ret.add(sizingA);
      }
    }
    return ret;
  }

  double getFreqSizing(int sizingA)
  {
    int count = 0;
    for(int pwrA = MIN_POWER; pwrA <= MAX_POWER; pwrA++)
    {
      if(_map[pwrA]! == sizingA)
      {
        count++;
      }
    }
    return count/(1+MAX_POWER-MIN_POWER) ;
  }
}

void test__StrategyA() {
  MIN_POWER = 0;
  MAX_POWER = 1;

  StrategyA strategyA = StrategyA();
  strategyA.set(pwrA: 0, sizingA: 0);
  strategyA.set(pwrA: 1, sizingA: 10);

  assertTrue(strategyA.f(pwrA: 0) == 0,
      "strategyA.f(pwrA:0)) == 0)");
  assertTrue(strategyA.f(pwrA: 1) == 10,
      "strategyA.f(pwrA:1)) == 10)");
  assertTrue(
      (strategyA.getRange(sizingA: 10)[0] == 1) &&
          (strategyA.getRange(sizingA: 10).length == 1),
      "(strategyA.getRange(sizingA : 10))[0] == 1)) && (strategyA.getRange(sizingA : 10)).length == 1)");
  assertTrue(strategyA.getFreqSizing(10) == 0.5, "strategyA.freqSizing(10)) == 0.5)");
  assertTrue(strategyA.getFreqSizing(0) == 0.5, "strategyA.freqSizing(0)) == 0.5)");
  assertTrue(strategyA.getFreqSizing(2) == 0.0, "strategyA.freqSizing(2)) == 0.0)");
}

// Strategy B ------------------------------------------------------------------------------------------------------ //

class StrategyB {
  // pwr -> chip -> choix
  Map<int, Map<int, int>> _map = {};

  // fold by default
  StrategyB() {
    for (int pwrB = MIN_POWER;
        pwrB <= MAX_POWER;
        pwrB++) {
      _map[pwrB] = {};
      for (int sizingA = MIN_SIZING;
          sizingA <= MAX_SIZING ;
          sizingA++) {
        _map[pwrB]![sizingA] = ChoixB.fold.index;
      }
    }
  }

  void set(
      {required int pwrB,
      required int sizingA,
      required ChoixB choixB}) {
    _map[pwrB]![sizingA] = choixB.index;
  }

/*   void copy({required StrategyB other})
  {
    _map.forEach((key, value) { })
  }
 */
  ChoixB f({required int pwrB, required int sizingA}) {
    return ChoixB.values[_map[pwrB]![sizingA]!];
  }

  String toString({StrategyA? strategyA})
  {
    String ret = "";
    for (int pwrB = MIN_POWER ; pwrB <= MAX_POWER ; pwrB++) 
    {
      ret += "pwrB : ${pwrB}\n";
      for (int sizingA = MIN_SIZING ; sizingA <= MAX_SIZING ; sizingA++)
      {
        ret += "         sizingA : ${sizingA} ";
        if((strategyA!=null) && (!strategyA.getSizingList().contains(sizingA)))
        {
          ret += "         choixB : NEVER HAPPEN ";
        }
        else
        {
          ret += "         choixB : ${ChoixB.values[_map[pwrB]![sizingA]!]} ";
        }
        ret += "\n";
      }
    }
    return ret;
  }
}

void test__StrategyB() {
  StrategyB strategyB = StrategyB();
  strategyB.set(pwrB: 0, sizingA: 0, choixB: ChoixB.call);
  strategyB.set(pwrB: 1, sizingA: 2, choixB: ChoixB.fold);
  assertTrue(
      strategyB.f(pwrB: 0, sizingA: 0) == ChoixB.call,
      "strategyB.f(pwrB: 0), sizingA: 0)) == ChoixB.call");
  assertTrue(
      strategyB.f(pwrB: 1, sizingA: 2) == ChoixB.fold,
      "strategyB.f(pwrB: 1), sizingA: 2)) == ChoixB.fold");
}

// Equity B ------------------------------------------------------------------------------------------------------ //

double esperanceB(
    {required int pwrB,
    required int sizingA,
    required ChoixB choixB,
    required StrategyA strategyA,
    required int pot}) // TODO : tester ca
{
  double ret = 0.0;
  if (choixB == ChoixB.call) {
    ret = (pot + sizingA) *
            winrateDef(
                POWERDef: pwrB,
                rangeAtk: strategyA.getRange(sizingA: sizingA)) +
        (-sizingA )*
            (1.0 -
                winrateDef(
                    POWERDef: pwrB,
                    rangeAtk: strategyA.getRange(sizingA: sizingA)));
  } // else : value stay 0.0

  return ret;
}

void test__esperanceB() {
  MAX_POWER = 1;
  assertTrue(
      eqDouble(esperanceB(
              pwrB: 1,
              sizingA: 0,
              choixB: ChoixB.fold,
              strategyA: StrategyA(),
              pot: 3), 0),
      "test__esperanceB_1");
  assertTrue(
      eqDouble(esperanceB(
              pwrB: 1,
              sizingA: 0,
              choixB: ChoixB.call,
              strategyA: StrategyA(),
              pot: 3),3),
      "test__esperanceB_2");
  assertTrue(
      eqDouble(esperanceB(
              pwrB: 0,
              sizingA: 0,
              choixB: ChoixB.call,
              strategyA: StrategyA(),
              pot: 3),1.5),
      "test__esperanceB_3");
  assertTrue(
      eqDouble(esperanceB(
              pwrB: 0,
              sizingA: 5,
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5}),
              pot: 3), 1.5),
      "test__esperanceB_4");
  MAX_POWER = 2;
  assertTrue(
      eqDouble(esperanceB(
              pwrB: 0,
              sizingA: 5,
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5, 2: 5}),
              pot: 3), -(2 / 3)),
      "test__esperanceB_5");
  
  MAX_POWER = 3;
  assertTrue(
      eqDouble(esperanceB(
              pwrB: 0,
              sizingA: 5,
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5, 2: 5, 3: 10}),
              pot: 3), -(2 / 3)),
      "test__esperanceB_6");
}

double globalEquityB({required StrategyB strategyB, required StrategyA strategyA, required int pot})
{
  double ret = 0;
  for (int pwrB = MIN_POWER ; pwrB <= MAX_POWER ; pwrB++)
  {
    for (int sizingA in strategyA.getSizingList()) {
      ret = ret + esperanceB(pwrB: pwrB, sizingA: sizingA, choixB: strategyB.f(pwrB: pwrB, sizingA: sizingA), strategyA: strategyA, pot: pot) * strategyA.getFreqSizing(sizingA);
      //print("pwrB : ${pwrB}  sizingA : ${sizingA}");
      //print("debug globalEquityB esperanceB : ${(esperanceB(pwrB: pwrB, sizingA: sizingA, choixB: strategyB.f(pwrB: pwrB, sizingA: sizingA), strategyA: strategyA, pot: pot) * strategyA.getFreqSizing(sizingA))}");
    }
  }
  ret = ret * 1/(1+MAX_POWER-MIN_POWER );
  return ret;
}

void test_globalEquityB()
{
  MIN_POWER = 0;
  MAX_POWER = 1;

  StrategyA strategyA = StrategyA();
  StrategyB strategyB = StrategyB();
  int pot = 1;

  strategyB.set(pwrB: 0, sizingA: 0, choixB: ChoixB.fold);
  strategyB.set(pwrB: 1, sizingA: 0, choixB: ChoixB.fold);
  assertTrue(globalEquityB(strategyB: strategyB, strategyA: strategyA, pot: pot) == 0, "globalEquityB ff");

  // call with 0
  strategyB.set(pwrB: 0, sizingA: 0, choixB: ChoixB.call);
  strategyB.set(pwrB: 1, sizingA: 0, choixB: ChoixB.fold);
  assertTrue(globalEquityB(strategyB: strategyB, strategyA: strategyA, pot: pot) == 1/4, "globalEquityB cf");

  // call with 1
  strategyB.set(pwrB: 0, sizingA: 0, choixB: ChoixB.fold);
  strategyB.set(pwrB: 1, sizingA: 0, choixB: ChoixB.call);
  assertTrue(globalEquityB(strategyB: strategyB, strategyA: strategyA, pot: pot) == 2/4, "globalEquityB fc");

  // full call
  strategyB.set(pwrB: 0, sizingA: 0, choixB: ChoixB.call);
  strategyB.set(pwrB: 1, sizingA: 0, choixB: ChoixB.call);
  assertTrue(globalEquityB(strategyB: strategyB, strategyA: strategyA, pot: pot) == 3/4, "globalEquityB cc");

}

StrategyB findBestStrategyB({required StrategyA strategyA, required int pot})
{
  StrategyB ret = StrategyB();

  StrategyB iterateStrategyB = StrategyB();

  double eqB = globalEquityB(strategyB: iterateStrategyB, strategyA: strategyA, pot: pot);

  for (int pwrB = MIN_POWER ; pwrB <= MAX_POWER ; pwrB++) 
  {
    for (int sizingA in strategyA.getSizingList())
    {
      for (int i = 0; i <= 1; i++) 
      {
        ChoixB choixB;
        if(i == 0)
        {
          choixB = ChoixB.fold;
        }
        else
        {
          choixB = ChoixB.call;
        }
        //
        iterateStrategyB.set(pwrB: pwrB, sizingA: sizingA, choixB: choixB); // mais on a pas reset les autres path !!!
        double tempEqB = globalEquityB(strategyB: iterateStrategyB, strategyA: strategyA, pot: pot);
        print("treat stratA (pwrB:${pwrB} sizingA:${sizingA} choixB:${choixB.index}) : \n${iterateStrategyB.toString()}\ntempEqB:${tempEqB}\n\n\n");
        if(tempEqB > eqB)
        {
          eqB = tempEqB;
          ret.set(pwrB: pwrB, sizingA: sizingA, choixB: choixB);// nope: set alla pths not one
        }
      }
    }
  }
  return ret;
}

class CouplePwrBSizingA
{
  int pwrB;
  int sizA;

  CouplePwrBSizingA(this.pwrB, this.sizA);

  CouplePwrBSizingA.copy(CouplePwrBSizingA couplePwrBSizingA) : pwrB = couplePwrBSizingA.pwrB, sizA = couplePwrBSizingA.sizA;

  @override
  String toString() {
    return "$pwrB:$sizA";
  }
}

class ListCouplePwrBSizingA
{
  late List<CouplePwrBSizingA> list;

  ListCouplePwrBSizingA.empty()
  {
    list = [];
  }

  ListCouplePwrBSizingA.universe()
  {
    list = [];
    for (int iPwrB = MIN_POWER ; iPwrB <= MAX_POWER ; iPwrB++)
    {
      for (int iSizA = MIN_SIZING ; iSizA <= MAX_SIZING ; iSizA++)
      {
        CouplePwrBSizingA c = CouplePwrBSizingA(iPwrB, iSizA);
        list.add(c);
      }
    }
  }

  ListCouplePwrBSizingA.copy(ListCouplePwrBSizingA listCouplePwrBSizingA)
  {
    list = [];
    for (CouplePwrBSizingA elem in listCouplePwrBSizingA.list) {
      list.add(CouplePwrBSizingA.copy(elem));
    }
  }


  @override
  String toString() {
    return list.toString();
  }
}

StrategyB _recBestFindStratB(ListCouplePwrBSizingA P, ListCouplePwrBSizingA A, StrategyB actBestStratB, StrategyA strategyA, int pot)
{
  // com = completed  red = reduced
  while(A.list.isNotEmpty)
  {
    CouplePwrBSizingA elem = A.list[0];
    StrategyB strategyB = StrategyB();
    for (CouplePwrBSizingA p in P.list) {
      strategyB.set(pwrB: p.pwrB, sizingA: p.sizA, choixB: ChoixB.call);
    }
    strategyB.set(pwrB: elem.pwrB, sizingA: elem.sizA, choixB: ChoixB.call);
    if( globalEquityB(strategyB: strategyB, strategyA: strategyA, pot: pot) > globalEquityB(strategyB: actBestStratB, strategyA: strategyA, pot: pot))
    {
      actBestStratB = strategyB;
    }

    ListCouplePwrBSizingA comP = ListCouplePwrBSizingA.copy(P);
    comP.list.add(elem);
    A.list.removeWhere((a) => (elem.pwrB == a.pwrB) && (elem.sizA == a.sizA));
    ListCouplePwrBSizingA redA = ListCouplePwrBSizingA.copy(A);
    if(redA.list.length > 0)
    {
      actBestStratB = _recBestFindStratB(comP, redA, actBestStratB, strategyA, pot);
    }
  }
  return actBestStratB;
}

StrategyB findBestStratB(StrategyA strategyA, int pot) 
{
  StrategyB strategyB = StrategyB();
  ListCouplePwrBSizingA P = ListCouplePwrBSizingA.empty();
  ListCouplePwrBSizingA A = ListCouplePwrBSizingA.universe();

  return _recBestFindStratB(P, A, strategyB, strategyA, pot);
}

void test_findBestStratB()
{
  MIN_POWER = 0;
  MAX_POWER = 2;
  MIN_SIZING = 0;
  MAX_SIZING = 2;

  /* full check */
  StrategyA strategyA = StrategyA();
  strategyA.set(pwrA: 0, sizingA: MAX_SIZING );
  strategyA.set(pwrA: 1, sizingA: MAX_SIZING );
  strategyA.set(pwrA: 2, sizingA: MAX_SIZING );
  
  int pot = 1;

  StrategyB strategyB = findBestStratB(strategyA, pot);

  assertTrue(strategyB.f(pwrB: 0, sizingA: MAX_SIZING ) == ChoixB.fold, "strategyB.f(pwrB: 0), sizingA: 0)) == ChoixB.fold");
  assertTrue(strategyB.f(pwrB: 1, sizingA: MAX_SIZING ) == ChoixB.call, "strategyB.f(pwrB: 0), sizingA: 0)) == ChoixB.fold");
  assertTrue(strategyB.f(pwrB: 2, sizingA: MAX_SIZING ) == ChoixB.call, "strategyB.f(pwrB: 0), sizingA: 0)) == ChoixB.fold");

}



