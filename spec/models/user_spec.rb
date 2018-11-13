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
end
