Sequel.migration do
  up do
    create_table(:metrics) do
      primary_key :id

      Integer :unstarted
      Integer :started
      Integer :finished
      Integer :delivered
      Integer :accepted
      Integer :rejected

      Integer :project_id

      DateTime :created_at,         null: false
    end
  end

  down do
    drop_table :metrics
  end
end
