// //! add this with the isolate.spawn to use the receive and send ports method to send the reulst after each stream is done
// //! the new analyzing method will be like this
// //! make a large list of all folders and sub folders with each list item having the current props
// //! ==Create a folder info class or update the current one, and create a file info class == path, list of children(folders , files), parent path
// //! file info class with hold data like modified date, path, name, ext, parent, size... , and the folder info will have the same
// //! all of this data will be saved to sqlite
// //! check the sqlite saving and retreiving time to test it for large amount of data (20,000) files and folders for example
// //! ------------------------------------------
// //! about useing isolate with streams, i will use the send port to send the data after the stream of each folder is done calculating the data for that folder
// //!------------------------- DEEP THINKING ---------------------
// //! for calculating the size of each folder, you should sum the files sizes with it's sub-dir sizes
// //! so for example, a dir with one file(2MB) and a folder(2 items)
// //! the size of the parent dir will be 2MB at first
// //! after scanning the sub-dir , the sub-dir size will be 5MB for example
// //! then the parent-dir size will be updated to be 2+5
// //! but how can we notice the sub dir size change to update it for the parent dir
// //!
