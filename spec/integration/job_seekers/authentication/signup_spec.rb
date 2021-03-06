# frozen_string_literal: true

require 'rails_helper'

feature 'Job Seeker can signup' do
  scenario 'successfully' do
    job_seeker = build :job_seeker
    profile = build :job_seeker_profile

    visit root_path
    within 'li#seeker_dropdown' do
      click_on I18n.t('views.navigation.create_account')
    end

    fill_in I18n.t('activerecord.attributes.job_seeker.name'), with: job_seeker.name
    fill_in I18n.t('activerecord.attributes.job_seeker.email'), with: job_seeker.email
    fill_in I18n.t('activerecord.attributes.job_seeker.password'), with: job_seeker.password
    fill_in I18n.t('activerecord.attributes.job_seeker.password_confirmation'), with: job_seeker.password
    within 'form' do
      click_on I18n.t('views.actions.sign_up')
    end

    expect(current_path).to eq new_seeker_profile_path
    expect(page).to have_content I18n.t('flash.fill_out_profile')

    attach_file I18n.t('activerecord.attributes.job_seeker/profile.avatar'), FileUploadSupport.png_path
    fill_in I18n.t('activerecord.attributes.job_seeker/profile.date_of_birth'),
            with: profile.date_of_birth
    fill_in I18n.t('activerecord.attributes.job_seeker/profile.high_school'),
            with: profile.high_school
    fill_in I18n.t('activerecord.attributes.job_seeker/profile.college'),
            with: profile.college
    fill_in I18n.t('activerecord.attributes.job_seeker/profile.degrees'),
            with: profile.degrees
    fill_in I18n.t('activerecord.attributes.job_seeker/profile.courses'),
            with: profile.courses
    fill_in I18n.t('activerecord.attributes.job_seeker/profile.interests'),
            with: profile.interests
    fill_in I18n.t('activerecord.attributes.job_seeker/profile.bio'),
            with: profile.bio
    fill_in I18n.t('activerecord.attributes.job_seeker/profile.work_experience'),
            with: profile.work_experience
    within 'form' do
      click_on I18n.t('views.actions.send')
    end

    expect(page).to have_content I18n.t('devise.registrations.signed_up')

    expect(page).to have_link I18n.t('views.actions.log_out'),
                              href: destroy_job_seeker_session_path
    expect(page).not_to have_link I18n.t('views.navigation.log_in'),
                                  href: new_job_seeker_session_path
    expect(page).not_to have_link I18n.t('views.navigation.create_account'),
                                  href: new_job_seeker_registration_path
  end
end
