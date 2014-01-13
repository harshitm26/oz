declare fun {Buzz Feed Keywords} %ASNWER 6(b)
	   local NWordInList NWordsInList DiscardSuspicious NotSuspicious NWordsInListOfLists Result MakePair SumListElementWise in
	      fun {NWordInList Word List} %no of "Word"s in the list List
		    case List
		    of nil then 0
		    [] H|T then
		       if H==Word then 1+{NWordInList Word T} %A word found
		       else {NWordInList Word T}
		       end
		    end
	      end
	      fun {NWordsInList Words List} %returns list containing no of each word in the list List
		 case Words
		 of nil then nil
		 [] H|T then {NWordInList H List}|{NWordsInList T List} 
		 end
	      end
	      fun {DiscardSuspicious ListOfLists} %Removes the list (from ListOfLists) containing any element greater than 4
		 case ListOfLists
		 of nil then nil
		 [] H|T then
		    if {NotSuspicious H} then H|{DiscardSuspicious T} %if H doesn't have any element greater than 4, it is not suspicious, include it
		    else {DiscardSuspicious T} %otherwise ignore it
		    end
		 end
	      end
	      fun {NotSuspicious List} %returns true of none of the element of List are greater than 4
		 case List
		 of nil then true
		 [] H|T then
		    if H =< 4 then
		       if {NotSuspicious T} then true %if H<=4 and the rest of the list contains no element greater than 4, then the List is not suspicious
		       else false
		       end
		    else false
		    end
		 end
	      end
	      fun {SumListElementWise A B} %returns a list containing element wise sum of the elements of A and B
		 case A
		 of nil then
		    case B
		    of nil then nil
		    [] HB|TB then HB|{SumListElementWise A TB}
		    end
		 [] HA|TA then
		    case B
		    of nil then HA|{SumListElementWise TA B}
		    [] HB|TB then HA+HB|{SumListElementWise TA TB}
		    end
		 end
	      end
    
	      fun {NWordsInListOfLists Words ListOfLists} %returns a list of lists containing the no of each word in each list of ListOfLists
		 {Map ListOfLists fun {$ List} {NWordsInList Words List} end}
	      end
	      Result = {FoldR {DiscardSuspicious {NWordsInListOfLists Keywords Feed}} SumListElementWise nil} %contains the final calculation result
	      fun {MakePair A B} [A B] end %pairs each result with its label/word
	      {List.zip Keywords Result MakePair}

	   end
	end

{Browse {Buzz [[spiderman rocks] [gow is so so] [batman takes a hit] [colorless green ideas sleep furiously]] [spiderman batman wasseypur]}}

{Browse {Buzz [[jeetesh mangwani] [jeetesh agrawal] [harshit maheshwari] [vinit kataria]] [jeetesh harshit kataria agrawal pandey]}}

{Browse {Buzz [[batman batman batman batman batman wasseypur] [spiderman batman] [wasseypur spiderman] [spiderman spiderman spiderman spiderman spiderman batman]] [spiderman batman wasseypur]}}
