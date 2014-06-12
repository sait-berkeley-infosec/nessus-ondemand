class CreateScans < ActiveRecord::Migration
  def change
    create_table :scans do |t|
      t.integer :user
      t.string :targets
      t.datetime :goes_off
      t.integer :policy
      t.string :uuid
      t.string :results

      t.timestamps
    end
  end
end
