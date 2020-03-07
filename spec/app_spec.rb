require './app/app'
require './app/topic'
require './app/site_setting'
require './app/user'

RSpec.describe App do
  let(:app) { App.new(user) }
  let(:user) { User.new(12345, 0, false, false)}

  subject { app.can_accept_answer?(topic) }

  context 'when unauthenticated' do
    let(:topic) { nil }
    let(:user) { User.new(12345, 0, false, false) }

    it { is_expected.to be_falsey }
  end

  context 'when authenticated' do
    let(:topic) { nil }
    let(:user) { User.new(12345, 0, false, true) }

    context 'when topic is nil' do
      it { is_expected.to be_falsey }
    end

    context 'when answers are not acceptable for this category' do
      let(:topic) { Topic.new(0, :do_not_allow_accepted_answers, false) }

      it { is_expected.to be_falsey }
    end

    context 'when answers are acceptable for this category' do
      let(:topic) { Topic.new(0, :allow_accepted_answers, false) }

      context 'when user is staff' do
        let(:user) { User.new(12345, 0, true, true) }

        it { is_expected.to be_truthy }
      end

      context 'when user trust level is high enough to override' do
        let(:user) { User.new(12345, SiteSetting.accept_all_solutions_trust_level, false, true) }

        it { is_expected.to be_truthy }
      end

      context 'when topic is open but doesn\'t belong to user' do
        let(:topic) { Topic.new(0, :allow_accepted_answers, false) }

        it { is_expected.to be_falsey }
      end

      context 'when topic is closed and belongs to user' do
        let(:topic) { Topic.new(user.id, :allow_accepted_answers, true) }

        it { is_expected.to be_falsey }
      end

      context 'when topic is open and belongs to user' do
        let(:topic) { Topic.new(user.id, :allow_accepted_answers, false) }

        it { is_expected.to be_truthy }
      end
    end
  end
end