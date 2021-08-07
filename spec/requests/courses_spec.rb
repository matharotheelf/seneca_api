# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/courses' do

  let(:course) { create(:course) }

  describe 'update' do

    let(:params) do
      { 'stats diff' => {
          sessionId: 'testid',
          totalModulesStudied: 1,
          avarageScore: 1,
          timeStudied: 1
        }
      }
    end

    before(:each) do
      post "/courses/#{course.id}", params: params
    end

    it 'returns created with valid params' do
      expect(response).to have_http_status :created
    end

    it 'creates session' do
      expect(Session.exists?(course: course)).to be_truthy
    end
  end
end
