declare fun {Filter List Predicate} %ANSWER 5(a)
	   case List
	   of nil then nil
	   [] H|T then
	      if {Predicate H} == true
	      then H|{Filter T Predicate} %Include H if H satisfies the predicate
	      else {Filter T Predicate} % otherwise ignore it
	      end
	   end
	end

{Browse {Filter [0 1 2 3 4 5 6 7 8 9] fun {$ X} X mod 3 == 0 end }}

fun {FoldL L Operation Identity} %ANSWER 5(b)
   case L
   of nil then Identity
   [] H|T then
      if T == nil then H 
      else local P={Operation H T.1} in % P = result obtained on applying the operation on first two elements of list L
	      {FoldL P|T.2 Operation Identity} %Recurse with new list being P|rest of the list
	   end
      end
   end
end

{Browse {FoldL [1 2 3 4 5 6 7 8] fun{$ X Y} X-Y end 0}}
	      
	 
      