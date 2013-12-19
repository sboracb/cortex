require 'spec_helper'

describe TenantsController do

  before { log_in }
  before { request.env['HTTP_ACCEPT'] = 'application/json' }

  describe 'GET #index' do
    let(:organization) { create(:organization) }
    before { get :index }

    it 'should return an array of tenants' do
      assigns(:tenants).should =~ organization.self_and_descendants
    end
  end

  describe 'GET #hierarchy' do
    let(:user) { create(:user) }
    let(:organizations) { [create(:organization, user: user), create(:organization, user: user)] }
    before { get :hierarchy }

    it 'should return root tenants (organizations)' do
      assigns(:tenants).should =~ organizations
    end
  end

=begin These need to move to OrganizationsController
  describe 'GET #by_organization' do
    let(:user) { create(:user) }
    let(:organizations) {  [create(:organization, user: user), create(:organization, user: user)] }
    let(:selected_org) { organizations[0] }

    context 'when including root' do
      before { get :by_organization, id: selected_org.id, include_root: true }

      it 'should include organization' do
        assigns(:tenants).should include(selected_org)
      end
    end

    context 'when not including root' do
      before { get :by_organization, id: selected_org.id, include_root: false }

      it 'should not include organization' do
        assigns(:tenants).should_not include(selected_org)
      end
    end
  end

  describe 'GET #hierarchy_by_organization' do
  end
=end

  describe 'GET #show' do
    let(:tenant) { create(:tenant) }
    before { get :show, id: tenant.id }

    it 'should fetch tenant' do
      assigns(:tenant).should eq(tenant)
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
    end

    context 'with invalid attributes' do
    end
  end

  describe 'PUT #update' do

    context 'with valid attributes' do
    end

    context 'with invalid attributes' do
    end
  end

  describe 'DELETE #destroy' do
  end
end