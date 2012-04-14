
Dahistory
=========

Short for: da99's gem for file history.

It helps you compare files and decide if the file should be backed up.
It is mainly to help you keep backups of files you overwrite on servers you administer.

**Example:** You use Chef or Puppet to write a config file, but you want to be sure you
are overwriting a file you have encountered before.

Installation
------------

    gem install Dahistory

Usage
------

    # In your Chef-Solo recipe or your Ruby code...

    require "Dahistory"
    
    Dahistory "some/file.txt" 
    
    # Checks your directory (default "./history").
    # If not found there, saves copy of file in ./pending dir and
    #  raises Dahistory::Pending_File, "pending/HOSTNAME,path,some,file.txt.TIMESTAMP"
    #
    # You review the file,
    #   move the file from the pending directory to your source/history dir, and 
    #   run your recipe/code again.

Override the default settings:

    Dahistory { |o|
    
      o.file        "file/name.txt"
      o.dirs        "dir1", "dir2"  # defaults to "./history"
      o.pending_dir "./pending"
      o.backup_file "#{`hostname`}.name.txt.#{Time.now.to_i}"
      o.on_raise_pending {
        # Run right before Pending_File is raised.
      }
      
    }

**Note:** 
Both **def Dahistory** and **class Dahistory** are defined. 
All the code is in one file and less than 150 lines: 
[lib/Dahistory.rb](https://github.com/da99/Dahistory/blob/master/lib/Dahistory.rb)

Usage: Dahistory + Git
-----------------------

Dahistory has some methods that can be used as shortcuts when using git.

    Dahistory { |o|
    
      o.file "some/file.txt"

      o.git_add_commit

      # ...is a shortcut for:
      o.on_raise_pending {
        `git add #{o.backup_file}`
        `git commit -m "Backup: #{o.backup_file}"`
      }

    }
 
`git_add_commit_push` does the same above, 
but runs "git push" after the commit:

    o.git_add_commit_push
    
    # or...
    o.git_add_commit_push 'my_remote my_branch' 

Run Tests
---------

    git clone git@github.com:da99/Dahistory.git
    cd Dahistory
    bundle update
    bundle exec bacon spec/main.rb

"I hate writing."
-----------------------------

If you know of existing software that makes the above redundant,
please tell me. The last thing I want to do is maintain code.

