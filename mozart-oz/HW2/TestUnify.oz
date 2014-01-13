% Tests for the unification function. We use the kernel language interpreter to
% test.

\insert 'KLInterpreter.oz'

%% Be noisy, but only about unify statements
VerboseUnifyStatements = true

%% Program 1 given in the assignment, translated to Loz.  This has 4
%% identifiers, so it corresponds to SAS keys 0-3.
{Browse '--- PROGRAM 1 ---'}
{KLInterpret
 [localvar ident(x)
  [localvar ident(y)
   [localvar ident(z)
    [localvar ident(w)
     [[unify ident(x) [record literal(person) [literal(name) ident(y)]
                       [literal(age) ident(w)]]]
      [unify ident(z) [record literal(person) [literal(name) literal(hari)]
                       [literal(age) literal(25)]]]
      [unify ident(x) ident(z)]]]]]]
}

%% Program 2 given in the assignment, translated to Loz. 6 identifiers
%% this time, so SAS 4-9.
{Browse '--- PROGRAM 2 ---'}
{KLInterpret
 [localvar ident(x)
  [localvar ident(y)
   [localvar ident(z)
    [localvar ident(w)
     [localvar ident(u)
      [localvar ident(v)
       [[unify ident(x) [record literal(person) [literal(name) ident(y)]
                         [literal(age) ident(w)]]]
        [unify ident(z) [record literal(person) [literal(name) ident(u)]
                         [literal(age) ident(v)]]]
        [unify ident(x) ident(z)]
        [unify ident(y) literal(rahim)]
        [unify ident(v) literal(30)]]]]]]]]
}

%% Program 3. 6 more identifiers, so 10-15. We should raise an
%% exception with the last statement, so test that.
{Browse '--- PROGRAM 3 ---'}
try
  {KLInterpret
   [localvar ident(x)
    [localvar ident(y)
     [localvar ident(z)
      [localvar ident(w)
       [localvar ident(u)
        [localvar ident(v)
         [[unify ident(x) [record literal(person) [literal(name) ident(y)]
                           [literal(age) ident(w)]]]
          [unify ident(z) [record literal(person) [literal(name) ident(u)]
                           [literal(age) ident(v)]]]
          [unify ident(x) ident(z)]
          [unify ident(y) literal(rahim)]
          [unify ident(v) literal(30)]
          %% We should raise an exception with the following statement
          [unify ident(w) literal(25)]]]]]]]]
  }
  {Raise testFailed}
catch incompatibleTypes(literal(30) literal(25)) then
  %% Coming here means that we passed the test
  skip
end

%% Program 4. 8 identifiers, so 16-23.
{Browse '--- PROGRAM 4 ---'}
{KLInterpret
 [localvar ident(a)
  [localvar ident(b)
   [localvar ident(x)
    [localvar ident(y)
     [localvar ident(z)
      [localvar ident(w)
       [localvar ident(u)
        [localvar ident(v)
         [[unify ident(x) [record literal(person) [literal(name) ident(y)]
                           [literal(age) ident(w)]]]
          [unify ident(z) [record literal(person) [literal(name) ident(a)]
                           [literal(age) ident(b)]]]
          [unify ident(x) ident(z)]
          [unify ident(y) literal(rahim)]
          [unify ident(v) literal(30)]
          [unify ident(w) literal(25)]]]]]]]]]]
}

%% Program 4, with the modification made as suggested (to test
%% cycles). 8 identifiers, so 24-31.
{Browse '--- PROGRAM 4 WITH MODIFICATIONS ---'}
{KLInterpret
 [localvar ident(a)
  [localvar ident(b)
   [localvar ident(x)
    [localvar ident(y)
     [localvar ident(z)
      [localvar ident(w)
       [localvar ident(u)
        [localvar ident(v)
         [[unify ident(x) [record literal(person) [literal(name) ident(y)]
                           [literal(age) ident(w)]]]
          [unify ident(z) [record literal(person) [literal(name) ident(a)]
                           [literal(age) ident(b)]]]
          [unify ident(x) ident(z)]
          [unify ident(y) literal(rahim)]
          [unify ident(v) [record literal(age) [literal(years) ident(u)]
                           [literal(months) ident(v)]]]
          [unify ident(w) literal(25)]]]]]]]]]]
}
