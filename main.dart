import 'dart:core';
import 'dart:ffi';

int MIN_POWER = 0;
int MAX_POWER = 2;

int MIN_SIZING = 0;
int MAX_SIZING = 10;

// Main ------------------------------------------------------------------------------------------------------ //

void main() {
  print("~~~~~~~~~~~~~~~~~~~~\n");
/*   test__StrategyA();
  test__StrategyB();
  test__winrateDef();
  test__esperanceB();
  test_globalEquityB();
  //test_findBestStrategyB(); */

  test_find();

  MIN_POWER = 0;
  MAX_POWER = 1;

  MIN_SIZING = 0;
  MAX_SIZING = 1;



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

// Unity definition ------------------------------------------------------------------------------------------------------ //



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

  bool operator ==(covariant Scalar other) {
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

  bool operator ==(covariant FloatChip other) {
    return (_body - other._body).abs() < 0.00001;
  }
}

class IntChip {
  int _body;

  
  @override
  String toString() {
    return "$_body";
  }

  IntChip(this._body);

  IntChip.copy(IntChip intChip): _body=intChip._body;

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

class FloatPower {
  double _body;

  FloatPower(this._body);

  FloatPower operator +(FloatPower other) {
    FloatPower ret = FloatPower(0);
    ret._body = _body + other._body;
    return ret;
  }

  FloatPower operator -(FloatPower other) {
    FloatPower ret = FloatPower(0);
    ret._body = _body - other._body;
    return ret;
  }

  FloatPower operator *(covariant Scalar Scalar) {
    FloatPower ret = FloatPower(0);
    ret._body = _body * Scalar._body;
    return ret;
  }

  bool operator >(FloatPower other) {
    return _body > other._body;
  }

  bool operator <(FloatPower other) {
    return _body < other._body;
  }
}

class IntPower {
  int _body;

  @override
  String toString() {
    return "$_body";
  }

  IntPower(this._body);

  IntPower.copy(IntPower intPower): _body=intPower._body;

  IntPower operator +(IntPower other) {
    IntPower ret = IntPower(0);
    ret._body = _body + other._body;
    return ret;
  }

  // plus equal (++)
  void pe(IntPower other) {
    _body += other._body;
  }

  // plus plus (++)
  void pp() {
    _body++;
  }

  IntPower operator -(IntPower other) {
    IntPower ret = IntPower(0);
    ret._body = _body - other._body;
    return ret;
  }

  FloatPower operator *(covariant Scalar Scalar) {
    FloatPower ret = FloatPower(0);
    ret._body = _body * Scalar._body;
    return ret;
  }

  bool operator >(IntPower other) {
    return _body > other._body;
  }

  bool operator <(IntPower other) {
    return _body < other._body;
  }

  bool operator >=(IntPower other) {
    return _body >= other._body;
  }

  bool operator <=(IntPower other) {
    return _body <= other._body;
  }

  bool operator ==(covariant IntPower other) {
    return _body == other._body;
  }
}

enum ChoixB { fold, call }

typedef Range = List<IntPower>;

// Compute utils ------------------------------------------------------------------------------------------------------ //

Scalar winrateDef({required IntPower POWERDef, required Range rangeAtk}) {
  Scalar ret = Scalar(0.0);
  for (IntPower element in rangeAtk) {
    if (POWERDef >= element) {
      ret = ret + Scalar(1.0);
    }
  }
  ret = ret / Scalar(rangeAtk.length.toDouble());
  return ret;
}

void test__winrateDef() {
  Range rangeAtk = [IntPower(0), IntPower(1), IntPower(2)];
  IntPower POWERDef = IntPower(1);
  assertTrue(
      winrateDef(POWERDef: POWERDef, rangeAtk: rangeAtk) == Scalar(2 / 3),
      "winrateDef(POWERDef: POWERDef, rangeAtk: rangeAtk).compare(Scalar(2/3))");
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
      for (IntPower pwrA = IntPower(MIN_POWER);
          pwrA <= IntPower(MAX_POWER);
          pwrA.pp()) {
        _map[pwrA._body] = IntChip(0)._body;
      }
    }
  }

  void set({required IntPower pwrA, required IntChip sizingA}) {
    _map[pwrA._body] = sizingA._body;
  }

  IntChip f({required IntPower pwrA}) {
    return IntChip(_map[pwrA._body]!);
  }

  Range getRange({required IntChip sizingA}) {
    Range ret = [];
    _map.forEach((key, value) {
      if (value == sizingA._body) {
        ret.add(IntPower(key));
      }
    });
    if (ret.length == 0) {
      print("WARNING, range empty");
      print("_map : $_map");
      print("sizingA : ${sizingA._body}");
    }
    return ret;
  }

  List<IntChip> getSizingList()
  {
    List<IntChip> ret = [];
    ret.add(IntChip(_map[MIN_POWER]!));
    for(IntPower pwrA = IntPower(MIN_POWER); pwrA <= IntPower(MAX_POWER); pwrA.pp())
    {
      IntChip sizingA = IntChip(_map[pwrA._body]!);
      if(!ret.contains(sizingA))
      {
        ret.add(sizingA);
      }
    }
    return ret;
  }

  Scalar getFreqSizing(IntChip sizingA)
  {
    int count = 0;
    for(IntPower pwrA = IntPower(MIN_POWER); pwrA <= IntPower(MAX_POWER); pwrA.pp())
    {
      if(IntChip(_map[pwrA._body]!) == sizingA)
      {
        count++;
      }
    }
    return Scalar(count/(1+MAX_POWER-MIN_POWER));
  }
}

