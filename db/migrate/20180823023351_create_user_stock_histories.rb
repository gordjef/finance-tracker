class CreateUserStockHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :user_stock_histories do |t|
      t.references :user, foreign_key: true
      t.references :stock, foreign_key: true
      t.datetime :date
      t.decimal :last_price

      t.timestamps
    end
  end
end
