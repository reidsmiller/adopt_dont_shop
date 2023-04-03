require 'rails_helper'

RSpec.describe 'admin shelter show page' do
  describe 'as a visitor, when I visit an admin shelter show page' do
    before(:each) do
      @shelter_1 = Shelter.create!(name: 'Boulder Humane Society', city: 'Boulder', rank: 3)
    end

    it "I can see the shelter's name and full address" do
      visit "/admin/shelters/#{@shelter_1.id}"

      expect(page).to have_content(@shelter_1.name)
      expect(page).to have_content(@shelter_1.city)
      expect(page).to have_content(@shelter_1.rank)

    end
  end
end