namespace :pt do

  desc "Capture current iteration status"
  task :capture do
    require './pivotal'

    if ENV.fetch('DATABASE_URL', nil).nil?
      puts "No database configured. Outputting to STDOUT"

      puts PT.current_iteration.number
      puts PT.current_iteration.start
      puts PT.current_iteration.finish

      puts PT.sum("unstarted")
      puts PT.sum("started")
      puts PT.sum("finished")
      puts PT.sum("delivered")
      puts PT.sum("accepted")
      puts PT.sum("rejected")
      puts ENV['PIVOTAL_PROJECTS'].to_i
      puts Time.now.utc
    else
      puts "Connecting to database"
      DB = Sequel.connect(ENV['DATABASE_URL'])
      metrics = DB[:metrics]

      puts "Capturing data..."
      metrics.insert(
        unstarted:           PT.sum("unstarted"),
        started:             PT.sum("started"),
        finished:            PT.sum("finished"),
        delivered:           PT.sum("delivered"),
        accepted:            PT.sum("accepted"),
        rejected:            PT.sum("rejected"),
        project_id:          ENV['PIVOTAL_PROJECTS'].to_i,
        created_at:          Time.now.utc,
        iteration:           PT.current_iteration.number,
        iteration_starts_on: PT.current_iteration.start,
        iteraion_ends_on:   PT.current_iteration.finish
      )

      puts "Metrics saved."
    end
  end
end

namespace :db do
  require "sequel"
  namespace :migrate do
    Sequel.extension :migration
    DB = Sequel.connect(ENV['DATABASE_URL']) unless ENV.fetch('DATABASE_URL', nil).nil?
 
    desc "Perform migration reset (full erase and migration up)"
    task :reset do
      Sequel::Migrator.run(DB, "migrations", :target => 0)
      Sequel::Migrator.run(DB, "migrations")
      puts "<= sq:migrate:reset executed"
    end
 
    desc "Perform migration up/down to VERSION"
    task :to do
      version = ENV['VERSION'].to_i
      raise "No VERSION was provided" if version.nil?
      Sequel::Migrator.run(DB, "migrations", :target => version)
      puts "<= sq:migrate:to version=[#{version}] executed"
    end
 
    desc "Perform migration up to latest migration available"
    task :up do
      Sequel::Migrator.run(DB, "migrations")
      puts "<= sq:migrate:up executed"
    end
 
    desc "Perform migration down (erase all data)"
    task :down do
      Sequel::Migrator.run(DB, "migrations", :target => 0)
      puts "<= sq:migrate:down executed"
    end
  end
end
