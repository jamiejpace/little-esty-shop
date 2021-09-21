# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    before_action :require_user

    private

    def require_user
      permission_denied unless current_user
    end

    def permission_denied
      flash[:danger] = 'Permission Denied'
      redirect_to root_path
    end
  end
end
