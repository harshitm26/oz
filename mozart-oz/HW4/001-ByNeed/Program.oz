declare
Program =
[
 [localvar ident(flag)
  [
   [localvar ident(matched)
    [
     [localvar ident(assign)
      [
       [bind ident(assign) [routine
			    [ident(x) ident(y)]
			    [
			     [localvar ident(a)
			      [
			       [bind [routine [ident(c)] [bind ident(c) literal(10314)]] ident(a)]
			       [localvar ident(b)
				[
				 [bind [routine [ident(d)] [bind ident(d) literal(41301)]] ident(b)]
				 [apply ident(b) ident(y)]
				 [apply ident(a) ident(x)]
				]
			       ]
			      ]
			     ]
			    ]
			   ]
       ]
       [localvar ident(a)
	[
	 [localvar ident(b)
	  [
	   [localvar ident(x0)
	    [
	     [localvar ident(y0)
	      [
	       [apply ident(assign) ident(x0) ident(y0)]
	       [bind ident(a)
		[record literal(point)
		 [
		  [literal(x) ident(x0)]
		  [literal(y) ident(y0)]
		 ]
		]
	       ]
	       [bind ident(b)
		[record literal(point)
		 [
		  [literal(x) ident(y0)]
		  [literal(y) ident(x0)]
		 ]
		]
	       ]
	       [match ident(a)
		[record literal(point)
		 [
		  [literal(x) ident(xa)]
		  [literal(y) ident(ya)]
		 ]
		] 
		[
		 match ident(b)
		 [record literal(point)
		  [
		   [literal(x) ident(xb)]
		   [literal(y) ident(yb)]
		  ]
		 ] 
		 [bind ident(matched) true]
		 [bind ident(matched) false]
		]
		[bind ident(matched) false]
	       ]
	      ]
	     ]
	    ]
	   ]
	  ]
	 ]
	]
       ]
      ]
     ]
    ]
   ]
  ]
 ]
 [localvar ident(toBeBound)
  [
   [localvar ident(bindingRoutine)
    [
     [bind ident(bindingRoutine) [routine [ident(x)] [bind ident(x) literal(10314)]]]
     [byneed [subr ident(bindingRoutine)] ident(toBeBound)]
     [nop]
    ]
   ]
  ]
 ]
]