# frozen_string_literal: true

module Seeker
  class ProfilesController < BaseController
    before_action :load_profile, only: %i[show edit update]
    before_action :check_profile, only: %i[new create]

    def show; end

    def new
      flash.clear
      flash.now[:info] = t 'flash.fill_out_profile'
      @profile = JobSeeker::Profile.new
    end

    def create
      @profile = JobSeeker::Profile.new profile_params
      @profile.job_seeker = current_job_seeker

      if @profile.save
        flash[:success] = t 'devise.registrations.signed_up'
        redirect_to seeker_dashboard_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @profile.update profile_params
        flash[:success] = t 'flash.updated',
                            resource: t('activerecord.models.job_seeker/profile.one')
        redirect_to seeker_show_profile_path
      else
        render :edit
      end
    end

    private

    def profile_params
      params.require(:job_seeker_profile).permit :date_of_birth, :high_school,
                                                 :college, :degrees, :courses,
                                                 :interests, :bio, :avatar,
                                                 :work_experience
    end

    def load_profile
      @profile = current_job_seeker.profile
    end

    def check_profile
      redirect_to seeker_show_profile_path if current_job_seeker.profile?
    end
  end
end
