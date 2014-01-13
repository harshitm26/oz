declare S  in
S=[1 5 10 25 50]

%Returns the CoinSize - Kth denomination value
declare
fun {Kth L K N}
   case L
   of nil then 0
   else if K==0 then N-L.1
	else {Kth L.2 K-1 N}
	end
   end
end

%Recursively computes the number of distinct coin combinations possible
 fun {Coin N M}
  if  N==0 then 1
  else if N<0 then 0
       else if M=<0  andthen  N>=1 then 0
             %The recursive defintion of number of distinct possible combinations
  	     else {Coin N M-1}+{Coin {Kth S M-1 N} M}
	     end
	end
  end
 end
 {Browse 'Number of distinct possible changes is '}
 {Browse {Coin 110 5}}
 