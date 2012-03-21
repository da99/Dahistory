
require File.expand_path('spec/helper')
require 'Dahistory'
require 'Bacon_Colored'
require 'pry'


FOLDER = "/tmp/Dahistory_tmp"

def chdir 
  Dir.chdir(FOLDER) { yield }
end

def reset_dirs
  `rm -rf #{FOLDER}`
  `mkdir #{FOLDER}`
  `mkdir #{FOLDER}/files`
  `mkdir #{FOLDER}/history`
  `mkdir #{FOLDER}/history/blue`
  `mkdir #{FOLDER}/history/red`
  `mkdir #{FOLDER}/history/yellow`
  `mkdir #{FOLDER}/pending`
end

reset_dirs

# ======== Include the tests.
if ARGV.size > 1 && ARGV[1, ARGV.size - 1].detect { |a| File.exists?(a) }
  # Do nothing. Bacon grabs the file.
else
  Dir.glob('spec/tests/*.rb').each { |file|
    require File.expand_path(file.sub('.rb', '')) if File.file?(file)
  }
end
