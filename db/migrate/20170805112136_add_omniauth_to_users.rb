class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :provider
      t.string :uid
    end
  end
end
