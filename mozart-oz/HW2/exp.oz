declare Dict
{Dictionary.new ?Dict}
{Dictionary.put Dict 1 jeetesh}
{Browse {Dictionary.get Dict 1}}

/*
declare
R = rec(x:xa y:ya)
{Browse R}
{Browse R.y}
A = adj(y:yna z:za)
{Browse {Record.adjoin R A}}
*/

declare X Jet
{Cell.new nil Jet}
Jet := jeetesh
{Browse @Jet}