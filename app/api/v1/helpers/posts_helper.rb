module API::V1
  module Helpers
    module PostsHelper
      def post
        @post ||= Post.find_by_id(params[:id])
      end

      def post!
        post || not_found!
      end
    end
  end
end