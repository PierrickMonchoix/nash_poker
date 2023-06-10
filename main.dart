import 'dart:core';
import 'dart:ffi';
import 'dart:math';

int MIN_POWER = 0;
int MAX_POWER = 2;

List<int> LIST_SIZING = [0, 1];

// Utils ------------------------------------------------------------------------------------------------------ //

class IntWrapper
{
  int body;

  IntWrapper(this.body);
}

bool compareListInt(List<int> a, List<int> b)
{
  bool ret = true;
  ret &= a.length == b.length;
  for (int i = 0; i < a.length; i++) {
    ret &= a[i] == b[i];
  }
  return ret;
}

bool compareDouble(double a, double b)
{
  double diff = a - b;
  return diff.abs() < 0.000001;
}

// Main ------------------------------------------------------------------------------------------------------ //

void main() {
  // MIN_POWER = 0;
  // MAX_POWER = 4;
  // LIST_SIZING = [0,1,2,3];
  // StrategyA strategyA = StrategyA();
  
  // int pot = 10;
  // strategyA.set(pwrA: 0, sizingA: 3 );
  // strategyA.set(pwrA: 1, sizingA: 3 );
  // strategyA.set(pwrA: 2, sizingA: 3 );
  // strategyA.set(pwrA: 3, sizingA: 3 );
  // strategyA.set(pwrA: 4, sizingA: 3 );

  // print(strategyA.getSizingList());
  // StrategyB strategyB = findBestStratB(strategyA, pot);
  // print(strategyB.toString(strategyA: strategyA));
  


  testAll();
}

// Test utils ------------------------------------------------------------------------------------------------------ //

bool TEST = true;

void assertTrue(bool condition, String description) {
  if (true == condition) {
    print("test OK : " + description);
  } else {
    TEST = false;
    print("/!\\ : test KO : " + description);
  }
}





void testAll()
{
  print("~~~~~~~~~~~~~~~~~~~~\n");
  test__StrategyA();
  test__StrategyB();
  test__winrateDef();
  test__esperanceB();
  test_globalEquityB();
  test_findBestStratB();
  test_equityA();

  if(TEST)
  {
    print("\x1b[32m ALL TEST PASSED \x1b[0m");
  }
  else
  {
    print("\x1b[31m SOME TESTS FAILED \x1b[0m");
  }

  print("\n~~~~~~~~~~~~~~~~~~~~");
}

// Unity definition ------------------------------------------------------------------------------------------------------ //

enum ChoixB { fold, call }

typedef RangePower = List<int>;

// Compute utils ------------------------------------------------------------------------------------------------------ //

double winrateDef({required int powerDef, required RangePower rangeAtk}) {
  double ret = 0.0;
  for (int element in rangeAtk) {
    if (powerDef >= element) {
      ret = ret + 1.0;
    }
  }
  ret = ret / rangeAtk.length.toDouble();
  return ret;
}

