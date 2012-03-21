
Dahistory
=========

Short for: da99's gem for file history.

It helps you compare files and decide if the file should be backed up.
It is mainly to help you keep backups of files you overwrite on servers you administer.

**Example:** You use Chef or Puppet to write a config file, but you want to be sure you
are overwriting a file you have encountered before.

Useage
------

    require "Dahistory"

    path = "some/file.txt"
    Dahistory_File( path )
    # Checks your ./history directory.
    # If not found there, saves copy of file in ./pending dir and
    #  raises Dahistory::Pending_File, "pending/HOSTNAME,path,some,file.txt.TIMESTAMP"

    # You review the file,
    #   move the file from the pending directory, and 
    #   re-do your last command (Capistrano, Chef, Puppet, etc.)

Override the default settings:

    Dahistory.check { |o|
    
      o.file        "file/path.txt"
      o.dirs        [ "dir1", "dir2" ]
      o.backup_dir  "./history"
      o.pending_dir "pending_dir_path"
      o.backup_file "#{`hostname`}.backup.path.txt"
      
    }

