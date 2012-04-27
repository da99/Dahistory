
require File.expand_path('spec/helper')
require 'Dahistory'
require 'Bacon_Colored'
require 'pry'


FOLDER = "/tmp/Dahistory_tmp"

def chdir 
  Dir.chdir(FOLDER) { yield }
end

def reset_dirs
  Exit_0 "rm -rf #{FOLDER}"
  Exit_0 "mkdir #{FOLDER}"
  Exit_0 "mkdir #{FOLDER}/files"
  Exit_0 "mkdir #{FOLDER}/history"
  Exit_0 "mkdir #{FOLDER}/history/blue"
  Exit_0 "mkdir #{FOLDER}/history/red"
  Exit_0 "mkdir #{FOLDER}/history/yellow"
  Exit_0 "mkdir #{FOLDER}/pending"
end

reset_dirs

shared( "git" ) {

  before {
    @proj     = "#{FOLDER}/project_#{rand 1000}"
    @git_repo = "#{@proj}.git"
    Exit_0 "mkdir -p #{@git_repo}"
    Exit_0 "cd #{@git_repo} && git init --bare"
    Exit_0 "mkdir -p #{@proj}"
    
    Dir.chdir(@proj) {
      Exit_0 "mkdir files"
      Exit_0 "mkdir history"
      Exit_0 "mkdir pending"
      Exit_0 "git init"
      Exit_0 "git remote add origin #{@git_repo}"
      Exit_0 "touch README.md"
      Exit_0 "git add ."
      Exit_0 %! git commit -m "First commit." !
      Exit_0 "git push -u origin master"
    }
    @file    = "files/#{rand 1000}.txt"
  }

}

# ======== Include the tests.
if ARGV.size > 1 && ARGV[1, ARGV.size - 1].detect { |a| File.exists?(a) }
  # Do nothing. Bacon grabs the file.
else
  Dir.glob('spec/tests/*.rb').each { |file|
    require File.expand_path(file.sub('.rb', '')) if File.file?(file)
  }
end
