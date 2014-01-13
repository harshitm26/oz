declare proc {Break}
	   raise breakException end %Utilising "Exceptions" to pass the message of Break operation
	end

declare ForT
proc {ForT CurrentValue Limit LoopBodyProcedure}
   local
      RunInThread
   in
      proc {RunInThread Proc ParentId ?Halt} %If {Break} was called, Halt would be bound
	 thread
	    try
	       {Proc CurrentValue}
	    catch breakException
	    then Halt=unit %If breakException was raise, bind Halt
	    end
	    {Thread.resume ParentId}
	 end
      end
      if CurrentValue < Limit
      then Break in
	 {RunInThread LoopBodyProcedure {Thread.this} Break} 
% Run loop body in a thread, passing the
% parent's id
	 {Thread.suspend {Thread.this}} % wait for Loop body to terminate
	 if {IsDet Break} == false %i.e. {Break} was not called
	 then {ForT CurrentValue+1 Limit LoopBodyProcedure}
	 end
      end
   end
end



{ForT 0 10 proc{$ X} if X==4 then {Break} end {Browse X} end}
   