void test__StrategyA() {
  MIN_POWER = 0;
  MAX_POWER = 1;

  StrategyA strategyA = StrategyA();
  strategyA.set(pwrA: IntPower(0), sizingA: IntChip(0));
  strategyA.set(pwrA: IntPower(1), sizingA: IntChip(10));

  assertTrue(strategyA.f(pwrA: IntPower(0)) == IntChip(0),
      "strategyA.f(pwrA:IntPower(0)) == IntChip(0)");
  assertTrue(strategyA.f(pwrA: IntPower(1)) == IntChip(10),
      "strategyA.f(pwrA:IntPower(1)) == IntChip(10)");
  assertTrue(
      (strategyA.getRange(sizingA: IntChip(10))[0] == IntPower(1)) &&
          (strategyA.getRange(sizingA: IntChip(10)).length == 1),
      "(strategyA.getRange(sizingA : IntChip(10))[0] == IntPower(1)) && (strategyA.getRange(sizingA : IntChip(10)).length == 1)");
  assertTrue(strategyA.getFreqSizing(IntChip(10)) == Scalar(0.5), "strategyA.freqSizing(IntChip(10)) == Scalar(0.5)");
  assertTrue(strategyA.getFreqSizing(IntChip(0)) == Scalar(0.5), "strategyA.freqSizing(IntChip(0)) == Scalar(0.5)");
  assertTrue(strategyA.getFreqSizing(IntChip(2)) == Scalar(0.0), "strategyA.freqSizing(IntChip(2)) == Scalar(0.0)");
}

// Strategy B ------------------------------------------------------------------------------------------------------ //

class StrategyB {
  // pwr -> chip -> choix
  Map<int, Map<int, int>> _map = {};

  // fold by default
  StrategyB() {
    for (IntPower pwrB = IntPower(MIN_POWER);
        pwrB <= IntPower(MAX_POWER);
        pwrB.pp()) {
      _map[pwrB._body] = {};
      for (IntChip sizingA = IntChip(MIN_SIZING);
          sizingA <= IntChip(MAX_SIZING);
          sizingA.pp()) {
        _map[pwrB._body]![sizingA._body] = ChoixB.fold.index;
      }
    }
  }

  void set(
      {required IntPower pwrB,
      required IntChip sizingA,
      required ChoixB choixB}) {
    _map[pwrB._body]![sizingA._body] = choixB.index;
  }

/*   void copy({required StrategyB other})
  {
    _map.forEach((key, value) { })
  }
 */
  ChoixB f({required IntPower pwrB, required IntChip sizingA}) {
    return ChoixB.values[_map[pwrB._body]![sizingA._body]!];
  }

