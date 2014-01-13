declare fun {Pow X Y} % returns X^Y
	   if Y == 0 then 1.0
	   else X*{Pow X Y-1}
	   end
	end

fun {Fact N} % returns N!
   if N==0 then 1
   else N*{Fact N-1}
   end
end

fun {Exp Z} %returns e^Z ANSWER  4(a)
   local ExpAux Y in
      fun lazy {ExpAux X I} % returns (x^i)/(i!) as an infinite list
	 {Pow X I}/{ IntToFloat {Fact I}} | {ExpAux X I+1} 
      end
      if {IsInt Z} then Y = {IntToFloat Z} else Y = Z end % convert integer argument to float
      {ExpAux Y 0}
   end
end

fun {Take L K} % returns first K elements of list L
   case L
   of nil then nil
   else if K == 0 then nil else L.1|{Take L.2 K-1} end
   end
end

fun {Approx X N} % ANSWER 4(b)
   {FoldR {Take {Exp X} N} fun{$ X Y} X+Y end 0.0}
end

fun {Mod A} % returns the absolute value of A
   if A < 0.0 then ~A
   else A
   end
end


fun {Within L Epsilon} %returns the second element on encountering two elements within epsilon of eachother in list L ANSWER 4(c)
   local WithinAux in
      fun {WithinAux L Previous} %Previous: the previous element as observerd by the caller
	 case L
	 of nil then nil
	 [] H|T then
	    if {Mod Previous-H} =< Epsilon  andthen Previous \= H then H %comparing two consecutive numbers Previous and H
	    else {WithinAux T H}
	    end
	 end
      end
      case L
      of nil then nil
      [] H|T then
	 {WithinAux T H} %Initiating the computation
      end
   end
end

fun {ExpLimitedError X Epsilon} %ANSWER 4(c)
   local L={Exp X} Till in
      Till = {Within L Epsilon} %the element till which we want to sum the exponential series
      local GoTill in
	 fun {GoTill L Till}
	    case L of nil then 0
	    [] H|T then
	       if H==Till then H %the last element to add
	       else H+{GoTill T Till}
	       end
	    end
	 end
	 {GoTill L Till}
      end
   end
end


{Browse {Take {Exp 1.3} 20}}
{Browse {Approx 1.3 10}}
{Browse {Within {Exp 1.3} 0.000000001}}
{Browse {ExpLimitedError 1.3 0.000000001}}


{Browse {Take {Exp 4} 20}}
{Browse {Approx 4 10}}
{Browse {Within {Exp 4} 0.000000001}}
{Browse {ExpLimitedError 4 0.000000001}}
