module Cortex
  class ContentType < Cortex::ApplicationRecord
    include Cortex::SearchableContentType
    include Cortex::SearchableContentItemForContentType
    include Cortex::BelongsToTenant

    validates :name, :creator, :contract, presence: true
    validates_uniqueness_of :name,
                            :name_id,
                            scope: :tenant_id,
                            message: 'should be unique within a Tenant'

    belongs_to :creator, class_name: 'User'
    belongs_to :contract
    has_many :fields
    has_many :content_items
    has_many :contentable_decorators, as: :contentable
    has_many :decorators, through: :contentable_decorators

    accepts_nested_attributes_for :fields

    # TODO: Extract to a concern
    def self.permissions
      Permission.select { |perm| perm.resource_type = self }
    end
  end
end