  String toString({StrategyA? strategyA})
  {
    String ret = "";
    for (IntPower pwrB = IntPower(MIN_POWER); pwrB <= IntPower(MAX_POWER); pwrB.pp()) 
    {
      ret += "pwrB : ${pwrB._body}\n";
      for (IntChip sizingA = IntChip(MIN_SIZING); sizingA <= IntChip(MAX_SIZING); sizingA.pp())
      {
        ret += "         sizingA : ${sizingA._body} ";
        if((strategyA!=null) && (!strategyA.getSizingList().contains(sizingA)))
        {
          ret += "         choixB : NEVER HAPPEN ";
        }
        else
        {
          ret += "         choixB : ${ChoixB.values[_map[pwrB._body]![sizingA._body]!]} ";
        }
        ret += "\n";
      }
    }
    return ret;
  }
}

void test__StrategyB() {
  StrategyB strategyB = StrategyB();
  strategyB.set(pwrB: IntPower(0), sizingA: IntChip(0), choixB: ChoixB.call);
  strategyB.set(pwrB: IntPower(1), sizingA: IntChip(2), choixB: ChoixB.fold);
  assertTrue(
      strategyB.f(pwrB: IntPower(0), sizingA: IntChip(0)) == ChoixB.call,
      "strategyB.f(pwrB: IntPower(0), sizingA: IntChip(0)) == ChoixB.call");
  assertTrue(
      strategyB.f(pwrB: IntPower(1), sizingA: IntChip(2)) == ChoixB.fold,
      "strategyB.f(pwrB: IntPower(1), sizingA: IntChip(2)) == ChoixB.fold");
}

// Equity B ------------------------------------------------------------------------------------------------------ //

FloatChip esperanceB(
    {required IntPower pwrB,
    required IntChip sizingA,
    required ChoixB choixB,
    required StrategyA strategyA,
    required IntChip pot}) // TODO : tester ca
{
  FloatChip ret = FloatChip(0.0);
  if (choixB == ChoixB.call) {
    ret = (pot + sizingA) *
            winrateDef(
                POWERDef: pwrB,
                rangeAtk: strategyA.getRange(sizingA: sizingA)) +
        (IntChip(0) - sizingA) *
            (Scalar(1.0) -
                winrateDef(
                    POWERDef: pwrB,
                    rangeAtk: strategyA.getRange(sizingA: sizingA)));
  } // else : value stay 0.0

  return ret;
}

void test__esperanceB() {
  MAX_POWER = 1;
  assertTrue(
      esperanceB(
              pwrB: IntPower(1),
              sizingA: IntChip(0),
              choixB: ChoixB.fold,
              strategyA: StrategyA(),
              pot: IntChip(3))==FloatChip(0.0),
      "test__esperanceB_1");
  assertTrue(
      esperanceB(
              pwrB: IntPower(1),
              sizingA: IntChip(0),
              choixB: ChoixB.call,
              strategyA: StrategyA(),
              pot: IntChip(3))==FloatChip(3.0),
      "test__esperanceB_2");
  assertTrue(
      esperanceB(
              pwrB: IntPower(0),
              sizingA: IntChip(0),
              choixB: ChoixB.call,
              strategyA: StrategyA(),
              pot: IntChip(3))==FloatChip(1.5),
      "test__esperanceB_3");
  assertTrue(
      esperanceB(
              pwrB: IntPower(0),
              sizingA: IntChip(5),
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5}),
              pot: IntChip(3))==FloatChip(1.5),
      "test__esperanceB_4");
  MAX_POWER = 2;
  assertTrue(
      esperanceB(
              pwrB: IntPower(0),
              sizingA: IntChip(5),
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5, 2: 5}),
              pot: IntChip(3))==FloatChip(-2 / 3),
      "test__esperanceB_5");
  MAX_POWER = 3;
  assertTrue(
      esperanceB(
              pwrB: IntPower(0),
              sizingA: IntChip(5),
              choixB: ChoixB.call,
              strategyA: StrategyA(map: {0: 5, 1: 5, 2: 5, 3: 10}),
              pot: IntChip(3))==FloatChip(-2 / 3),
      "test__esperanceB_6");
}

