declare fun {Zip A B} %merges sorted lists A and B into a new sorted list
	   case A
	   of nil then B %A has no more elements
	   [] HA|TA then
	      case B
	      of nil then A %B has no more elements
	      [] HB|TB then %return smaller element followed by the result of merging rest of the lists
		 if HA < HB then HA | {Zip TA B} 
		 else HB | {Zip A TB}
		 end
	      end
	   end
	end
{Browse {Zip [1 2 3 4 5 6 7 ] [8 9]}}
{Browse {Zip [1 2 3 4 ] [1 2 5]}}
{Browse {Zip [1 2 3 6 7 ] [4 5 ]}}
{Browse {Zip [1 2 3 4 5 6 7 ] [~5 ~4 ~3 ~2 ~1 0 8 9]}}

