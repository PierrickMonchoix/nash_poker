class Scalar {
  double _body;

  Scalar(this._body);
  
  Scalar operator +(Scalar other)
  {
    Scalar ret = Scalar(0);
    ret._body = _body + other._body;
    return ret;
  }

  Scalar operator -(Scalar other)
  {
    Scalar ret = Scalar(0);
    ret._body = _body - other._body;
    return ret;
  }

  Scalar operator *(Scalar other)
  {
    Scalar ret = Scalar(0);
    ret._body = _body * other._body;
    return ret;
  }

  Scalar operator /(Scalar other)
  {
    Scalar ret = Scalar(0);
    ret._body = _body / other._body;
    return ret;
  }

  bool operator >(Scalar other)
  {
    return _body > other._body;
  }

  bool operator <(Scalar other)
  {
    return _body < other._body;
  }
}

class FloatChip {
  double _body;

  FloatChip(this._body);
  
  FloatChip operator +(FloatChip other)
  {
    FloatChip ret = FloatChip(0);
    ret._body = _body + other._body;
    return ret;
  }

  FloatChip operator -(FloatChip other)
  {
    FloatChip ret = FloatChip(0);
    ret._body = _body - other._body;
    return ret;
  }

  FloatChip operator *(covariant Scalar Scalar)
  {
    FloatChip ret = FloatChip(0);
    ret._body = _body * Scalar._body;
    return ret;
  }

  bool operator >(FloatChip other)
  {
    return _body > other._body;
  }

  bool operator <(FloatChip other)
  {
    return _body < other._body;
  }
}

class IntChip {
  int _body;

  IntChip(this._body);
  
  IntChip operator +(IntChip other)
  {
    IntChip ret = IntChip(0);
    ret._body = _body + other._body;
    return ret;
  }

  // plus equal (++)
  void pe(IntChip other)
  {
    _body += other._body;
  }

  // plus plus (++)
  void pp()
  {
    _body ++;
  }

  IntChip operator -(IntChip other)
  {
    IntChip ret = IntChip(0);
    ret._body = _body - other._body;
    return ret;
  }

  FloatChip operator *(covariant Scalar Scalar)
  {
    FloatChip ret = FloatChip(0);
    ret._body = _body * Scalar._body;
    return ret;
  }

  bool operator >(IntChip other)
  {
    return _body > other._body;
  }

  bool operator <(IntChip other)
  {
    return _body < other._body;
  }

  bool operator >=(IntChip other)
  {
    return _body >= other._body;
  }

  bool operator <=(IntChip other)
  {
    return _body <= other._body;
  }

  bool operator ==(covariant IntChip other)
  {
    return _body == other._body;
  }
}

class FloatStrength {
  double _body;

  FloatStrength(this._body);
  
  FloatStrength operator +(FloatStrength other)
  {
    FloatStrength ret = FloatStrength(0);
    ret._body = _body + other._body;
    return ret;
  }

  FloatStrength operator -(FloatStrength other)
  {
    FloatStrength ret = FloatStrength(0);
    ret._body = _body - other._body;
    return ret;
  }

  FloatStrength operator *(covariant Scalar Scalar)
  {
    FloatStrength ret = FloatStrength(0);
    ret._body = _body * Scalar._body;
    return ret;
  }

  bool operator >(FloatStrength other)
  {
    return _body > other._body;
  }

  bool operator <(FloatStrength other)
  {
    return _body < other._body;
  }
}

class IntStrength {
  int _body;

  IntStrength(this._body);
  
  IntStrength operator +(IntStrength other)
  {
    IntStrength ret = IntStrength(0);
    ret._body = _body + other._body;
    return ret;
  }

  // plus equal (++)
  void pe(IntStrength other)
  {
    _body += other._body;
  }

  // plus plus (++)
  void pp()
  {
    _body ++;
  }

  IntStrength operator -(IntStrength other)
  {
    IntStrength ret = IntStrength(0);
    ret._body = _body - other._body;
    return ret;
  }

  FloatStrength operator *(covariant Scalar Scalar)
  {
    FloatStrength ret = FloatStrength(0);
    ret._body = _body * Scalar._body;
    return ret;
  }

  bool operator >(IntStrength other)
  {
    return _body > other._body;
  }

  bool operator <(IntStrength other)
  {
    return _body < other._body;
  }

