declare
SemanticStack
{Cell.new nil SemanticStack}

declare
proc {Pop ?Statement ?Environment}
   if @SemanticStack == nil then %Semantic Stack empty
      Statement = nil
      Environment = envrn()
   else
      semstat(Statement Environment) = @SemanticStack.1 %return value in Statement and Environment
      SemanticStack := @SemanticStack.2 %Pop
   end
end

declare
proc {Push Statement Environment} 
   local IsListOfStatements in
      {List.is Statement.1 ?IsListOfStatements}
      if IsListOfStatements == true then %If list of statement is to be pushed, pair each one with the Environment
	 ListOfSemanticStatements = {Map Statement fun {$ S} semstat(S Environment) end} NewSemanticStack in
	 {List.append ListOfSemanticStatements @SemanticStack NewSemanticStack}
	 SemanticStack := NewSemanticStack
      else
	 SemanticStack := semstat(Statement Environment) | @SemanticStack %Single statement paired with environment
      end
   end
end