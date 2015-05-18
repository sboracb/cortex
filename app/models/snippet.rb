class Snippet < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  belongs_to :webpage
  belongs_to :document

  accepts_nested_attributes_for :document
end
