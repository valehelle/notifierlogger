class CreateReleaselogs < ActiveRecord::Migration[5.2]
  def change
    create_table :releaselogs do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.datetime :release_date
      t.string :added
      t.string :changed
      t.string :deprecated
      t.string :removed
      t.string :fixed
      t.string :security

      t.timestamps
    end
  end
end
