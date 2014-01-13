declare SingleAssignmentStore
{Dictionary.new ?SingleAssignmentStore}

declare NKeys
{Cell.new 0 ?NKeys}

declare
proc {BindValueToKeyInSAS Key Val}
   local CurrentValue = {Dictionary.get SingleAssignmentStore Key} in
      case CurrentValue
      of void then {Dictionary.put SingleAssignmentStore Key Val}
      [] equivalence(X) then {BindValueToKeyInSAS X Val}
      else raise alreadyAssigned(Key Val CurrentValue) end
      end
   end
end

declare
proc {BindRefToKeyInSAS Key RefKey}
   {BindValueToKeyInSAS Key equivalence(RefKey)}
end

declare
fun {AddKeyToSAS}
   NKeys := 1 + @NKeys
   {Dictionary.put SingleAssignmentStore @NKeys void}
   @NKeys
end

declare
fun {RetrieveFromSAS Key}
   local Ret = {Dictionary.get SingleAssignmentStore Key} in
      case Ret
      of equivalence(X) then {RetrieveFromSAS X}
      [] void then equivalence(Key)
      else Ret
      end
   end
end


      