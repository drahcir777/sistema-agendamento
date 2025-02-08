class Disponibilidade < ApplicationRecord
  belongs_to :profissional, class_name: "User", foreign_key: "user_id"
end
