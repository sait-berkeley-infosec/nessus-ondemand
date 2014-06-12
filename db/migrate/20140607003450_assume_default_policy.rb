class AssumeDefaultPolicy < ActiveRecord::Migration
  def up
    change_column :scans, :policy, :integer, :default => 0
  end

  def down
    change_column :scans, :policy, :integer, :default => nil
  end
end
