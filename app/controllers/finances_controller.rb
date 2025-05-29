class FinancesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_finance = current_user.finance
    @payments = Payment.for_current_user.includes(:payer, :receiver, :payment_method)
    # Get payment history (sent and received) for better transaction display

    @communities = Community.all
    @users = User.where.not(id: current_user.id).with_finance
  end

  def create_finance
    result = FinanceService.create_finance_account(current_user, initial_balance: 1000)

    if result[:success]
      redirect_to finances_path, notice: result[:message]
    else
      redirect_to finances_path, alert: result[:error]
    end
  end

  def send_money
    result = FinanceService.send_money(Current.user, params)
    if result[:success]
      redirect_to finances_path, notice: result[:message]
    else
      error_message = result[:error] || result[:errors]&.join(", ")
      redirect_to finances_path, alert: error_message
    end
  end

  def top_up
    amount = params[:amount].to_f

    if amount < 10
      redirect_to finances_path, alert: "Minimum top-up amount is $10"
      return
    end

    result = FinanceService.top_up_balance(current_user, amount)

    if result[:success]
      redirect_to finances_path, notice: result[:message]
    else
      redirect_to finances_path, alert: result[:error]
    end
  end

  private

  def authenticate_user!
    redirect_to new_session_path unless Current.user
  end

  def current_user
    Current.user
  end
end
