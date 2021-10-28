require 'rails_helper'

RSpec.describe PasswordResetsController, type: :request do
  let(:email) { "john@example.com" }
  let(:token) { "token" }
  let(:expected_error) { "Email not found" }
  let(:expected_message) { "Failure" }
  let(:expected_success) { false }
  let(:expected) do
    {
      "error" => expected_error,
      "message" => expected_message,
      "success" => expected_success
    }
  end

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
        expect(JSON.parse(response.body)).to eq expected
        expect(response).to have_http_status(404)
      end
    end

    context "existing" do
      let(:expected_error) { nil }
      let(:expected_message) { "Success" }
      let(:expected_success) { true }

      before :context do
        create(:admin_user, email: "john@example.com")
      end

      it "returns true" do
        expect(JSON.parse(response.body)).to eq expected
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
        expect(JSON.parse(response.body)).to eq expected
        expect(response).to have_http_status(404)
      end
    end

    context "invalid token" do
      let(:expected_error) { "Token is invalid" }
      let(:expected_message) { "Failure" }
      let(:expected_success) { false }

      before :context do
        create(:admin_user, email: "john@example.com").tap do |user|
          user.initiate_reset_password("wrongtoken")
        end
      end

      it "returns true" do
        expect(JSON.parse(response.body)).to eq expected
        expect(response).to have_http_status(401)
      end
    end

    context "existing" do
      let(:expected_error) { nil }
      let(:expected_message) { "Success" }
      let(:expected_success) { true }

      before :context do
        create(:admin_user, email: "john@example.com").tap do |user|
          user.initiate_reset_password("token")
        end
      end

      it "returns true" do
        expect(JSON.parse(response.body)).to eq expected
        expect(response).to have_http_status(200)
      end
    end
  end

  # STEP 3 - Save new password after validating email and token
  describe "PATCH /create" do
    let(:password) { "1PA$%abcdefg" }
    let(:params) do
      {
        email: email,
        token: token,
        password: password
      }
    end

    before do
      patch "/password_reset", params: params
    end

    context "missing email" do
      it "return false" do
        expect(JSON.parse(response.body)).to eq expected
        expect(response).to have_http_status(404)
      end
    end

    context "invalid token" do
      let(:expected_error) { "Token is invalid" }
      let(:expected_message) { "Failure" }
      let(:expected_success) { false }

      before :context do
        create(:admin_user, email: "john@example.com").tap do |user|
          user.initiate_reset_password("wrongtoken")
        end
      end

      it "returns true" do
        expect(JSON.parse(response.body)).to eq expected
        expect(response).to have_http_status(401)
      end
    end

    context "existing" do
      let(:expected_error) { nil }
      let(:expected_message) { "Success" }
      let(:expected_success) { true }

      before :context do
        create(:admin_user, email: "john@example.com").tap do |user|
          user.initiate_reset_password("token")
        end
      end

      it "returns true" do
        expect(JSON.parse(response.body)).to eq expected
        expect(response).to have_http_status(200)
      end
    end
  end
end
