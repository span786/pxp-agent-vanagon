begin
  require 'packaging'
  Pkg::Util::RakeUtils.load_packaging_tasks
rescue StandardError => e
  puts "Error loading packaging rake tasks: #{e}"
end

desc 'run static analysis with rubocop'
task(:rubocop) do
  require 'rubocop'
  cli = RuboCop::CLI.new
  exit_code = cli.run(%w[--display-cop-names --format simple])
  raise 'RuboCop detected offenses' if exit_code != 0
end
