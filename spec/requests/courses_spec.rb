# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/courses' do
  describe 'update' do
    let(:course) { create(:course) }
    let(:user) { create(:user) }

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

    context 'valid request parameters and headers' do
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

    context 'valid request parameters and headers but user does not exist' do
      let(:headers) { { :'X-User-Id' => 'uuuuuuuu-uuuu-uuuu-uuuu-uuuuuuuuuuuu' } }

      before(:each) do
        post "/courses/#{course.id}", params: params, headers: headers
      end

      it 'returns unprocessable entity when user not found' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns user not found error message' do
        expect(json).to eq({ error: "Couldn't find User with 'id'=uuuuuuuu-uuuu-uuuu-uuuu-uuuuuuuuuuuu" })
      end
    end

    context 'user header not provided' do
      let(:headers) { {} }

      before(:each) do
        post "/courses/#{course.id}", params: params, headers: headers
      end

      it 'returns unprocessable entity when user header not provided' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'valid request parameters and headers but course does not exist' do
      before(:each) do
        post "/courses/cccccccc-cccc-cccc-cccc-cccccccccccc", params: params, headers: headers
      end

      it 'returns unprocessable entity when course not found' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'stats diff parameter not provided' do
      let(:params) { {} }

      before(:each) do
        post "/courses/#{course.id}", params: params, headers: headers
      end

      it 'returns bad request when stats diff param missing' do
        expect(response).to have_http_status :bad_request
      end

      it 'returns stats diff param missing error message' do
        expect(json).to eq({ error: "param is missing or the value is empty: stats diff" })
      end
    end

    describe 'show course' do
      context 'valid request parameters and headers' do
        let(:course1) { create(:course) }
        let(:course2) { create(:course) }
        let(:user1) { create(:user) }
        let(:user2) { create(:user) }
        let!(:session1) do
          create(
            :session,
            course: course1,
            user: user1,
            totalModulesStudied: 1,
            averageScore: 10,
            timeStudied: 1
          )
        end
        let!(:session2) do
          create(
            :session,
            course: course1,
            user: user1,
            totalModulesStudied: 2,
            averageScore: 20,
            timeStudied: 2
          )
        end
        let!(:session3) do
          create(
            :session,
            course: course1,
            user: user2,
            totalModulesStudied: 4,
            averageScore: 30,
            timeStudied: 4
          )
        end
        let!(:session4) do
          create(
            :session,
            course: course2,
            user: user1,
            totalModulesStudied: 4,
            averageScore: 30,
            timeStudied: 4
          )
        end

        let(:headers) { { :'X-User-Id' => user1.id } }
        before(:each) do
          get "/courses/#{course1.id}", headers: headers
        end

        it 'returns ok with valid params' do
          expect(response).to have_http_status :ok
        end

        it 'returns total modules studied belonging to user and course' do
          expect(json[:totalModulesStudied]).to eq 3
        end

        it 'returns average score belonging to user and course' do
          expect(json[:averageScore]).to eq 15
        end

        it 'returns total time studied belonging to user and course' do
          expect(json[:totalModulesStudied]).to eq 3
        end
      end

      context 'valid request user does not exist' do
        let(:course) { create(:course) }
        let(:headers) { { :'X-User-Id' => 'uuuuuuuu-uuuu-uuuu-uuuu-uuuuuuuuuuuu' } }

        before(:each) do
          get "/courses/#{course.id}", headers: headers
        end

        it 'returns unprocessable entity when user not found' do
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'user header missing' do
        let(:course) { create(:course) }
        let(:headers) { {} }

        before(:each) do
          get "/courses/#{course.id}", headers: headers
        end

        it 'returns unprocessable entity when user header not present' do
          expect(response).to have_http_status :unprocessable_entity
        end
      end

      context 'valid header but course does not exist' do
        let(:user) { create(:user) }
        let(:headers) { { :'X-User-Id' => user.id } }

        before(:each) do
          get "/courses/cccccccc-cccc-cccc-cccc-cccccccccccc", headers: headers
        end

        it 'returns unprocessable entity when course not found' do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
    describe 'show session' do
      context 'valid request parameters and headers' do
        let(:course) { create(:course) }
        let(:user) { create(:user) }
        let!(:session) do
          create(
            :session,
            course: course,
            user: user,
            totalModulesStudied: 1,
            averageScore: 10,
            timeStudied: 1
          )
        end
        let(:headers) { { :'X-User-Id' => user.id } }

        before(:each) do
          get "/courses/#{course.id}/sessions/#{session.id}", headers: headers
        end

        it 'returns ok with valid params' do
          expect(response).to have_http_status :ok
        end
      end
    end
  end

  def json
    JSON.parse(response.body, symbolize_names: true)
  end
end
