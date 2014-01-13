declare proc {Choose List}
	   local
	      ChooseAux
	      ReceiveFeedback
	      Stream
	      GreenSignal %To kick start all threads; It is upto the scheduler on which thread is run [Non-determinism]
	      Port = {NewPort Stream} %To receive messages containing Boolean values [this is needed to figure out whether to raise missingClause exception]
	      AtleastOneTrue
	   in 
	      proc {ChooseAux L N}
		 {Browse N}
		 case L
		 of nil then %all threads spawned
		    thread {ReceiveFeedback Stream N} end %start the feedback receiving thread
		    GreenSignal = unit %and kickstart all the threads
		 [] LH | LT then
		    {Browse 'Thread being formed'}
		    thread
		       {Wait GreenSignal} %Halts here until all of the threads have been formed
		       {Browse 'Green Signal received'}
		       local X#S = LH in %Halts here if X is not bound
			  if X == true
			  then
			     {Browse 'X bound to True'}
			     {S}
			     {Send Port true}
			  else
			     {Browse 'X bound to False'}
			     {Send Port false}
			  end
		       end
		    end
		    {ChooseAux LT N+1}
		 end
	      end
	      proc {ReceiveFeedback Messages N}
		 case Messages
		 of M | Mr then
		    if M == true
		    then AtleastOneTrue = true
		    end
		    if N == 1 %THis is the last message
		    then
		       if {IsDet AtleastOneTrue} == false
		       then raise missingClause end %No variable found true
		       end
		    else
		       {ReceiveFeedback Mr N-1}
		    end
		 else raise somethingFishy end
		 end
	      end
	      {ChooseAux List 0}
	   end
	end

%Find a test case below
declare fun {GenProc M}
	   proc {$} {Browse M} end
	end

declare proc {Start}
	   local X1 X2 X3 X4 X5 in

	      {Choose [X1#{GenProc 1} X2#{GenProc 2} X3#{GenProc 3} X4#{GenProc 4} X5#{GenProc 5}]}
	      {Delay 1000}
	      X1=false
	      {Delay 1000}
	      X2=false
	      {Delay 1000}
	      X3=false
	      {Delay 1000}
	      X4=false
	      {Delay 1000}
	      X5=false
	   end
	end

{Start}