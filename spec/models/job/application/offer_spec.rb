# frozen_string_literal: true

require 'rails_helper'

describe Job::Application::Offer, type: :model do
  let(:subject) { create :job_application_offer }

  it 'has relations' do
    expect(subject).to respond_to(:application)
    expect(subject).to respond_to(:head_hunter)
    expect(subject).to respond_to(:job_seeker)
    expect(subject).to respond_to(:job)
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  context 'validation: application' do
    it 'cannot be blank' do
      subject.application = nil

      expect(subject).to_not be_valid
      expect(subject.errors[:application]).to include(I18n.t('errors.messages.blank'))
    end
  end

  context 'validation: head_hunter' do
    it 'cannot be blank' do
      subject.head_hunter = nil

      expect(subject).to_not be_valid
      expect(subject.errors[:head_hunter]).to include(I18n.t('errors.messages.blank'))
    end
  end

  context 'validation: start_date' do
    it 'cannot be blank' do
      subject.start_date = ' '

      expect(subject).to_not be_valid
      expect(subject.errors[:start_date]).to include(I18n.t('errors.messages.blank'))
    end

    it 'must be a date' do
      subject.start_date = '123123'

      expect(subject).to_not be_valid
      expect(subject.errors[:start_date]).to include(I18n.t('errors.messages.invalid'))
    end

    it 'must be in the future' do
      subject.start_date = 1.day.ago

      expect(subject).to_not be_valid
      expect(subject.errors[:start_date]).to include(I18n
        .t('activerecord.errors.models.job/application/offer.attributes.start_date.retroactive'))
    end
  end

  context 'validation: salary' do
    it 'cannot be blank' do
      subject.salary = ' '

      expect(subject).to_not be_valid
      expect(subject.errors[:salary]).to include(I18n.t('errors.messages.blank'))
    end

    it 'should be numerical' do
      subject.salary = '12B4'

      expect(subject).to_not be_valid
      expect(subject.errors[:salary])
        .to include(I18n.t('errors.messages.not_a_number'))
    end

    it 'should be an integer' do
      subject.salary = '12.4'

      expect(subject).to_not be_valid
      expect(subject.errors[:salary])
        .to include(I18n.t('errors.messages.not_an_integer'))
    end

    it 'should be greater than or equal to brazilian minimum wage' do
      subject.salary = '1038'

      expect(subject).to_not be_valid
      expect(subject.errors[:salary])
        .to include(I18n.t('errors.messages.greater_than_or_equal_to', count: 1039))
    end
  end

  context 'validation: responsabilities' do
    it 'cannot be blank' do
      subject.responsabilities = ' '

      expect(subject).to_not be_valid
      expect(subject.errors[:responsabilities]).to include(I18n.t('errors.messages.blank'))
    end

    it 'must have at least 50 characters' do
      subject.responsabilities = 'a' * 49

      expect(subject).to_not be_valid
      expect(subject.errors[:responsabilities]).to include(I18n.t('errors.messages.too_short', count: 50))
    end
  end

  context 'validation: benefits' do
    it 'cannot be blank' do
      subject.benefits = ' '

      expect(subject).to_not be_valid
      expect(subject.errors[:benefits]).to include(I18n.t('errors.messages.blank'))
    end

    it 'must have at least 50 characters' do
      subject.benefits = 'a' * 49

      expect(subject).to_not be_valid
      expect(subject.errors[:benefits]).to include(I18n.t('errors.messages.too_short', count: 50))
    end
  end

  context 'validation: status' do
    it 'should default to ongoing' do
      expect(subject.ongoing?).to eq true
      expect(subject.status).to eq 'ongoing'
    end

    it 'can be accepted' do
      subject.accepted!

      expect(subject.accepted?).to eq true
      expect(subject.status).to eq 'accepted'
    end

    it 'can be rejected' do
      subject.rejected!

      expect(subject.rejected?).to eq true
      expect(subject.status).to eq 'rejected'
    end
  end

  context 'method: reject!' do
    it 'should change status to rejected and skip validation' do
      subject = create :job_application_offer, :skip_validation, :old
      subject.reject!

      expect(subject.rejected?).to eq true
      expect(subject.feedback).to eq nil
    end

    it 'and also update feedback' do
      subject = create :job_application_offer, :skip_validation, :old
      feedback = build(:job_application_offer, :with_feedback).feedback
      subject.reject! feedback

      expect(subject.rejected?).to eq true
      expect(subject.feedback).to eq feedback
    end
  end

  context 'method: reject_with_default_feedback!' do
    it 'should change status to rejected, feedback to accepted_another_offer and skip validation' do
      subject = create :job_application_offer, :skip_validation, :old
      subject.reject_with_default_feedback!

      expect(subject.rejected?).to eq true
      expect(subject.feedback).to eq I18n.t('activerecord.attributes.job/application/offer.accepted_another_offer')
    end
  end

  context 'method: accept!' do
    it 'should change status to accepted and skip validation' do
      subject = create :job_application_offer, :skip_validation, :old
      subject.accept!

      expect(subject.accepted?).to eq true
      expect(subject.feedback).to eq nil
    end

    it 'and also update feedback' do
      subject = create :job_application_offer, :skip_validation, :old
      feedback = build(:job_application_offer, :with_feedback).feedback
      subject.accept! feedback

      expect(subject.accepted?).to eq true
      expect(subject.feedback).to eq feedback
    end
  end
end