  bool operator >=(IntStrength other)
  {
    return _body >= other._body;
  }

  bool operator <=(IntStrength other)
  {
    return _body <= other._body;
  }

  bool operator ==(covariant IntStrength other)
  {
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
  print("\n~~~~~~~~~~~~~~~~~~~~");
}

final int MIN_STRENGTH = 0;
final int MAX_STRENGTH = 2;

int MIN_SIZING = 0;
int MAX_SIZING = 10;


enum ChoixB {fold, call}

typedef Range = List<IntStrength>;
typedef Winrate = double;

Winrate winrateDef(IntStrength strengthDef, Range rangeAtk)
{
  Winrate ret = 0.0;
  for (IntStrength element in rangeAtk) {
    if(strengthDef >= element)
    {
      ret += 1;
    }
  }
  ret = ret / rangeAtk.length;
  return ret;
}

class StrategyA {
  //strA -> sizingA
  Map<int, int> _map = {};

  StrategyA() {
    for (IntStrength strA = IntStrength(MIN_STRENGTH); strA <= IntStrength(MAX_STRENGTH); strA.pp()) {
      _map[strA._body] = IntChip(0)._body;
    }
  }

  void set({required IntStrength strA, required IntChip sizingA}) {
    _map[strA._body] = sizingA._body;
  }

  IntChip f({required IntStrength strA}) {
    return IntChip(_map[strA._body]!);
  }

  Range getRange({required IntChip sizingA})
  {
    Range ret = [];
    _map.forEach((key, value) 
    {
      if(value == sizingA._body)
      {
        ret.add(IntStrength(key));
      }
    });
    return ret;
  }
}

void test__StrategyA() {
  StrategyA strategyA = StrategyA();
  strategyA.set(strA: IntStrength(0), sizingA: IntChip(0));
  strategyA.set(strA: IntStrength(1), sizingA: IntChip(10));
  assertTrue(strategyA.f(strA:IntStrength(0)) == IntChip(0), "strategyA.f(strA:IntStrength(0)) == IntChip(0)");
  assertTrue(strategyA.f(strA:IntStrength(1)) == IntChip(10), "strategyA.f(strA:IntStrength(1)) == IntChip(10)");
  assertTrue((strategyA.getRange(sizingA : IntChip(10))[0] == IntStrength(1)) && (strategyA.getRange(sizingA : IntChip(10)).length == 1), "(strategyA.getRange(sizingA : IntChip(10))[0] == IntStrength(1)) && (strategyA.getRange(sizingA : IntChip(10)).length == 1)");
}

class StrategyB {
  // str -> chip -> choix
  Map<int,Map<int,int>> _map = {};

  StrategyB() {
    for (IntStrength strB = IntStrength(MIN_STRENGTH); strB <= IntStrength(MAX_STRENGTH); strB.pp()) {
      _map[strB._body] = {};
      for (IntChip sizingA = IntChip(MIN_SIZING); sizingA <= IntChip(MAX_SIZING); sizingA.pp()) {
        _map[strB._body]![sizingA._body] = ChoixB.fold.index;
      }
    }
  }

  void set({required IntStrength strB, required IntChip sizingA, required ChoixB choixB}) {
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
  assertTrue(strategyB.f(strB: IntStrength(0), sizingA: IntChip(0)) == ChoixB.call, "strategyB.f(strB: IntStrength(0), sizingA: IntChip(0)) == ChoixB.call");
  assertTrue(strategyB.f(strB: IntStrength(1), sizingA: IntChip(2)) == ChoixB.fold, "strategyB.f(strB: IntStrength(1), sizingA: IntChip(2)) == ChoixB.fold");
}

/* typedef Esperance = double;

typedef Pot = int; //TODO : créer un unique type money pour add siteinfg et pot

Esperance esperanceB(Strength strB, SizingA sizingA, ChoixB choixB, StrategyA strategyA, Pot pot) // TODO : tester ca
{
  Esperance ret = 0.0;
  if(choixB == ChoixB.call)
  {
    ret = winrateDef(strB, strategyA.getRange(sizingA: sizingA))*(pot + sizingA) + (1 - winrateDef(strB, strategyA.getRange(sizingA: sizingA)))*(-sizingA);
  }
  else //fold
  {
    ret = 0.0;
  }
  return ret;
} //  TODO :  faire la moyenne apres plutot que le total ca aidera a visualiser */