FloatChip globalEquityB({required StrategyB strategyB, required StrategyA strategyA, required IntChip pot})
{
  FloatChip ret = FloatChip(0);
  for (IntPower pwrB = IntPower(MIN_POWER); pwrB <= IntPower(MAX_POWER); pwrB.pp())
  {
    for (IntChip sizingA in strategyA.getSizingList()) {
      ret = ret + esperanceB(pwrB: pwrB, sizingA: sizingA, choixB: strategyB.f(pwrB: pwrB, sizingA: sizingA), strategyA: strategyA, pot: pot) * strategyA.getFreqSizing(sizingA);
      //print("pwrB : ${pwrB._body}  sizingA : ${sizingA._body}");
      //print("debug globalEquityB esperanceB : ${(esperanceB(pwrB: pwrB, sizingA: sizingA, choixB: strategyB.f(pwrB: pwrB, sizingA: sizingA), strategyA: strategyA, pot: pot) * strategyA.getFreqSizing(sizingA))._body}");
    }
  }
  ret = ret * Scalar(1/(1+MAX_POWER-MIN_POWER));
  return ret;
}

void test_globalEquityB()
{
  MIN_POWER = 0;
  MAX_POWER = 1;

  StrategyA strategyA = StrategyA();
  StrategyB strategyB = StrategyB();
  IntChip pot = IntChip(1);

  strategyB.set(pwrB: IntPower(0), sizingA: IntChip(0), choixB: ChoixB.fold);
  strategyB.set(pwrB: IntPower(1), sizingA: IntChip(0), choixB: ChoixB.fold);
  assertTrue(globalEquityB(strategyB: strategyB, strategyA: strategyA, pot: pot) == FloatChip(0), "globalEquityB ff");

  // call with 0
  strategyB.set(pwrB: IntPower(0), sizingA: IntChip(0), choixB: ChoixB.call);
  strategyB.set(pwrB: IntPower(1), sizingA: IntChip(0), choixB: ChoixB.fold);
  assertTrue(globalEquityB(strategyB: strategyB, strategyA: strategyA, pot: pot) == FloatChip(1/4), "globalEquityB cf");

  // call with 1
  strategyB.set(pwrB: IntPower(0), sizingA: IntChip(0), choixB: ChoixB.fold);
  strategyB.set(pwrB: IntPower(1), sizingA: IntChip(0), choixB: ChoixB.call);
  assertTrue(globalEquityB(strategyB: strategyB, strategyA: strategyA, pot: pot) == FloatChip(2/4), "globalEquityB fc");

  // full call
  strategyB.set(pwrB: IntPower(0), sizingA: IntChip(0), choixB: ChoixB.call);
  strategyB.set(pwrB: IntPower(1), sizingA: IntChip(0), choixB: ChoixB.call);
  assertTrue(globalEquityB(strategyB: strategyB, strategyA: strategyA, pot: pot) == FloatChip(3/4), "globalEquityB cc");

}

StrategyB findBestStrategyB({required StrategyA strategyA, required IntChip pot})
{
  StrategyB ret = StrategyB();

  StrategyB iterateStrategyB = StrategyB();

  FloatChip eqB = globalEquityB(strategyB: iterateStrategyB, strategyA: strategyA, pot: pot);

  for (IntPower pwrB = IntPower(MIN_POWER); pwrB <= IntPower(MAX_POWER); pwrB.pp()) 
  {
    for (IntChip sizingA in strategyA.getSizingList())
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
        FloatChip tempEqB = globalEquityB(strategyB: iterateStrategyB, strategyA: strategyA, pot: pot);
        print("treat stratA (pwrB:${pwrB._body} sizingA:${sizingA._body} choixB:${choixB.index}) : \n${iterateStrategyB.toString()}\ntempEqB:${tempEqB._body}\n\n\n");
        if(tempEqB > eqB)
        {
          eqB = FloatChip(tempEqB._body);
          ret.set(pwrB: pwrB, sizingA: sizingA, choixB: choixB);// nope: set alla pths not one
        }
      }
    }
  }
  return ret;
}

class CouplePwrBSizingA
{
  IntPower pwrB;
  IntChip sizA;

  CouplePwrBSizingA(this.pwrB, this.sizA);

