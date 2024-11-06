# frozen_string_literal: true

require 'minitest/test_task'
require 'rubocop/rake_task'

Minitest::TestTask.create(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.warning = false
  t.test_globs = ['test/**/*_test.rb', 'test/**/*_spec.rb']
end

task default: :test

RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['-a', 'lib', 'test']
end

desc 'Run both tests and linting'
task all: %i[test rubocop]
