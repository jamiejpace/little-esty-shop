# frozen_string_literal: true

class ChangeMerchantsStatusDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :merchants, :status, 'disabled'
  end
end
