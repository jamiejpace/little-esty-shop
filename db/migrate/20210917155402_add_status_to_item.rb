class AddStatusToItem < ActiveRecord::Migration[5.2]
  def change
    def change
      add_column :items, :status, :string, default: 'disabled'
    end
  end
end
