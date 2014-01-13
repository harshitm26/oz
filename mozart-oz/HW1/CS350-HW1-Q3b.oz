declare fun {Filter L} %filters multiple consecutive occurrences of literals from list L
	   local Process D in
	      fun {Process List Literal} % Literal: the symbol observed by the caller
		 case List
		 of nil then List %nothing to do on a nil
		 [] H|T then
		    if H == Literal then {Process T Literal} %if head of list is the same as the literal last observed, ignore it and process rest of the list
		    else H|{Process T H} %otherwise return head attached with the result of processing rest of the list
		    end
		 end
	      end
	      if L.1 == a then D = b else D = a end % to start the recursion
	      {Process L D}
	   end
	end
{Browse {Filter [the the springs are '\n' '\n' loose]}}
{Browse {Filter [jeetesh jeetesh jeetesh mangwani mangwani mangwani 'a' 'a' a 'b' 'b' 'c' c true 'true']}}
{Browse {Filter [harshit harshit harshit maheshwari 'a' 'a' a 'b' 'b' 'c' c true 'true']}}
