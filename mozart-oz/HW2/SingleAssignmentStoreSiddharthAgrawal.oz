%% A single assignment store. This maps "variables" in our
%% make-believe system to values (we use Oz structures for values --
%% no need to reinvent the wheel there).

%% Reserved keywords:
%% nothing -- used for an unbound value internally
%% reference(X) -- used for a reference chain that we follow
%% equivalence(X) -- used for an unbound value externally -- this
%% is guaranteed to be the same for two keys in the same equivalence
%% set.

declare
SingleAssignmentStore
{Dictionary.new SingleAssignmentStore}

ItemsAllotted
{NewCell 0 ItemsAllotted}

%% Add a key to the single assignment store. This will return the key
%% that you can associate with your identifier and later assign a
%% value to.
fun {AddKeyToSAS}
  local CurrentItem
  in
    CurrentItem = @ItemsAllotted
    {Dictionary.put SingleAssignmentStore CurrentItem nothing}
    ItemsAllotted := CurrentItem + 1
    CurrentItem
  end
end

%% Bind a value to a key in the SAS. This makes sure that the key
%% currently points to |nothing|.
proc {BindValueToKeyInSAS Key Val}
  CurrentVal = {Dictionary.get SingleAssignmentStore Key}
in
  case CurrentVal
  of nothing then
    {Dictionary.put SingleAssignmentStore Key Val}
  [] reference(RefKey) then
    {BindValueToKeyInSAS RefKey Val}
  else
    {Exception.raiseError alreadyAssigned(Key Val CurrentVal)}
  end
end

%% Bind a reference to another key to a key in the SAS. This makes
%% sure that the key currently points to |nothing|.
proc {BindRefToKeyInSAS Key RefKey}
  {BindValueToKeyInSAS Key reference(RefKey)}
end

%% Retrieve a value from the single assignment store. This will raise
%% an exception if the key is missing from the SAS. For unbound keys,
%% this will return equivalence(Key) -- this is guaranteed to be the
%% same for two keys in the same equivalence set, modulo modification
%% of the SAS.
fun {RetrieveFromSAS Key}
  Val = {Dictionary.get SingleAssignmentStore Key}
in
  case Val
  of reference(RefKey) then
    {RetrieveFromSAS RefKey}
  [] nothing then
    equivalence(Key)
  else
    Val
  end
end
