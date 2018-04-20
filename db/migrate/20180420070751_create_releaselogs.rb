class CreateReleaselogs < ActiveRecord::Migration[5.2]
  def change
    create_table :releaselogs do |t|
      t.references :project, foreign_key: true
      t.references :user, foreign_key: true
      t.date :release_date
      t.string :modify
      t.string :added
      t.string :deprecated
      t.string :removed
      t.string :fixed
      t.string :security
      t.string :notify

      t.timestamps
    end
  end
end
