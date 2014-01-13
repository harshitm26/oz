declare proc {NewPort Stream ?Port} %Our NewPort implementation
	   Port = {NewCell Stream}
	end

declare proc{Send Port Message} %Out Send implementation
	   X Temp in
	   Temp = @Port %first store the unbound tail of stream in Temp
	   Port := X %Bind port to another unbound variable
	   Temp = Message|X %Bind the presently unbound tail of stream to Message|X, where X is the new unbound tail from now
	end

declare fun {ListTo N} %Just to generate decreasing sequence of numbers
	   if(N==0) then nil
	   else N|{ListTo N-1}
	   end
	end

local Run Port Stream in
   proc {Run}
	   Port = {NewPort Stream}
	   
	   thread {List.forAll {ListTo 99 } proc {$ X} {Delay 100} {Send Port X} end} end %Producer thread
	   thread {List.forAll Stream proc {$ X} {Browse X} end} end %Consumer thread
   end
   {Run}
end



	      