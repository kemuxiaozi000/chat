class AddColumnsToUserRelations < ActiveRecord::Migration[5.2]
  def change
    add_column :user_relations, :channel_id, :string, comment: '订阅号id'
  end
end
