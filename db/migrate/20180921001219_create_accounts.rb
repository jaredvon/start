class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :subdomain
      t.belongs_to :owner,class:"User"

      t.timestamps
    end
  end
end
