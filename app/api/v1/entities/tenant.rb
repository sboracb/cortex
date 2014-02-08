module API::V1
  module Entities
    class Tenant < Grape::Entity
      expose :name, :id, :contact_name, :contact_email, :contact_phone, :created_at, :deleted_at, :deactive_at,
             :active_at, :updated_at, :contract, :did, :parent_id
    end
  end
end
