class AddTagViews < ActiveRecord::Migration[5.1]
  def up
    command = %(
      CREATE VIEW child_tags AS
      SELECT * from tags;
      CREATE VIEW grandchild_tags AS
      SELECT * from tags;
    )
    execute command
  end

  def down
    command = %(
      DROP VIEW child_tags;
      DROP VIEW grandchild_tags;
    )
    execute command
  end
end
