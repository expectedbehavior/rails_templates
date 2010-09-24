class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :first_name
      t.string   :last_name
      t.string   :email,                                  :null => false
      t.string   :crypted_password,                       :null => false
      t.string   :password_salt,                          :null => false
      t.string   :persistence_token,                      :null => false
      t.string   :single_access_token,                    :null => false
      t.string   :perishable_token,                       :null => false
      t.integer  :login_count,         :default => 0,     :null => false
      t.integer  :failed_login_count,  :default => 0,     :null => false
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
