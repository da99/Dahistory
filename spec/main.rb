
require File.expand_path('spec/helper')
require 'Dahistory'
require 'Bacon_Colored'
require 'pry'


FOLDER = "/tmp/Dahistory_tmp"

def chdir 
  Dir.chdir(FOLDER) { yield }
end

def reset_dirs
  Exit_Zero "rm -rf #{FOLDER}"
  Exit_Zero "mkdir #{FOLDER}"
  Exit_Zero "mkdir #{FOLDER}/files"
  Exit_Zero "mkdir #{FOLDER}/history"
  Exit_Zero "mkdir #{FOLDER}/history/blue"
  Exit_Zero "mkdir #{FOLDER}/history/red"
  Exit_Zero "mkdir #{FOLDER}/history/yellow"
  Exit_Zero "mkdir #{FOLDER}/pending"
end

reset_dirs

shared( "git" ) {

  before {
    @proj     = "#{FOLDER}/project_#{rand 1000}"
    @git_repo = "#{@proj}.git"
    Exit_Zero "mkdir -p #{@git_repo}"
    Exit_Zero "cd #{@git_repo} && git init --bare"
    Exit_Zero "mkdir -p #{@proj}"
    
    Dir.chdir(@proj) {
      Exit_Zero "mkdir files"
      Exit_Zero "mkdir history"
      Exit_Zero "mkdir pending"
      Exit_Zero "git init"
      Exit_Zero "git remote add origin #{@git_repo}"
      Exit_Zero "touch README.md"
      Exit_Zero "git add ."
      Exit_Zero %! git commit -m "First commit." !
      Exit_Zero "git push -u origin master"
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
