declare fun {Gen N} %Producer
	   local
	      GenFunc
	   in
	      fun {GenFunc M} %returns a function F which in turn returns M#F2 [as described in the question, F2 has identical behaviour to F]
		 fun {$} M#{GenFunc M+1} end
	      end
	      {GenFunc N}
	   end
	end

declare fun {SumList Get Accumulator Limit} %Consumer
	   if Limit>0
	   then
	      local
		 N#F = {Get} %Call the F function of the Producer
	      in
		 {SumList F Accumulator+N Limit-1} %Consumer continues with the next value
	      end
	   else
	      Accumulator
	   end
	end

local
   S
in
   thread S = {SumList {Gen 0} 0 1400000} end %Kickstart the consumer
   {Browse S} %Print the sum
end
