require 'rails_helper'
RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  let(:user) { build(:user) }

  describe "ActiveModel validations" do
    # Basic validations
    it { expect(user).to validate_presence_of(:email_address) }
    it { expect(user).to validate_presence_of(:password_digest) }
    it { expect(user).to validate_presence_of(:first_name) }
    it { expect(user).to validate_presence_of(:last_name) }

    # Format validations
    # Inclusion/acceptance of values
    it { expect(user).to validate_inclusion_of(:attr).in_array([true, false]) }
  end
end
