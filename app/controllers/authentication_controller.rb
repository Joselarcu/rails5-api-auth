class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      # current_user = User.find_by email: params[:email]
      current_user = User.select("id","name","surname","username","email").where(["email = ?", params[:email]])
      render json: { auth_token: command.result, user:  current_user}
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end