bool test__winrateDef() {
  bool ret = false;
  RangePower rangeAtk = [0, 1, 2];
  int POWERDef = 1;
  assertTrue(
      winrateDef(powerDef: POWERDef, rangeAtk: rangeAtk) == 2 / 3,
      "winrateDef(POWERDef: POWERDef, rangeAtk: rangeAtk).compare(2/3))");
  return ret;
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

  RangePower getRange({required int sizingA}) {
    RangePower ret = [];
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
  // pwrB -> sizingA -> choixB
  Map<int, Map<int, int>> _map = {};

  // fold by default
  StrategyB() {
    for (int pwrB = MIN_POWER;
        pwrB <= MAX_POWER;
        pwrB++) {
      _map[pwrB] = {};
      for (int sizingA in LIST_SIZING)
      {
        _map[pwrB]![sizingA] = ChoixB.fold.index;
      }
    }
  }

  StrategyB.callByDefault() {
    for (int pwrB = MIN_POWER;
        pwrB <= MAX_POWER;
        pwrB++) {
      _map[pwrB] = {};
      for (int sizingA in LIST_SIZING)
      {
        _map[pwrB]![sizingA] = ChoixB.call.index;
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

  RangePower getRange({required int pSizingA, required ChoixB pChoixB}) {
    RangePower ret = [];          
    _map.forEach((pwrB, mapSizingAChoixB) 
    {
      mapSizingAChoixB.forEach((sizingA, choixB) 
      {
        print("display : $pwrB $sizingA $choixB");
        if ((pSizingA == sizingA) &&  (pChoixB == ChoixB.values[choixB]))
        {
          ret.add(pwrB);
          print("yes");
        }
        else
        {
          print("no");
        }
      });
    });
    if (ret.length == 0) {
      print("WARNING, range empty");
      print("_map : $_map");
      print("sizingA : ${pSizingA}");
    }
    return ret;
  }

  String toString({StrategyA? strategyA})
  {
    String ret = "";
    for (int pwrB = MIN_POWER ; pwrB <= MAX_POWER ; pwrB++) 
    {
      ret += "pwrB : ${pwrB}\n";
      for (int sizingA in LIST_SIZING)
      {
        ret += "         sizingA : ${sizingA} ";
        if((strategyA!=null) && (!strategyA.getSizingList().contains(sizingA)))
        {
          ret += "         choixB : NH "; //NEVER HAPPEN
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
  MIN_POWER = 0;
  MAX_POWER = 1;
  LIST_SIZING = [0, 2];

  StrategyB strategyB = StrategyB();
  strategyB.set(pwrB: 0, sizingA: 0, choixB: ChoixB.call);
  strategyB.set(pwrB: 1, sizingA: 2, choixB: ChoixB.fold);
  assertTrue(
      strategyB.f(pwrB: 0, sizingA: 0) == ChoixB.call,
      "strategyB.f(pwrB: 0), sizingA: 0)) == ChoixB.call");
  assertTrue(
      strategyB.f(pwrB: 1, sizingA: 2) == ChoixB.fold,
      "strategyB.f(pwrB: 1), sizingA: 2)) == ChoixB.fold");

  assertTrue(compareListInt(strategyB.getRange(pSizingA: 0, pChoixB: ChoixB.call), [0]), "strategyB.getRange(pSizingA: 0, pChoixB: ChoixB.call)");
  strategyB.set(pwrB: 1, sizingA: 2, choixB: ChoixB.call);
  assertTrue(compareListInt(strategyB.getRange(pSizingA: 2, pChoixB: ChoixB.call), [1]), "strategyB.getRange(pSizingA: 2, pChoixB: ChoixB.call");
  strategyB.set(pwrB: 0, sizingA: 2, choixB: ChoixB.call);
  assertTrue(compareListInt(strategyB.getRange(pSizingA: 2, pChoixB: ChoixB.call), [0, 1]), "strategyB.getRange(pSizingA: 2, pChoixB: ChoixB.call), [0, 1]");

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
                powerDef: pwrB,
                rangeAtk: strategyA.getRange(sizingA: sizingA)) +
        (-sizingA )*
            (1.0 -
                winrateDef(
                    powerDef: pwrB,
                    rangeAtk: strategyA.getRange(sizingA: sizingA)));
  } // else : value stay 0.0

  return ret;
}

void test__esperanceB() {
  MAX_POWER = 1;
  assertTrue(
      compareDouble(esperanceB(
              pwrB: 1,
              sizingA: 0,
              choixB: ChoixB.fold,
              strategyA: StrategyA(),
              pot: 3), 0),
      "test__esperanceB_1");
  assertTrue(
      compareDouble(esperanceB(
              pwrB: 1,
              sizingA: 0,
              choixB: ChoixB.call,
              strategyA: StrategyA(),
              pot: 3),3),
      "test__esperanceB_2");
  assertTrue(
      compareDouble(esperanceB(
              pwrB: 0,
              sizingA: 0,
              choixB: ChoixB.call,
              strategyA: StrategyA(),
              pot: 3),1.5),
      "test__esperanceB_3");
  assertTrue(
      compareDouble(esperanceB(
              pwrB: 0,
              sizingA: 5,
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5}),
              pot: 3), 1.5),
      "test__esperanceB_4");
  MAX_POWER = 2;
  assertTrue(
      compareDouble(esperanceB(
              pwrB: 0,
              sizingA: 5,
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5, 2: 5}),
              pot: 3), -(2 / 3)),
      "test__esperanceB_5");
  
  MAX_POWER = 3;
  assertTrue(
      compareDouble(esperanceB(
              pwrB: 0,
              sizingA: 5,
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5, 2: 5, 3: 10}),
              pot: 3), -(2 / 3)),
      "test__esperanceB_6");
}

