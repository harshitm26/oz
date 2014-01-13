%% A kernel interpreter for statements equivalent to the kernel
%% language in Oz.

%% This make-believe language (let's call it Loz) is very Lisp-like in
%% that it uses nested lists for both code and data (i.e. s-expressions).
%% A statement is defined as follows:
%%
%% statement := [donothing]
%%              [statement statement]
%%              [localvar identifier [statement]]
%%              [unify expression expression]
%%              [ifcheck condition [statement (if true)] [statement (if false)]]
%%              [casecheck expression pattern [statement (if matches)] [statement (if doesn't match)]]
%%              [defproc identifier [identifiers] [statement]]
%%              [callproc identifier [identifiers]]
%%
%% identifiers := identifier
%%                identifier identifiers
%%
%% identifier := ident(ozLiteral)
%%
%% expression := identifier
%%               value
%%
%% value := lozliteral
%%          [defrecord label [feature-pairs]]
%%
%% lozliteral := literal(ozLiteral)
%%
%% feature-pairs := feature-pair
%%                  feature-pair feature-pairs
%%
%% feature-pair := [lozliteral expression]
%%
%% label := lozliteral
%%
%% We reserve a few keywords here, which are donothing, localvar,
%% unify, ident, ifcheck, casecheck, defproc, callproc, literal, and
%% defrecord.

\insert 'Unify.oz'

declare

%% Whether to be noisy when unify statements are executed
VerboseUnifyStatements

%% Our semantic stack is simply a list of pairs. The first element of
%% the list is the top of the stack.
KLSemanticStack
{NewCell nil KLSemanticStack}

proc {StackPush Statement Environment}
  KLSemanticStack := {List.append [statement(Statement Environment)]
                      @KLSemanticStack}
end

proc {StackPop ?Statement ?Environment}
  case @KLSemanticStack
  of nil then
    Statement = nil
    Environment = env()
  else
    statement(Statement Environment) = (@KLSemanticStack).1
    KLSemanticStack := (@KLSemanticStack).2
  end
end

%% Looks at a statement or expression for identifiers, and returns a
%% suitable environment.
fun {ScanForIdentifiers Statement}
  IdentDict
  {Dictionary.new IdentDict}

  proc {ScanAndAddToDictionary Statement}
    case Statement
    of record|_|FeaturePairs then
      %% We do not scan for the label or feature names
      {ScanAndAddToDictionary {List.map FeaturePairs fun {$ X} X.2.1 end}}
    [] Head|Tail then
      {ScanAndAddToDictionary Head}
      {ScanAndAddToDictionary Tail}
    [] ident(X) then
      %% Check if X is already in the dictionary
      if {Dictionary.condGet IdentDict X nil} == nil then
        {Dictionary.put IdentDict X {AddKeyToSAS}}
      end
    else
      skip
    end
  end
in
  {ScanAndAddToDictionary Statement}
  {Dictionary.toRecord env IdentDict}
end

proc {KLInterpret Statement}
  {StackPush Statement env()}
  {KLInterpretStack}
end

proc {KLInterpretStack}
  Statement Environment
in
  {StackPop Statement Environment}
  if {Not VerboseUnifyStatements} then
    {Browse Statement}
  end

  case Statement
  of nil then
    %% We've emptied the stack. Yay!
    skip

  [] (Statement1|Statement1Rest)|Statements then
    %% We can get nil if we're passed in a double nested list with a
    %% single statement (eg [[donothing]])
    if Statements \= nil then
      {StackPush Statements Environment}
    end
    {StackPush (Statement1|Statement1Rest) Environment}
    {KLInterpretStack}

  [] [donothing] then
    %% donothing. Equivalent to |skip| in Oz.
    skip
    {KLInterpretStack}

  [] [localvar ident(X) Statement] then
    %% local <X> in <S> end
    {StackPush Statement {Record.adjoin Environment
                          env(X: {AddKeyToSAS})}}
    {KLInterpretStack}

  [] [defproc ident(ProcName) BoundVarList ProcStatement] then
    %% [defproc <procname> <list of bound variables> <statement>]
    %% Equivalent to |proc {<procname> <list of bound vars> <statement> end|
    %% Since we aren't worried about GC right now, we'll be aggressive
    %% and say that the entire environment minus whatever identifies
    %% bound variables was captured. Remember that ProcName has
    %% already been introduced.
    {BindValueToKeyInSAS Environment.ProcName
     defproc(ProcStatement BoundVarList
             {Record.subtractList Environment
              {List.map BoundVarList fun{$ X} X.1 end}})}

    {KLInterpretStack}

  [] [callproc ident(ProcName) BoundVars] then
    %% Procedure call. We actually don't need to assign new keys in
    %% the SAS -- we can simply use the keys in the current env!
    %% Again if something hasn't been introduced yet, it's an error,
    %% so we'll throw.
    Procedure
  in
    Procedure = {RetrieveFromSAS Environment.ProcName}
    case Procedure
    of defproc(ProcStatement ProcBoundVarList ProcEnvironment) then
      %% The number of elements in ProcBoundVarList and BoundVars
      %% needs to be the same
      NumParams
    in
      NumParams = {List.length BoundVars}
      if NumParams == {List.length ProcBoundVarList} then
        %% Create a list, with each element (item in proc bound var
        %% list) # (key in env corresponding to callproc bound var
        %% list)
        ListToAddToEnv
      in
        ListToAddToEnv = {List.zip ProcBoundVarList BoundVars
                          fun {$ X Y}
                            X.1 # Environment.(Y.1)
                          end}
        {StackPush ProcStatement {Record.adjoin ProcEnvironment
                                  {List.toRecord env ListToAddToEnv}}}
      else
        %% Raise an exception, since we have too few or too many
        %% parameters
        {Exception.raiseError lengthIncorrect}
      end
    else
      {Raise identifierIsNotProcedure(Statement ProcName)}
    end
    %% The else means that Procedure is not actually a procedure, so
    %% we don't handle it and let the exception pass

    {KLInterpretStack}
  [] [unify Expression1 Expression2] then
    %% Unification. Pass it over to the Unify function.
    {Unify Expression1 Expression2 Environment}

    if VerboseUnifyStatements then
      %% Print out the statement, the environment and the SAS
      {Browse Statement}
      {Browse Environment}
      {Browse {Dictionary.toRecord sas SingleAssignmentStore}}
    end

    {KLInterpretStack}
  [] [ifcheck Identifier TrueStatement FalseStatement] then
    %% If check. Check if the identifier is literal(t) or literal(f).
    case {RetrieveFromSAS Environment.(Identifier.1)}
    of literal(t) then
      {StackPush TrueStatement Environment}
    [] literal(f) then
      {StackPush FalseStatement Environment}
    else
      {Raise identifierNotBoolean(Statement Identifier)}
    end

    {KLInterpretStack}
  [] [casecheck Expression Pattern MatchedStatement ElseStatement] then
    %% Case. Pattern may have some identifiers in it, so scan Pattern
    %% for identifiers and add them to the environment we're going to
    %% use if we matched.
    MatchingEnv = {Record.adjoin Environment {ScanForIdentifiers Pattern}}
  in
    try
      {Unify Expression Pattern MatchingEnv}
      {StackPush MatchedStatement MatchingEnv}
    catch incompatibleTypes(_ _) then
      %% This means that the match failed
      {StackPush ElseStatement Environment}
    end

    {KLInterpretStack}
  else
    {Raise syntaxError(Statement)}
end
end
