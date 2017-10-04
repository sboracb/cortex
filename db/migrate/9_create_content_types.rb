class CreateContentTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :content_types, id: :uuid do |t|
      t.string :name, null: false, index: true
      t.text :description
      t.references :creator, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.references :tenant, type: :uuid, null: false, foreign_key: true
      t.references :contract, type: :uuid, null: false, foreign_key: true
      t.boolean :publishable, null: false, default: false
      t.string :icon, default: :help

      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
