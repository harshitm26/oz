declare fun {Evaluate Money Limit}
	   if Money < 0 then 0
	   elseif Money ==0 then 1
	   else
	      local A B C D E in
		 if Limit >= 1 then A={Evaluate Money-1 1} else A=0 end
		 if Limit >= 5 then B={Evaluate Money-5 5} else B=0 end
		 if Limit >= 10 then C={Evaluate Money-10 10} else C=0 end
		 if Limit >= 25 then D={Evaluate Money-25 25} else D=0 end
		 if Limit >= 50 then E={Evaluate Money-50 50} else E=0 end
		 A+B+C+D+E
	      end
	   end
	end
{Browse {Evaluate 1 50}}
{Browse {Evaluate 2 50}}
{Browse {Evaluate 3 50}}
{Browse {Evaluate 4 50}}
{Browse {Evaluate 5 50}}
{Browse {Evaluate 6 50}}
{Browse {Evaluate 7 50}}
{Browse {Evaluate 8 50}}
{Browse {Evaluate 9 50}}
{Browse {Evaluate 10 50}}
{Browse {Evaluate 11 50}}
{Browse {Evaluate 12 50}}
{Browse {Evaluate 13 50}}
{Browse {Evaluate 14 50}}
{Browse {Evaluate 15 50}}
{Browse {Evaluate 16 50}}
{Browse {Evaluate 110 50}}

		       
		    
