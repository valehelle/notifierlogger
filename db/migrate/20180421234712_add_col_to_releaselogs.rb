class AddColToReleaselogs < ActiveRecord::Migration[5.2]
  def change
    add_column :releaselogs, :release_version, :string
    add_column :releaselogs, :is_released, :boolean
  end
end
