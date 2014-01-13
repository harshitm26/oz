declare Debug = 1
\insert 'Unify.oz'
\insert 'SemanticStack.oz'
\insert 'Program.oz'
\insert 'TriggerStore.oz'

declare
fun {BuildClosure Procedure Environment} %Returns closure in the format routine|Arguments|ProcedureBody|ContextEnvironment
   local BuildContextEnvironment Free ListOfFreeIdentifiers routine|A|[S] = Procedure in
      fun {ListOfFreeIdentifiers L} %returns list of free identifiers in the program segment L
	 case L
	 of nil then nil
	 [] [localvar ident(X) S] then
	    {List.filter {ListOfFreeIdentifiers S} fun{$ Y} if Y==X then false else true end end} %Remove X from the list of free identifiers in S
	 [] [routine A S] then L Args in
	    Args = {List.map A fun{$ X} case X of ident(Y) then Y else raise invalidArgument(X) end end end } %Stripping off ident() fom A
	    {List.filter {ListOfFreeIdentifiers S} %Removing identifiers that are members of argument list
	     fun{$ Y}
		if {List.member Y Args} == true then false
		else true
		end
	     end
	     ?L}
	    L
	 [] [apply ident(F) Params] then Ret in %Identifiers F and those in Params
	    {List.append [F] {ListOfFreeIdentifiers Params} ?Ret}
	    Ret
	 [] H|T then App in {List.append {ListOfFreeIdentifiers H} {ListOfFreeIdentifiers T} ?App} App
         %[] H#T then {ListOfFreeIdentifiers H}|{ListOfFreeIdentifiers T} According to correction in problem statement, # is not in our language
	 [] ident(Z) then [Z]
	 else nil
	 end
      end
      Free = {ListOfFreeIdentifiers Procedure} %Final list of free identifiers in the passed procedure
      %{Browse Free}
      fun {BuildContextEnvironment F Env} %Converts the list F into a record with label envrn (filters nil elements)
	 case F
	 of nil then envrn() 
	 [] Var|L then
	    if Var == nil then envrn()
	    else CE in
	    {Record.adjoin envrn(Var: Env.Var) {BuildContextEnvironment L Env} ?CE}
	       CE
	    end
	 end
      end
%      {Browse {BuildContextEnvironment Free Environment}}
%               {Browse 'HERE'}
      %Args = {List.map A fun{$ X} case X of ident(Y) then Y else raise invalidArgument(X) end end end }
      %{Browse [routine A S {BuildContextEnvironment Free Environment}]}
      [routine A S {BuildContextEnvironment Free Environment}] %the final closure
   end
end

