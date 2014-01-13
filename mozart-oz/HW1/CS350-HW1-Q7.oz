declare fun {FoldTree Tree Function Identity}
	   case Tree
	   of nil then Identity
	   else	      
	      local tree(Key Left Right)=Tree in %pattern match
		 {Function {Function Key {FoldTree Left Function Identity}} {FoldTree Right Function Identity}}
	      end
	   end
	end

T=tree(1
       tree(2
	    tree(4 nil nil)
	    tree(5 nil nil)
	   )
       tree(3
	    tree(6 nil nil)
	    tree(7 nil nil)
	   )
      )

F=fun {$ X Y} X*Y end
I=1
{Browse {FoldTree T F I}}
