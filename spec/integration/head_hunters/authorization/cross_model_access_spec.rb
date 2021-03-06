# frozen_string_literal: true

require 'rails_helper'

feature 'Logged in Head Hunter' do
  before :each do
    log_head_hunter_in!
  end

  scenario "can't log in as Job Seeker" do
    visit new_job_seeker_session_path

    expect(current_path).to eq hunter_dashboard_path
    expect(page).to have_content I18n.t('flash.cross_model_access')
  end

  scenario "can't sign up as Job Seeker" do
    visit new_job_seeker_registration_path

    expect(current_path).to eq hunter_dashboard_path
    expect(page).to have_content I18n.t('flash.cross_model_access')
  end
end
