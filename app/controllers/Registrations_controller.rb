class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    if resource.save
      sign_in(resource_name, resource)
      render json: { message: 'User registered successfully', user: resource }, status: :created
    else
      render json: { error: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:registration).permit(:name, :email, :password, :city, :state, :description, :skills, :age, :contact_info, :type)
  end
end
