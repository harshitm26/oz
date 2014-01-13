declare fun {Fib N} %wrapper function
	   local FibAux in
	      fun {FibAux K Previous} %The core tail-recursive function
		 local  M = Previous.1 + Previous.2.1|Previous in %M= sum of the last two fib nos
		    if K==1 then M
		    else {FibAux K-1 M}
		    end		 
		 end
	      end
	      if N == 0 then nil
	      elseif N == 1 then [0]
	      elseif N == 2 then [1 0]
	      else {FibAux N-2 [1 0]}
	      end
	   end
	end

{Browse {Fib 1}}
{Browse {Fib 2}}
{Browse {Fib 3}}
{Browse {Fib 4}}
{Browse {Fib 5}}
{Browse {Fib 6}}
{Browse {Fib 7}}
{Browse {Fib 8}}
{Browse {Fib 9}}
{Browse {Fib 10}}
{Browse {Fib 11}}
{Browse {Fib 12}}
{Browse {Fib 13}}
{Browse {Fib 14}}



