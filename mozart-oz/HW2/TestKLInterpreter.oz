%% Tests for the kernel interpreter.

\insert 'KLInterpreter.oz'

VerboseUnifyStatements = false

%% A test of cycles.
{KLInterpret
 [localvar ident(foo)
  [localvar ident(bar)
   [[unify ident(foo) [record literal(person) [literal(name) ident(foo)]]]
    [unify ident(bar) [record literal(person) [literal(name) ident(bar)]]]
    [unify ident(foo) ident(bar)]]]]
}

%% Another test of cycles.
{KLInterpret
 [localvar ident(foo)
  [localvar ident(bar)
   [[unify ident(foo) [record literal(person) [literal(name) ident(bar)]]]
    [unify ident(bar) [record literal(person) [literal(name) ident(foo)]]]
    [unify ident(foo) ident(bar)]]]]
}

%% Test of procedures, with a closure.
try
  {KLInterpret
   [localvar ident(foo)
    [localvar ident(bar)
     [localvar ident(quux)
      [[defproc ident(bar) [ident(baz)]
        [unify [record literal(person) [literal(age) ident(foo)]] ident(baz)]]
       [callproc ident(bar) [ident(quux)]]
       [unify [record literal(person) [literal(age) literal(40)]] ident(quux)]
       %% We'll check whether foo has been assigned the value by
       %% raising an exception here
       [unify literal(42) ident(foo)]]]]]
  }
  {Raise testFailed}
catch incompatibleTypes(literal(42) literal(40)) then
  %% Coming here means that we passed the test
  skip
end

%% Test a successful case match.
{KLInterpret
 [localvar ident(foo)
  [localvar ident(result)
   [[unify ident(foo) [record literal(bar)
                       [literal(baz) literal(42)]
                       [literal(quux) literal(314)]]]
    [casecheck ident(foo) [record literal(bar)
                           [literal(baz) ident(fortytwo)]
                           [literal(quux) ident(pitimes100)]]
     [unify ident(result) ident(fortytwo)] %% if matched
     [unify ident(result) literal(314)]] %% if not matched
    %% This will raise an exception if result is not 42
    [unify ident(result) literal(42)]
    [donothing]]]]
}

%% Test a failing case match.
{KLInterpret
 [localvar ident(foo)
  [localvar ident(bar)
   [localvar ident(baz)
    [[unify ident(foo) ident(bar)]
     [unify literal(20) ident(bar)]
     [casecheck ident(foo) literal(21)
      [unify ident(baz) literal(t)]
      [unify ident(baz) literal(f)]]
     %% Check
     [unify ident(baz) literal(f)]
     [donothing]]]]]
}

%% Test a successful if.
{KLInterpret
 [localvar ident(foo)
  [localvar ident(result)
   [[unify ident(foo) literal(t)]
    [ifcheck ident(foo)
     [unify ident(result) literal(t)]
     [unify ident(result) literal(f)]]
    %% Check
    [unify ident(result) literal(t)]]]]
}

%% Test a failing if.
{KLInterpret
 [localvar ident(foo)
  [localvar ident(result)
   [[unify ident(foo) literal(f)]
    [ifcheck ident(foo)
     [unify ident(result) literal(t)]
     [unify ident(result) literal(f)]]
    %% Check
    [unify ident(result) literal(f)]]]]
}

%% One more case check, this time with feature names as identifiers.
{KLInterpret
 [localvar ident(foo)
  [localvar ident(bar)
   [localvar ident(baz)
    [localvar ident(result)
     [[unify ident(foo) literal(person)]
      [unify ident(bar) literal(age)]
      [unify ident(baz) [record literal(person) [literal(age) literal(25)]]]
      [casecheck ident(baz) [record ident(foo) [ident(bar) ident(quux)]]
       [unify ident(result) ident(quux)]
       [unify ident(result) literal(f)]]
      %% Check
      [unify ident(result) literal(25)]]]]]]
}
