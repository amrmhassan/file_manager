# save each folder scrolling position

# listy section in the app drawer

-- this will hold the lists of files-folders that the user will create to easy access them
-- they will support user rearranging by dragging and dropping(reorder list)
-- allow the user to choose an icon for them

# allow the user to backup his data to the server(lists, favorites, other settings) not files or storage analyzer options

# add whatsapp, telegram, facebook, messenger, snapchat etc... folder to the recent files

-- or collect them in a social media apps link

# save whatsapp images, voice notes, etc, into a sqlite db, and load them from sqlite, and load the actual files in back , then update them

# fix the issue of ( the user might close the program before saving the analyzing data and after deleting the database)

-- so make another backup temp database with the current temp one and save to the temp one then delete the current
-- two temp dbs will be there (currentTempDb, backupTempDb)
-- copy to the currentTempDb then when opening in the second time copy data to the backupTempDb and delete current , in the next time copy to current and delete the backup
-- to choose where to save data just check and copy to the empty and after copying delete the other one
-- and when retrieving the data just choose from the one that has data in it
-- or just set a variable in the global constants or in shared prefs to the database that will have the most recent data to read from it


# implement the music player , (controllers, with sound volume controller in the side)