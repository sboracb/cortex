module API
  module V1
    module Helpers
      module UsersHelper
        def user
          @user ||= User.find(params[:user_id])
        end

        def user!
          user || not_found!
        end

        def user_params
          clean_params(params)
        end
      end
    end
  end
end
