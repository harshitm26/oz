declare TriggerStore
{Dictionary.new ?TriggerStore}

declare NTriggers
{Cell.new 0 ?NTriggers}

declare
proc {AddTriggerToTS T}
   NTriggers := 1 + @NTriggers
   {Dictionary.put TriggerStore @NTriggers T}
end
