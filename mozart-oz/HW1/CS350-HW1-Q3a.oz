declare fun{Equals L M}
	   if L == M then true
	   else false
	   end
	end

%A more detailed and non-trivial function to do the same is defined below

declare fun {EqualsDetailed L M} % returns true of L and M are structuray equal
      local C in
	 case L
	 of nil then
	    case M of nil then C= true %Both L and M are nil
	    else C= false %L is nil, M is not nil
	    end
	 [] HL|TL then
	    case M
	    of nil then C = false %L is not nil, M is nil
	    [] HM|TM then %Both L and M are not nil
	       if {Equals HM HL} == true then
		  if {Equals TM TL} == true then
		     C = true %Both non-nil lists are equal
		  else C = false
		  end
	       else C = false
	       end
	    else C = false
	    end
	 else
%	    if {IsLiteral L} then %We may check if L and M are literals before comparing them
%	       if {IsLiteral M} then
		  if L==M then %L and M are literals that are equal to eachother
		     C = true
		  else C = false
		  end
%	       else C = false
%	       end
%	    else C = false
%	    end
	 end
      C	 
      end

   end
{Browse {Equals [a b c] [a j c]}}
{Browse {Equals [1 2 3 4 ] [1 2 3 4]}}

{Browse {EqualsDetailed [a b c] [a j c]}}
{Browse {EqualsDetailed [1 2 3 4 ] [1 2 3 4]}}
