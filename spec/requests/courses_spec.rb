# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/courses' do

  let(:course) { create(:course) }
  let(:user) { create(:user) }

  describe 'update' do

    let(:params) do
      { :'stats diff' => {
          sessionId: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
          totalModulesStudied: 1,
          averageScore: 1,
          timeStudied: 1
        }
      }
    end

    let(:headers) { { :'X-User-Id' => user.id } }

    before(:each) do
      post "/courses/#{course.id}", params: params, headers: headers
    end

    it 'returns created with valid params' do
      expect(response).to have_http_status :created
    end

    it 'creates session belonging to course' do
      expect(Session.exists?(course: course)).to be_truthy
    end

    it 'creates session belonging to user' do
      expect(Session.exists?(user: user)).to be_truthy
    end

    it 'populates session with stats diff data' do
      expect(Session.exists?(
        sessionId: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        totalModulesStudied: 1,
        averageScore: 1,
        timeStudied: 1
      )).to be_truthy
    end
  end
end
