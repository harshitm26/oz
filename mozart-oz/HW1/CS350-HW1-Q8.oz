declare fun{Foo Count}
	   local RandomBitGenerator L Sum in
	      fun lazy {RandomBitGenerator} %returns infinite random list of 0s and 1s
		 {OS.rand} mod 2 | {RandomBitGenerator}
	      end
	      fun {Sum List N} %returns the sum of first N elements of List
		 case List
		 of nil then 0
		 [] H|T then
		    if N==0 then 0
		    else H+{Sum T N-1}
		    end
		 end
	      end
	      {Browse L}

	      L = thread {RandomBitGenerator} end %thread generating random bits
	      thread {IntToFloat {Sum L Count}}/{IntToFloat Count} end %thread calculating the average of first Count bits

	   end
	end

%The following calls return one after the other as soon as the Count no. of bits become available

{Browse {Foo 1}} 
{Browse {Foo 10}}
{Browse {Foo 100}}
{Browse {Foo 200}}
{Browse {Foo 300}}
{Browse {Foo 400}}
{Browse {Foo 500}}
{Browse {Foo 600}}
{Browse {Foo 700}}