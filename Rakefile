# -*- ruby -*-
ENV['RUBY_FLAGS'] = "-I#{%w(lib ext bin test).join(File::PATH_SEPARATOR)}"

require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

AHN_TESTS     = ['spec/**/test_*.rb']
GEMSPEC       = eval File.read("ahn_appkonference.gemspec")

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.test_files = Dir[*AHN_TESTS]
    t.output_dir = 'coverage'
    t.verbose = true
    t.rcov_opts.concat %w[--sort coverage --sort-reverse -x gems -x /var --no-validator-links]
  end
rescue LoadError
  STDERR.puts "Could not load rcov tasks -- rcov does not appear to be installed. Continuing anyway."
end

Rake::GemPackageTask.new(GEMSPEC).define

Rake::TestTask.new('spec') do |t|
  t.verbose = true
  t.pattern = AHN_TESTS
end

task :default => :spec

desc "Compares components's files with those listed in the gemspec"
task :check_gemspec_files do

  files_from_gemspec    = COMPONENT_FILES
  files_from_filesystem = Dir.glob(File.dirname(__FILE__) + "/**/*").map do |filename|
    filename[0...Dir.pwd.length] == Dir.pwd ? filename[(Dir.pwd.length+1)..-1] : filename
  end
  files_from_filesystem.reject! { |f| File.directory? f }

  puts
  puts 'Pipe this command to "egrep -v \'spec/|test\'" to ignore test files'
  puts
  puts '##########################################'
  puts '## Files on filesystem not in the gemspec:'
  puts '##########################################'
  puts((files_from_filesystem - files_from_gemspec).map { |f| "  " + f })


  puts '##########################################'
  puts '## Files in gemspec not in the filesystem:'
  puts '##########################################'
  puts((files_from_gemspec - files_from_filesystem).map { |f| "  " + f })
end

desc "Test that the .gemspec file executes"
task :debug_gem do
  require 'rubygems/specification'
  gemspec = File.read('ahn_appkonference.gemspec')
  spec = nil
  Thread.new { spec = eval("$SAFE = 3\n#{gemspec}") }.join
  puts "SUCCESS: Gemspec runs at the $SAFE level 3."
end

desc 'Install the package as a gem.'
task :install_gem => [:clobber_package, :package] do
  windows = /djgpp|(cyg|ms|bcc)win|mingw/ =~ RUBY_PLATFORM
  gem = Dir['pkg/*.gem'].first
  sh "#{'sudo ' unless windows}gem install --local #{gem}"
end
