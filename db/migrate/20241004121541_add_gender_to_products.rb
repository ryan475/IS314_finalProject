class AddGenderToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :gender, :string
  end
end
