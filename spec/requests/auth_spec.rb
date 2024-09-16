require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
 # Sign Up Endpoint
  path '/auth/signup' do
    post 'Create User' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'test@gmail.com' },
          first_name: { type: :string, example: 'test' },
          last_name: { type: :string, example: 'user' },
          password: { type: :string, example: '12345678' },
          password_confirmation: { type: :string, example: '12345678' }
        },
        required: ['email', 'first_name', 'last_name', 'password', 'password_confirmation']
      }

      response '201', 'user created' do
        let(:user) { { email: 'test@gmail.com', first_name: 'test', last_name: 'user', password: '12345678', password_confirmation: '12345678' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { email: 'invalid', first_name: 'test' } }
        run_test!
      end
    end
  end

  # Sign In Endpoint
  path '/auth/login' do
    post 'Sign In User' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :session, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'test@gmail.com' },
          password: { type: :string, example: '12345678' }
        },
        required: ['email', 'password']
      }

      response '200', 'user signed in' do
        let(:session) { { email: 'test@gmail.com', password: '12345678' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:session) { { email: 'invalid', password: '1234' } }
        run_test!
      end
    end
  end

  # Sign Out Endpoint
  path '/auth/logout' do
    put 'Sign Out' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :session, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'test@gmail.com' }
        },
        required: ['email']
      }

      response '200', 'user signed out' do
        let(:session) { { email: 'test@gmail.com' } }
        run_test!
      end

      response '404', 'user not found' do
        let(:session) { { email: 'invalid' } }
        run_test!
      end
    end
  end

  # Forgot Password Endpoint
  path '/registrations/forgot_password' do
    post 'Forgot Password' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :forgot_password, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'test@gmail.com' }
        },
        required: ['email']
      }

      response '200', 'password reset instructions sent' do
        let(:forgot_password) { { email: 'test@gmail.com' } }
        run_test!
      end

      response '404', 'user not found' do
        let(:forgot_password) { { email: 'invalid' } }
        run_test!
      end
    end
  end

  # Reset Password Endpoint
  path '/registrations/reset_password' do
    post 'Reset Password' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :reset_password, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'test@gmail.com' },
          new_password: { type: :string, example: 'newpassword123' },
          password_confirmation: { type: :string, example: 'newpassword123' }
        },
        required: ['email', 'new_password', 'password_confirmation']
      }

      response '200', 'password updated successfully' do
        let(:reset_password) { { email: 'test@gmail.com', new_password: 'newpassword123', password_confirmation: 'newpassword123' } }
        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:reset_password) { { email: 'test@gmail.com', new_password: 'newpassword123', password_confirmation: 'wrongconfirmation' } }
        run_test!
      end

      response '404', 'user not found' do
        let(:reset_password) { { email: 'invalid', new_password: 'newpassword123', password_confirmation: 'newpassword123' } }
        run_test!
      end
    end
  end
end
