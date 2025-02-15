RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  let(:user) { build(:user) }

  it "player is not mandatory" do
    user.player = nil
    user.save!
    expect(user.reload.player).to be_nil
  end

  # describe "ActiveModel validations" do
  #   # Basic validations
  #   it { is_expected.to validate_presence_of(:whatever) }
  #   it { expect(user).to validate_presence_of(:email_address) }
  #   it { expect(user).to validate_presence_of(:password_digest) }
  #
  #   # Format validations
  #   # Inclusion/acceptance of values
  #   it { expect(user).to validate_inclusion_of(:attr).in_array([true, false]) }
  # end
end
