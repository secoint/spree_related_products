class AddBothDirectionsToRelationType < ActiveRecord::Migration
  def self.up
    add_column :relation_types, :both_directions, :boolean, :default => false
  end

  def self.down
    remove_column :relation_types, :both_directions
  end
end
