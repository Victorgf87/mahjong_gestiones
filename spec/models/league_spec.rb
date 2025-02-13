require 'rails_helper'

RSpec.describe League, type: :model do
  let(:creator){create(:user)}
  let(:league) { create(:league, creator:) }
  let(:players){create_list(:player, 4)}

  it 'is valid' do
    expect(league).to be_valid
  end

  it_behaves_like 'eventable' do
    let(:resource){league}
  end




  # it 'has a name' do
  #   expect(league.name).to eq('MyString')
  # end
  #
  # it 'has many photos' do
  #   expect(league.photos.count).to eq(0)
  # end
end
