# frozen_string_literal: true

require 'rails_helper'

feature 'User opens home page' do
  scenario 'when logged in as a Head Hunter' do
    log_head_hunter_in!

    visit root_path

    expect(current_path).to eq hunter_dashboard_path
    expect(page).to have_link I18n.t('views.navigation.home')
    expect(page).to have_link href: root_path, count: 2

    expect(page).to have_link I18n.t('views.actions.log_out'),
                              href: destroy_head_hunter_session_path
    expect(page).not_to have_link I18n.t('views.actions.log_out'),
                                  href: destroy_job_seeker_session_path

    expect(page).not_to have_link I18n.t('views.navigation.log_in'),
                                  href: new_head_hunter_session_path
    expect(page).not_to have_link I18n.t('views.navigation.create_account'),
                                  href: new_head_hunter_registration_path
    expect(page).not_to have_link I18n.t('views.navigation.log_in'),
                                  href: new_job_seeker_session_path
    expect(page).not_to have_link I18n.t('views.navigation.create_account'),
                                  href: new_job_seeker_registration_path

    expect(page).to have_content I18n.t('views.head_hunters.dashboard.title')
    expect(page).to have_content I18n.t('views.head_hunters.dashboard.greeting')

    expect(page).to have_content I18n.t('views.footer.message_1')
    expect(page).to have_link 'Luis Geniole', href: 'https://github.com/librity'
    expect(page).to have_content I18n.t('views.footer.message_2')
    expect(page).to have_link 'Treina Dev,', href: 'https://treinadev.com.br/'
    expect(page).to have_content I18n.t('views.footer.message_3')
    expect(page).to have_link 'Campus Code', href: 'https://www.campuscode.com.br/'

    expect(page).to have_link I18n.t('views.footer.original_repo'),
                              href: 'https://github.com/librity/campus_code_job_seeker_app'
  end
end
