class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :professional, class_name: "User", foreign_key: "user_id"
  belongs_to :client, class_name: "Client", foreign_key: "client_id"

  attr_accessor :client_name, :client_phone
end