declare
proc {InterpretNext}
   local Statement Environment in
      if Debug == 1 then SASEntries TSEntries in %To output the sequence of execution states
	 {Browse @SemanticStack}
	 {Dictionary.entries SingleAssignmentStore ?SASEntries}
	 {Browse SASEntries}
	 {Dictionary.entries TriggerStore ?TSEntries}
	 {Browse TSEntries}
      end
      {Pop ?Statement ?Environment} %Pop the Statement on top of the stack
      case Statement
      of nil then {Browse 'Done'} %Stack empty
      [] [nop] then {InterpretNext} %[skip]
      [] [localvar ident(X) S] then %local X in S end
	 AdjoinedEnvironment in
	 {Record.adjoin Environment envrn(X:{AddKeyToSAS}) AdjoinedEnvironment}
	 {Push S AdjoinedEnvironment}
	 {InterpretNext}
      [] [bind Exp1 Exp2] then %X = Y
	 case Exp2
	 of routine|_ then 
	    case Exp1
	    of ident(X) then {BindValueToKeyInSAS Environment.X {BuildClosure Exp2 Environment}} % X = proc {....}....end
	    else raise incompatibleTypes(Exp1 Exp2) end %procedure is not unifiable with anything other than an unbound variable
	    end
	 [] ident(Y) then
	    case Exp1
	    of routine|_ then {BindValueToKeyInSAS Environment.Y {BuildClosure Exp1 Environment}} % proc{...}....end = X
	    else {Unify Exp1 Exp2 Environment} %normal unification
	    end
	 else {Unify Exp1 Exp2 Environment} 
	 end
	 {InterpretNext}
      [] [conditional ident(X) S1 S2] then ValX = {RetrieveFromSAS Environment.X} in %if X == true then S1 else S2 end
	 if  ValX == true then
	    {Push S1 Environment}
	 elseif ValX == false then
	    {Push S2 Environment}
	 else raise identifierNotBoolean(ident(X)) end
	 end
	 {InterpretNext}
      [] [match ident(X) P1 S1 S2] then ValX = {RetrieveFromSAS Environment.X} BuildCaseEnvironment CaseEnvironment in %case X of P1 then S1 else S2
	 fun {BuildCaseEnvironment Pattern}
	    case Pattern
	    of ident(X) then
	       envrn(X: {AddKeyToSAS}) %Add all identifiers to environment
	    [] record|_|Pairs then Environments in %Build environment recursively from feature-field pairs of the record
	       Environments = {Map Pairs.1 fun{$ X} {BuildCaseEnvironment X.2.1} end}
	       %{FoldL Environments fun{$ X Y} local E in {Record.adjoin X Y E} E end end envrn()}
	       {FoldL Environments fun{$ X Y} {Record.adjoin X Y} end envrn()}
	    else envrn()
	    end
	 end
	 {Record.adjoin Environment {BuildCaseEnvironment P1} ?CaseEnvironment}
	 try
	    {Unify P1 ValX CaseEnvironment}
	    {Push S1 CaseEnvironment} %If unification is successful, pattern has been matched
	 catch incompatibleTypes(_ _) then
	    {Push S2 Environment} %Pattern not matched
	 end
	 {InterpretNext}
      [] apply|ident(F)|Params then Func in %{func Y1 Y2 Y3...Yn}
	 Func = {RetrieveFromSAS Environment.F} %Retrieve the closure of F from the environment
	 case Func
	 of routine|Args|S|[CE] then Environments ApplyEnvironment in
	    {List.zip Args Params fun {$ X Y} %Mapping the formal arguments to passed parameters
			     case X
			     of ident(XX) then
				case Y
				of ident(YY) then AddEnv UnifyEnv in
				   AddEnv = envrn(XX:{AddKeyToSAS})
				   {Record.adjoin AddEnv envrn(YY:Environment.YY) ?UnifyEnv}
				   {Unify X Y UnifyEnv} %Binding the unbound X to Y
				   AddEnv %The environment consisting of formal arguments
				else AddEnv UnifyEnv in %Y is of the form record|_ or literal(_)
				   AddEnv = envrn(XX:{AddKeyToSAS})
				   {Record.adjoin AddEnv Environment ?UnifyEnv}
				   {Unify X Y UnifyEnv} %Binding the unbound X to Y
				   AddEnv %The environment consisting of formal arguments
				end
			     else raise invalidArgument(X) end
			     end
			  end ?Environments}
%	    {Browse Environments}
%	    {Browse {FoldL Environments fun{$ X Y} {Record.adjoin X Y} end envrn()}}
	    ApplyEnvironment = {Record.adjoin {FoldL Environments fun{$ X Y} {Record.adjoin X Y} end envrn()} CE} %Adjoining Context Environment, CE with the environment consisting of formal arguments
%	    {Browse CE}
%	    {Browse ApplyEnvironment}
	    {Push S ApplyEnvironment}
	    {InterpretNext}
	 else raise invalidRoutine(Statement) end
	 end
	 %Assignment 4
      [] [byneed [subr ident(P)] ident(X)] then Routine in
	 Routine = {RetrieveFromSAS Environment.P}
	 case Routine 
	 of routine|_ then %if P is actually a routine
	    {AddTriggerToTS trigger(key(Environment.X) subr(Environment.P))} %Add the trigger to the trigger store
	    {InterpretNext}
	 else raise invalidRoutine(P) end
	 end
	 %Assignment 4
      else raise invalidStatement(Statement) end
      end
   end
end
   
declare
proc {Start Prog}
   {Push Prog envrn()} %Push the program statements onto the stack
   {InterpretNext} %Trigger the interpreter
end

{Start Program} %Start the interpretation
