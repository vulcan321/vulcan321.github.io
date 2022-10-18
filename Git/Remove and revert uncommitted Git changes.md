# Remove and revert uncommitted Git changes

There are two Git commands a developer must use in order to discard all local changes in Git, remove all uncommited changes and revert their Git working tree back to the state it was in when the last commit took place.

GPT.display('mu-top')

The commands to discard all local changes in Git are:

1. git reset -–hard
2. git clean --fxd

### Uncommitted Git change types

To understand why these two commands are required to locally remove uncommitted Git changes, you need to understand the four different types of uncommitted changes that exist in Git. They are:

- updated files that have been added to the index
- newly created files that have been added to the index
- updated files that have _not_ been added to the index
- newly created files that have _not_ been added to the index

There are four types of files to think about when you remove and discard local Git changes.

### Git reset doesn’t discard all local changes

The _git reset –hard_ command will revert uncommitted changes that exist in files that have been added to the index, whether those files are newly created files, or files that were added to the index in the past and have been edited since the last commit. 
However, if any new files have been created in the Git repository that have never been added to the index, these files will remain in the project folder after the hard reset. To remove these files, the _git clean -fxd_ command is needed.

### All local changes removed

In the vast majority of instances, these two commands are all that is required to discard all local Git changes and revert and remove uncommitted Git changes from your local repository.