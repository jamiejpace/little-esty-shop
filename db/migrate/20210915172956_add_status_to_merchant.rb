# frozen_string_literal: true

class AddStatusToMerchant < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :status, :string, default: 'enabled'
  end
end
