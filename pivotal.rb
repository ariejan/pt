require 'pivotal-tracker'
require 'sequel'

module PT
  def projects
    @projects ||= begin
      token = ENV.fetch("PIVOTAL_TOKEN")
      projects = ENV.fetch("PIVOTAL_PROJECTS").split(",").map { |e| e.to_i }

      PivotalTracker::Client.token = token
      projects.map &PivotalTracker::Project.public_method(:find)
    end
  end

  def sum(*states)
    current_stories.inject(0) do |sum, story|
      states.include?(story.current_state) ? sum + calculate_cp(story) : sum
    end
  end

  # Calculate the actual complexity points of a story. This method handles negative and nil
  # values that the Pivotal Tracker API gives us.
  def calculate_cp(story)
    [story.estimate || 0, 0].max
  end

  def count(type)
    current_stories.select { |story| story.story_type == type }.size
  end

  def points_done
    sum 'finished', 'delivered', 'accepted'
  end

  def points_left
    sum 'unstarted', 'started', 'rejected'
  end

  def count_bugs
    count 'bug'
  end

  def count_chores
    count 'chore'
  end

  def iteration_number
    @iteration_number ||= ENV.fetch('OFFSET', 0).to_i
  end

  def current_iteration(project)
    project.iterations.current_backlog(project).fetch(iteration_number)
  end

  def current_stories
    @current_stories ||= projects.inject([]) { |all, project| all + current_iteration(project).stories }
  end

  extend self
end

