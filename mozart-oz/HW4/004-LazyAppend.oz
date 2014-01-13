declare fun {Append A B }
	   case A
	   of nil then
	      case B
	      of nil then nil
	      else {ByNeed proc {$ X} X = B end}
	      end
	   [] AH|AT then
	      {ByNeed proc {$ X} X = AH | {Append AT B} end} 
	   end
	end

L = {Append [1 2 3] [4 5 6]}
{Browse 1+L.2.2.2.1}


			   
			    