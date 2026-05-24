module My
  class AccountsController < BaseController
    def show
      @user = Current.user
    end

    def edit
      @user = Current.user
    end

    def update
      @user = Current.user

      if @user.update(account_params)
        redirect_to my_account_path, notice: "Account updated"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def account_params
      params.require(:user).permit(:first_name, :last_name)
    end
  end
end
