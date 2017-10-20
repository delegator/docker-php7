task default: ['build:force']

desc 'Build the docker image'
task build: [:stamp] do
  sh 'docker build -t delegator/php7:7.0 .'
end

namespace :build do
  desc 'Build the docker image, ignoring any existing layer cache'
  task force: [:stamp] do
    sh 'docker build --no-cache=true -t delegator/php7:7.0 .'
  end
end

desc 'Update the "image built at" timestamp'
task :stamp do
  sh 'date -Ru >build-stamp'
end

desc 'Run the docker image locally for testing'
task :test do
  sh 'docker run --rm -p 3000:80 delegator/php7:7.0'
end
