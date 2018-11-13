require "rails_helper"

describe User do
  it { is_expected.to allow_value("+48 999 888 777").for(:phone_number) }
  it { is_expected.to allow_value("48 999-888-777").for(:phone_number) }
  it { is_expected.to allow_value("48 999-888-777").for(:phone_number) }
  it { is_expected.not_to allow_value("+48 aaa bbb ccc").for(:phone_number) }
  it { is_expected.not_to allow_value("aaa +48 aaa bbb ccc").for(:phone_number) }
  it { is_expected.not_to allow_value("+48 999 888 777\naseasd").for(:phone_number) }

  context '#commented_movie?' do
    subject { create :user }
    let!(:movie) { create :movie }

    it 'returns true when user commented movie' do
      create :comment, user: subject, movie: movie
      expect(subject.commented_movie?(movie)).to eq(true)
    end

    it 'returns false when user did not comment movie' do
      expect(subject.commented_movie?(movie)).to eq(false)
    end
  end

  context '.top_commenters' do
    def top_commenters(period = 1.day)
      User.top_commenters(period)
    end

    let!(:users) { create_list :user, 4 }
    before do
      create_list :comment, 2, user: users[0], created_at: 12.hours.ago
      create_list :comment, 3, user: users[1], created_at: 23.hours.ago
      create_list :comment, 1, user: users[2], created_at: Time.now
    end

    # Order
    it { expect(top_commenters[0]).to eq users[1] }
    it { expect(top_commenters[1]).to eq users[0] }
    it { expect(top_commenters[2]).to eq users[2] }
    it 'does not include users without any comments' do
      expect(top_commenters).to_not include users[3]
    end

    # Period
    it { expect(top_commenters(1.hour)[0]).to eq users[2] }
    it { expect(top_commenters(1.hour).to_a.size).to eq 1 }
  end
end
