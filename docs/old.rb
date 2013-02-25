
  task :left do
    puts "#{PT.points_left.to_s.rjust(4)} CP left"
  end

  task :done do
    puts "#{PT.points_done.to_s.rjust(4)} CP done"
  end

  task :chores do
    puts "#{PT.count_chores.to_s.rjust(4)} bugs left"
  end

  task :bugs do
    puts "#{PT.count_bugs.to_s.rjust(4)} chores left"
  end

  desc 'Show remaining work per team member'
  task :team do
    puts PT.current_stories.inject(Hash.new { |h,k| h[k] = 0 }) { |grouped, story|
      grouped[story.owned_by] += PT.calculate_cp(story) unless story.current_state == 'accepted' || story.current_state == 'unstarted'
      grouped
    }.map { |k,v|
      "#{v.to_s.rjust(3)} #{k || 'None'}"
    }.sort { |a, b|
      a.strip.to_i <=> b.strip.to_i
    }.reverse
  end

  desc 'Show how complexity points are distributed across story states'
  task :distribution do
    %w{unstarted started finished delivered accepted rejected}.each do |state|
      puts "#{PT.sum(state).to_s.rjust(4)} CP #{state.capitalize}"
    end
  end

  file 'storycards.pdf' do |t|
    PT.create_pdf_story_cards(t.name, PT.current_stories)
  end

  desc 'Generate a PDF with story cards for the current iteration'
  task 'cards' => 'storycards.pdf'

  desc 'Show this iteration\'s progress in complexity points'
  task status: [:done, :left, :bugs, :chores]
end
