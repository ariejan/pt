namespace :pt do
  require './pivotal'

  desc "Capture current iteration status"
  task :capture do
    DB = Sequel.connect(ENV['DATABASE_URL'])
    metrics = DB[:metrics]

    metrics.insert(
      unstarted:  PT.sum("unstarted"),
      started:    PT.sum("started"),
      finished:   PT.sum("finished"),
      delivered:  PT.sum("delivered"),
      accepted:   PT.sum("accepted"),
      rejected:   PT.sum("rejected"),
      project_id: ENV['PIVOTAL_PROJECTIDS'],
      created_at: Time.now.utc
    )

    puts "Metrics saved."
  end
end

namespace :db do
  require "sequel"
  namespace :migrate do
    Sequel.extension :migration
    DB = Sequel.connect(ENV['DATABASE_URL'])
 
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
