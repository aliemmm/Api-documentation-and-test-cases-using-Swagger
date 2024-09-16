class Api::V1::RegistrationsController < Api::ApiController
  before_action :find_user, except: :create

  def create
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      user_json = UserSerializer.new(user).as_json
      success_response('User created successfully', user_json.merge({ token: token }), :created)
    else
      error_response(user.errors.full_messages.uniq, :unprocessable_entity)
    end
  rescue ActiveRecord::RecordInvalid => e
    error_response(e.record.errors.full_messages, status: :unprocessable_entity)
  end

  def forgot_password
    if @user
      success_response('Forgot password link sent on your email successfully', UserSerializer.new(@user))
    else
      error_response('No user found with the provided information', :not_found)
    end
  end

  def reset_password
    if @user&.valid_password?(params[:new_password])
      return error_response("New password can't be the old password", :unprocessable_entity)
    end

    if @user && params[:new_password].present?
      @user.update(password: params[:new_password], password_confirmation: params[:password_confirmation])
      success_response('New password set successfully! You can now log in with the new password!', UserSerializer.new(@user))
    else
      error_response('User not found or new password is not present!', :unprocessable_entity)
    end
  end

  private

  def find_user
    @user = User.find_by(email: params[:email])
  end

  def user_params
    params.require(:registration).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
