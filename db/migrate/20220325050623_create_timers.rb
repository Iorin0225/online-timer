class CreateTimers < ActiveRecord::Migration[6.1]
  def change
    create_table :timers do |t|
      t.string :token
      t.datetime :start_at
      t.integer :timer_seconds
      t.timestamps
    end

    add_index :timers, :token
  end
end
