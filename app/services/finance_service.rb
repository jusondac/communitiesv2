# frozen_string_literal: true

class FinanceService
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :user
  attribute :amount, :decimal
  attribute :recipient
  attribute :category, :string, default: "transfer"

  validates :user, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :category, inclusion: { in: %w[transfer donation service] }

  def initialize(attributes = {})
    super
    @errors = ActiveModel::Errors.new(self)
  end

  # Create a finance account for a user
  def self.create_finance_account(user, initial_balance: 1000)
    return { success: false, error: "User not found" } unless user
    finance = Finance.create!(balance: 100, is_community: false, name: user.username)
    user.update(finance: finance)

    # Check if user already has a finance account
    return { success: false, error: "User already has a finance account" } if user.finance.present?
    if finance.persisted?
      { success: true, finance: finance, message: "Finance account created with $#{initial_balance} starting balance!" }
    else
      { success: false, error: "Failed to create finance account" }
    end
  end

  # Send money between users or to communities
  def self.send_money(user, params)
    # service = new(user: payer, amount: amount, category: category)
    # return { success: false, errors: service.errors.full_messages } unless service.valid?

    return { success: false, error: "User not found" } unless user
    return { success: false, error: "Amount must be positive" } if params[:amount].to_i <= 0
    return { success: false, error: "Receiver ID is required" } if params[:receiver_id].blank?

    # Check if user has a finance account
    payer = user.finance
    return { success: false, error: "No finance account found" } unless payer


    is_community = params[:is_community].to_i
    amount = params[:amount].to_i
    receiver = is_community==1 ? Community.find_by(id: params[:receiver_id]).finance : User.find_by(id: params[:receiver_id])&.finance
    category = 0
    status = 1
    payment_method = PaymentMethod.find_by(name: "App") || PaymentMethod.first

    return { success: false, error: "The fuck bro, more work, your Balance it's too small" } if payer.balance < amount

    ActiveRecord::Base.transaction do
      update_balance(payer, receiver, amount)
      Payment.create!(
        payer: payer,
        receiver: receiver,
        amount: amount,
        category: category,
        status: status,
        payment_method: payment_method,
        )
    end
  # return { success: false, error: "Insufficient Balance" } unless payer_finance.balance >= amount
  { success: true, message: "Money sent successfully" }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message }
  rescue StandardError => e
    { success: false, error: "An unexpected error occurred: #{e}" }
  end

  def self.update_balance(payer_finance, receiver_finance, amount)
    payer_finance.update!(balance: payer_finance.balance - amount) if payer_finance
    receiver_finance.update!(balance: receiver_finance.balance + amount) if receiver_finance
  end

  # Get user's transaction history
  def self.get_transaction_history(user, limit: 10)
    transactions = PaymentTransaction.includes(:user, :community)
                                   .where(user: user)
                                   .order(created_at: :desc)
                                   .limit(limit)

    {
      success: true,
      transactions: transactions,
      total_count: PaymentTransaction.where(user: user).count
    }
  end

  # Get user's balance
  def self.get_balance(user)
    finance = user.finance
    return { success: false, error: "No finance account found" } unless finance

    { success: true, balance: finance.balance }
  end

  # Top up user's balance (user-initiated)
  def self.top_up_balance(user, amount)
    return { success: false, error: "Amount must be positive" } if amount <= 0
    return { success: false, error: "Minimum top-up amount is $10" } if amount < 10

    finance = user.finance
    return { success: false, error: "No finance account found" } unless finance

    ActiveRecord::Base.transaction do
      old_balance = finance.balance
      finance.update!(balance: finance.balance + amount)

      # Create a top-up payment record for tracking
      Payment.create!(
        payer_id: nil, # External top-up
        receiver_id: user.id,
        amount: amount,
        category: "top_up",
        status: "completed"
      )

      # Create transaction record
      PaymentTransaction.create!(
        user: user,
        community_id: nil,
        is_community: false
      )

      {
        success: true,
        old_balance: old_balance,
        new_balance: finance.balance,
        message: "Successfully topped up $#{amount}! Your new balance is $#{finance.balance}."
      }
    end
  rescue StandardError => e
    { success: false, error: e.message }
  end

  # Add funds to user account (for admin or system operations)
  def self.add_funds(user, amount, reason: "System credit")
    return { success: false, error: "Amount must be positive" } if amount <= 0

    finance = user.finance || user.create_finance(balance: 0)

    ActiveRecord::Base.transaction do
      finance.update!(balance: finance.balance + amount)

      # Create a system payment record for tracking
      Payment.create!(
        payer_id: nil, # System credit
        receiver_id: user.id,
        amount: amount,
        category: "system_credit",
        status: "completed"
      )

      { success: true, new_balance: finance.balance, message: "Added $#{amount} to account" }
    end
  rescue StandardError => e
    { success: false, error: e.message }
  end

  # Deduct funds from user account (for admin or system operations)
  def self.deduct_funds(user, amount, reason: "System deduction")
    return { success: false, error: "Amount must be positive" } if amount <= 0

    finance = user.finance
    return { success: false, error: "No finance account found" } unless finance
    return { success: false, error: "Insufficient balance" } if finance.balance < amount

    ActiveRecord::Base.transaction do
      finance.update!(balance: finance.balance - amount)

      # Create a system payment record for tracking
      Payment.create!(
        payer_id: user.id,
        receiver_id: nil, # System deduction
        amount: amount,
        category: "system_deduction",
        status: "completed"
      )

      { success: true, new_balance: finance.balance, message: "Deducted $#{amount} from account" }
    end
  rescue StandardError => e
    { success: false, error: e.message }
  end

  # Transfer funds between users with detailed validation
  def self.transfer_funds(from_user:, to_user:, amount:, category: "transfer")
    return { success: false, error: "Cannot transfer to yourself" } if from_user.id == to_user.id
    return { success: false, error: "Amount must be positive" } if amount <= 0

    from_finance = from_user.finance
    return { success: false, error: "Sender has no finance account" } unless from_finance
    return { success: false, error: "Insufficient balance" } if from_finance.balance < amount

    ActiveRecord::Base.transaction do
      # Deduct from sender
      from_finance.update!(balance: from_finance.balance - amount)

      # Add to receiver (create account if needed)
      to_finance = to_user.finance || to_user.create_finance(balance: 0)
      to_finance.update!(balance: to_finance.balance + amount)

      # Create payment record
      payment = Payment.create!(
        payer_id: from_user.id,
        receiver_id: to_user.id,
        amount: amount,
        category: category,
        status: "completed"
      )

      # Create transaction records for both users
      PaymentTransaction.create!(
        user: from_user,
        community_id: nil,
        is_community: false
      )

      {
        success: true,
        payment: payment,
        from_balance: from_finance.balance,
        to_balance: to_finance.balance,
        message: "Successfully transferred $#{amount} to #{to_user.email_address}"
      }
    end
  rescue StandardError => e
    { success: false, error: e.message }
  end

  private

  def update_balances(payer_finance, receiver_id, amount, is_community)
    # Deduct from sender's balance
    payer_finance.update!(balance: payer_finance.balance - amount)

    # Add to receiver's balance (if user, not community)
    unless is_community
      receiver = User.find(receiver_id)
      receiver_finance = receiver.finance || receiver.create_finance(balance: 0)
      receiver_finance.update!(balance: receiver_finance.balance + amount)
    end
  end
end
