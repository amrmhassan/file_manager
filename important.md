to handle viewing files which aren't part of share space
 you need to consider 2 cases
 1 - exploring a folder that isn't a part of share space
 2 - viewing files or folders that are hidden from share space(children of a folder)

1 - for the first case
-- you should hide the parent path from the path row viewer in the share space explorer

2 - for the second case
-- you should detect that a sub entity is part of share space if it's a child of a folder that is in share space
-- and change "the add to share space" to be "remove" and when removed you should add it to the hidden list paths
-- this list will be removed by share space before asking for the folder children not for asking for share space items itself as it won't be there

