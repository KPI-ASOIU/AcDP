class FixDocumentsTimestamps < ActiveRecord::Migration
  def self.up
    change_table :documents do |t|
      t.rename :date_created, :created_at
      t.rename :date_updated, :updated_at
    end
  end

  def self.down
    change_table :documents do |t|
      t.rename :created_at, :date_created
      t.rename :updated_at, :date_updated
    end
  end
end
