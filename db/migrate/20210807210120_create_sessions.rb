class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions, id: :uuid do |t|
      t.integer :totalModulesStudied
      t.uuid :sessionId
      t.integer :averageScore
      t.integer :timeStudied
      t.uuid :course_id
      t.uuid :user_id

      t.timestamps
    end
  end
end
