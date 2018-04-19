class Project < ApplicationRecord
  belongs_to :user
  has_many :gitchanges, class_name: "Change"
end
