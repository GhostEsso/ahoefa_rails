namespace :lint do
  desc "Run Rubocop with auto-correct"
  task :fix do
    sh "bundle exec rubocop -A"
  end

  desc "Run Rubocop without auto-correct"
  task :check do
    sh "bundle exec rubocop"
  end
end

desc "Run all linters with auto-correct"
task lint: ["lint:fix"]