  CouplePwrBSizingA.copy(CouplePwrBSizingA couplePwrBSizingA) : pwrB = IntPower.copy(couplePwrBSizingA.pwrB), sizA = IntChip.copy(couplePwrBSizingA.sizA);

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
        CouplePwrBSizingA c = CouplePwrBSizingA(IntPower(iPwrB), IntChip(iSizA));
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

StrategyB _recFind(ListCouplePwrBSizingA P, ListCouplePwrBSizingA A, StrategyB actBestStratB, StrategyA strategyA, IntChip pot)
{
  while(A.list.isNotEmpty)
  {
    CouplePwrBSizingA elem = A.list[0];
    StrategyB strategyB = StrategyB();
    for (CouplePwrBSizingA p in P.list) {
      strategyB.set(pwrB: p.pwrB, sizingA: p.sizA, choixB: ChoixB.call);
    }

    /* treat */
    print("P: $P");
    print("A: $A");
    print("elem: $elem");
    strategyB.set(pwrB: elem.pwrB, sizingA: elem.sizA, choixB: ChoixB.call);
    print("\nStrat : \n" + strategyB.toString() + "\n");
    if( globalEquityB(strategyB: strategyB, strategyA: strategyA, pot: pot) > globalEquityB(strategyB: actBestStratB, strategyA: strategyA, pot: pot))
    {
      print("CHANE\n");
      actBestStratB = strategyB;
    }

    ListCouplePwrBSizingA comP = ListCouplePwrBSizingA.copy(P);
    comP.list.add(elem);
    A.list.removeWhere((a) => (elem.pwrB == a.pwrB) && (elem.sizA == a.sizA));
    ListCouplePwrBSizingA redA = ListCouplePwrBSizingA.copy(A);
    if(redA.list.length > 0)
    {
      actBestStratB = _recFind(comP, redA, actBestStratB, strategyA, pot);
    }
  }
  return actBestStratB;
}

StrategyB find(StrategyA strategyA, IntChip pot) 
{
  StrategyB strategyB = StrategyB();
  ListCouplePwrBSizingA P = ListCouplePwrBSizingA.empty();
  ListCouplePwrBSizingA A = ListCouplePwrBSizingA.universe();

  return _recFind(P, A, strategyB, strategyA, pot);
}

void test_find()
{
  MIN_POWER = 0;
  MAX_POWER = 2;
  MIN_SIZING = 0;
  MAX_SIZING = 1;

  /* full check */
  StrategyA strategyA = StrategyA();
  strategyA.set(pwrA: IntPower(0), sizingA: IntChip(MAX_SIZING));
  strategyA.set(pwrA: IntPower(1), sizingA: IntChip(MAX_SIZING));
  strategyA.set(pwrA: IntPower(2), sizingA: IntChip(MAX_SIZING));
  
  IntChip pot = IntChip(1);

  
  
  print("VOILA : \n\n ${find(strategyA, pot).toString(strategyA: strategyA)}");

}

void test_findBestStrategyB()
{
  MIN_POWER = 0;
  MAX_POWER = 1;
  
  MIN_SIZING = 0;
  MAX_SIZING = 1;

  // full check
  StrategyA strategyA = StrategyA();
  IntChip pot = IntChip(1);

  //StrategyB bestStratB = findBestStrategyB(strategyA: strategyA, pot: pot);
/*   print(""); */
  //print(bestStratB.toString(strategyA : strategyA));
/*   print("\n\n"); */
  strategyA.set(pwrA: IntPower(1), sizingA: IntChip(MAX_SIZING));
  //print("len stra getSizingList = ${strategyA.getSizingList().length}");
  StrategyB bestStratB = findBestStrategyB(strategyA: strategyA, pot: pot);
/*   print("");
  print(bestStratB.toString(strategyA : strategyA)); */


  print(globalEquityB(strategyB: bestStratB, strategyA: strategyA, pot: pot)._body);
  bestStratB.set(pwrB: IntPower(1), sizingA: IntChip(MIN_SIZING), choixB: ChoixB.call);
  print(globalEquityB(strategyB: bestStratB, strategyA: strategyA, pot: pot)._body);
/*   print("dd");
  print(esperanceB(pwrB: IntPower(1), sizingA: IntChip(4), choixB: ChoixB.call, strategyA: strategyA, pot: IntChip(4))._body);
  print(esperanceB(pwrB: IntPower(1), sizingA: IntChip(4), choixB: ChoixB.fold, strategyA: strategyA, pot: IntChip(4))._body); */
}

