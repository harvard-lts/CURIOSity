# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

describe Spotlight::Ability, type: :model do
  subject { Ability.new(user) }

  let(:user) { FactoryBot.create(:user) }
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:search) { FactoryBot.create(:published_search, exhibit: exhibit) }
  let(:unpublished_search) { FactoryBot.create(:search, exhibit: exhibit) }
  let(:page) { FactoryBot.create(:feature_page, exhibit: exhibit) }
  let(:language) { FactoryBot.create(:language, exhibit: exhibit) }
  let(:public_language) { FactoryBot.create(:language, exhibit: exhibit, public: true) }
  let(:translation) { FactoryBot.create(:translation, exhibit: exhibit) }

  describe 'a superadmin with an exhibit admin mask' do
    let(:masked_role) { FactoryBot.create(:site_admin_exhibit_admin_mask) }
    let(:role) { FactoryBot.create(:role, resource: exhibit) }
    let(:blacklight_config) { exhibit.blacklight_configuration }
    
    it { is_expected.to be_able_to(:update, exhibit) }

    it { is_expected.to be_able_to(:index, role) }
    it { is_expected.to be_able_to(:destroy, role) }
    it { is_expected.to be_able_to(:update, role) }
    it { is_expected.to be_able_to(:create, Spotlight::Role) }
    it { is_expected.to be_able_to(:import, exhibit) }
    it { is_expected.to be_able_to(:process_import, exhibit) }
    it { is_expected.to be_able_to(:destroy, exhibit) }
    it { is_expected.to be_able_to(:manage, language) }
  end
 
  describe 'a superadmin with curate mask' do
    let(:masked_role) { FactoryBot.create(:site_admin_curator_mask) }
    let(:contact) { FactoryBot.build_stubbed(:contact, exhibit: exhibit) }
    let(:blacklight_config) { exhibit.blacklight_configuration }

    it { is_expected.to be_able_to(:curate, exhibit) }
    it { is_expected.to be_able_to(:read, exhibit) }

    it { is_expected.to be_able_to(:create, Spotlight::Search) }
    it { is_expected.to be_able_to(:update_all, Spotlight::Search) }
    it { is_expected.to be_able_to(:update, search) }
    it { is_expected.to be_able_to(:destroy, search) }

    it { is_expected.to be_able_to(:create, Spotlight::Page) }
    it { is_expected.to be_able_to(:update_all, Spotlight::Page) }
    it { is_expected.to be_able_to(:update, page) }
    it { is_expected.to be_able_to(:destroy, page) }

    it { is_expected.to be_able_to(:create, Translation) }
    it { is_expected.to be_able_to(:update_all, Translation) }
    it { is_expected.to be_able_to(:update, translation) }
    it { is_expected.to be_able_to(:destroy, translation) }

    it { is_expected.to be_able_to(:tag, exhibit) }

    it { is_expected.to be_able_to(:edit, contact) }
    it { is_expected.to be_able_to(:new, contact) }
    it { is_expected.to be_able_to(:create, contact) }
    it { is_expected.to be_able_to(:destroy, contact) }
    it { is_expected.to be_able_to(:read, language) }
  end 
end