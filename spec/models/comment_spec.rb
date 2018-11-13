require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to_not allow_value(nil).for(:user) }
  it { is_expected.to_not allow_value(nil).for(:movie) }
  it { is_expected.to allow_value('Still a better love story than twilight').for(:content) }
  it { is_expected.to_not allow_value('').for(:content) }

  context '#one_comment_per_user' do
    let!(:user) { create(:user) }
    let!(:movie) { create(:movie) }
    subject { Comment.new(user: user, movie: movie, content: 'Blah') }

    it 'is valid when user did not comment given movie' do
      expect(subject).to be_valid
    end

    it 'is not valid when user already commented given movie' do
      create :comment, user: user, movie: movie
      expect(subject).to_not be_valid
      expect(subject.errors[:movie]).to eq(['was already commented by you'])
    end
  end
end
