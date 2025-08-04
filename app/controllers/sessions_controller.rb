class SessionsController < Devise::SessionsController

  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      sign_in(user)
      render json: { message: 'Logged in successfully', current_user: user }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