// GlobalEquityB B ------------------------------------------------------------------------------------------------------ //

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

// FindBestStrategyB ------------------------------------------------------------------------------------------------------ //

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
      for (int iSizA in LIST_SIZING)
      {
        CouplePwrBSizingA c = CouplePwrBSizingA(iPwrB, iSizA);
        list.add(c);
      }
    }
  }

  ListCouplePwrBSizingA.universePowerRestricSizing({required List<int> listSizing}) 
  {
    list = [];
    for (int iPwrB = MIN_POWER; iPwrB <= MAX_POWER; iPwrB++) {
      for (int iSizA in listSizing) {
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

StrategyB _recBestFindStratB(ListCouplePwrBSizingA P, ListCouplePwrBSizingA A, StrategyB bestStratB, StrategyA strategyA, int pot, IntWrapper timesRedAEqualZero)
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
    if( globalEquityB(strategyB: strategyB, strategyA: strategyA, pot: pot) > globalEquityB(strategyB: bestStratB, strategyA: strategyA, pot: pot))
    {
      bestStratB = strategyB;
    }

    ListCouplePwrBSizingA comP = ListCouplePwrBSizingA.copy(P);
    comP.list.add(elem);
    A.list.removeWhere((a) => (elem.pwrB == a.pwrB) && (elem.sizA == a.sizA));
    ListCouplePwrBSizingA redA = ListCouplePwrBSizingA.copy(A);
    if(redA.list.length > 0)
    {
      bestStratB = _recBestFindStratB(comP, redA, bestStratB, strategyA, pot, timesRedAEqualZero);
    }
    else // debug print
    {
      int n = LIST_SIZING.length; //maxPath
      num maxTimesRedAEqualZero = pow(2, n) - 1;
      
      print("${(100*timesRedAEqualZero.body/maxTimesRedAEqualZero).toStringAsPrecision(2)}/100 (100% = $maxTimesRedAEqualZero)"); 
      timesRedAEqualZero.body++;
    }
  }
  return bestStratB;
}

StrategyB findBestStratB(StrategyA strategyA, int pot) 
{
  StrategyB strategyB = StrategyB();
  ListCouplePwrBSizingA P = ListCouplePwrBSizingA.empty();
  ListCouplePwrBSizingA A = ListCouplePwrBSizingA.universePowerRestricSizing(listSizing: strategyA.getSizingList());

  return _recBestFindStratB(P, A, strategyB, strategyA, pot, IntWrapper(0));
}

void test_findBestStratB()
{
  MIN_POWER = 0;
  MAX_POWER = 2;
  LIST_SIZING = [0,1,2];

  /* full check */
  StrategyA strategyA = StrategyA();
  strategyA.set(pwrA: 0, sizingA: 2 );
  strategyA.set(pwrA: 1, sizingA: 2 );
  strategyA.set(pwrA: 2, sizingA: 2 );
  
  int pot = 1;

  StrategyB strategyB = findBestStratB(strategyA, pot);

  assertTrue(strategyB.f(pwrB: 0, sizingA: 2 ) == ChoixB.fold, "strategyB.f(pwrB: 0), sizingA: 0)) == ChoixB.fold");
  assertTrue(strategyB.f(pwrB: 1, sizingA: 2 ) == ChoixB.call, "strategyB.f(pwrB: 0), sizingA: 0)) == ChoixB.fold");
  assertTrue(strategyB.f(pwrB: 2, sizingA: 2 ) == ChoixB.call, "strategyB.f(pwrB: 0), sizingA: 0)) == ChoixB.fold");
  
}

// Equity A ------------------------------------------------------------------------------------------------------ //

double winrateAtk({required int powerAtk, required RangePower rangeDef}) {
  double ret = 0.0;
  for (int element in rangeDef) {
    if (powerAtk > element) {
      ret = ret + 1.0;
    }
  }
  ret = ret / rangeDef.length.toDouble();
  return ret;
}

double equityA({required StrategyB strategyB, required int pwrA, required int sizingA ,required int pot})
{
  double ret = 0.0;
  RangePower rangeB =  strategyB.getRange(pSizingA: sizingA, pChoixB: ChoixB.call);
  double probaBCall = rangeB.length / (1 + MAX_POWER - MIN_POWER);
  double probaAWin = 1;
  if(!rangeB.isEmpty)
  {
    probaAWin = winrateAtk(powerAtk: pwrA, rangeDef: rangeB);
  }
  print("probaBCall $probaBCall   probaAWin $probaAWin rangeB $rangeB");
  ret = (1-probaBCall)*pot + probaBCall*( probaAWin*(pot+sizingA) + (1-probaAWin)*(-sizingA));
  return ret;
}

void test_equityA()
{
  MIN_POWER = 0;
  MAX_POWER = 0;
  LIST_SIZING = [0,1];

  {
    StrategyB strategyB = StrategyB();

    assertTrue(equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 1) == 1, "equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 1) == 1");
    assertTrue(equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 2) == 2, "equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 1) == 1");
    strategyB.set(pwrB: 0, sizingA: 0, choixB: ChoixB.call);
    assertTrue(equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 1) == 0, "equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 1) == 1");
    strategyB.set(pwrB: 0, sizingA: 1, choixB: ChoixB.call);
    assertTrue(equityA(strategyB: strategyB, pwrA: 0, sizingA: 1, pot: 1) == -1, "equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 1) == 1");
    assertTrue(equityA(strategyB: strategyB, pwrA: 0, sizingA: 1, pot: 42) == -1, "equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 1) == 1");
  }


  MIN_POWER = 0;
  MAX_POWER = 1;
  LIST_SIZING = [0,1];

  {
    StrategyB strategyB = StrategyB();
    strategyB.set(pwrB: 1, sizingA: 0, choixB: ChoixB.call);
    strategyB.set(pwrB: 1, sizingA: 1, choixB: ChoixB.call);
    assertTrue(equityA(strategyB: strategyB, pwrA: 0, sizingA: 1, pot: 3) == 1, "equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 1) == 1");
    assertTrue(equityA(strategyB: strategyB, pwrA: 0, sizingA: 1, pot: 5) == 2, "equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 1) == 1");
    assertTrue(equityA(strategyB: strategyB, pwrA: 1, sizingA: 1, pot: 5) == 2, "equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 1) == 1");
  }

  MIN_POWER = 0;
  MAX_POWER = 1;
  LIST_SIZING = [0,5];

  {
    StrategyB strategyB = StrategyB.callByDefault();
    strategyB.set(pwrB: 1, sizingA: 5, choixB: ChoixB.fold);
    assertTrue(compareDouble(equityA(strategyB: strategyB, pwrA: 1, sizingA: 5, pot: 3),5.5), "equityA(strategyB: strategyB, pwrA: 0, sizingA: 0, pot: 1) == 1");
  }
  
  
}