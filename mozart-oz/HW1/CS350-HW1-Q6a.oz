declare fun {MapRedefined List Function} %ANSWER 6(a)
	   local ModifiedFunction in
	      fun {ModifiedFunction X Y}
		 {Function X}|Y %Apply function to X , do nothing to Y, join them into a list
	      end
	      {FoldR List ModifiedFunction nil} %leave nil as nil
	   end
	end


fun {Operation X} X*X*X end
{Browse {MapRedefined [1 2 3 4 5 6] Operation}}

