# frozen_string_literal: true

module Hunter
  class SessionsController < Devise::SessionsController
    include Accessible
    skip_before_action :check_user, only: :destroy
  end
end
