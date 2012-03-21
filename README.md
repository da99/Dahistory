
Dahistory
=========

Short for: da99's gem for file history.

It helps you compare files and decide if the file should be backed up.
It is mainly to help you keep backups of files you overwrite on servers you administer.

**Example:** You use Chef or Puppet to write a config file, but you want to be sure you
are overwriting a file you have encountered before.

Installation
------------

    gem 'Dahistory'

Useage
------

    require "Dahistory"

    Dahistory "some/file.txt" 
    
    # Checks your directory (default "./history").
    # If not found there, saves copy of file in ./pending dir and
    #  raises Dahistory::Pending_File, "pending/HOSTNAME,path,some,file.txt.TIMESTAMP"

    # You review the file,
    #   move the file from the pending directory to your source/history dir, and 
    #   re-do your last command (Capistrano, Chef, Puppet, etc.)

Override the default settings:

    Dahistory { |o|
    
      o.file        "file/name.txt"
      o.dirs        "dir1", "dir2"  # defaults to "./history"
      o.pending_dir "./pending"
      o.backup_file "#{`hostname`}.name.txt.#{Time.now.to_i}"
      
    }

**Note:** 
Both **def Dahistory** and **class Dahistory** are defined. 
All the code is in one file and less than 150 lines: 
[lib/Dahistory.rb](https://github.com/da99/Dahistory/blob/master/lib/Dahistory.rb)

Run Tests
---------

    git clone git@github.com:da99/Dahistory.git
    cd Dahistory
    bundle update
    bundle exec bacon spec/main.rb

Alan Kay Model of Development
-----------------------------

If you know of a better way of accomplishing the above functionality,
please tell me.  I want to do everything possible to make everything I write
obsolete.
