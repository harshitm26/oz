CS350 -- Principles of Programming Languages
Solution to Assignment 2
Siddharth Agarwal | Y7429

All these files are supposed to be in the same directory. Files are
supposed to be executed by loading them into emacs and pressing
C-. C-b. Note that I have not tested execution from the command line.

Common dependencies
-------------------

Both Q1 and Q2 need an SAS, an implementation of which has been provided in
SingleAssignmentStore.oz. It exports several functions, including AddKeyToSAS,
which generates a fresh key, BindValueToKeyInSAS, which binds a value to a key,
BindRefToKeyInSAS, which binds a reference to another key to a key (thus
implementing equivalence classes), and RetrieveFromSAS, which retrieves the
value for a key.

We have used an Oz dictionary for the SAS, and integers for the keys.

Question 1
----------

The unifier is implemented in Unify.oz. It first runs through the expressions,
substituting identifiers for their values wherever possible. It then unifies the
two expressions, following the standard rules as given in the book.

Note that we do not handle ill-formed expressions (e.g. records with two
features having the same name).

The five programs to test are all written in Loz, which is the language I
invented for Q2. To run, execute TestUnify.oz.

Question 2
----------

The main logic is implemented in KLInterpreter.oz.

I have invented a new Lisp-like language for this, which I call "Loz". A
description of this language can be found in the comment at the top of the
file. Each Oz kernel statement is equivalent to a Loz statement.

We handle each statement in the standard way given in the class/text.

We have used a record for the environment, mapping identifiers to SAS keys, and
a stack implemented using lists for the semantic stack.

To test, run TestKLInterpreter.oz.
