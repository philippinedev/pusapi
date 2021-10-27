require 'rails_helper'

RSpec.describe PasswordResetsController, type: :request do
  let(:email) { "john@example.com" }
  let(:token) { "token" }

  # STEP 1 - Accept email
  describe "POST /create" do
    let(:params) do
      {
        email: email,
      }
    end

    before do
      post "/password_reset", params: params
    end

    context "missing email" do
      it "return false" do
        expect(JSON.parse(response.body)).to eq({ "success" => false })
        expect(response).to have_http_status(404)
      end
    end

    context "existing" do
      before :context do
        create(:admin_user, email: "john@example.com")
      end

      it "returns true" do
        expect(JSON.parse(response.body)).to eq({ "success" => true })
        expect(response).to have_http_status(200)
      end
    end
  end

  # STEP 2 - Validate email and token
  describe "GET /show" do
    let(:params) do
      {
        email: email,
        token: token
      }
    end

    before do
      get "/password_reset", params: params
    end

    context "missing email" do
      it "return false" do
        expect(JSON.parse(response.body)).to eq({ "success" => false })
        expect(response).to have_http_status(404)
      end
    end

    context "existing" do
      before :context do
        create(:admin_user, email: "john@example.com").tap do |user|
          user.initiate_reset_password("token")
        end
      end

      it "returns true" do
        expect(JSON.parse(response.body)).to eq({ "success" => true })
        expect(response).to have_http_status(200)
      end
    end
  end

  # describe "PATCH /create" do
  #   let(:password) { "1PA$%abcdefg" }
  #   let(:params) do
  #     {
  #       email: email,
  #       token: token,
  #       password: password
  #     }
  #   end

  #   before do
  #     post "/password_reset", params: params
  #   end

  #   it 'ok' do
  #     expect(JSON.parse(response.body)).to eq({})
  #   end
  # end
end
