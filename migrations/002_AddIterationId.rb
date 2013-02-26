Sequel.migration do
  up do
    add_column :metrics, :iteration, Integer
    add_column :metrics, :iteration_starts_on, DateTime
    add_column :metrics, :iteraion_ends_on, DateTime
  end

  down do
    drop_column :metrics, :iteration
    drop_column :metrics, :iteration_starts_on
    drop_column :metrics, :iteration_ends_on
  end
end
