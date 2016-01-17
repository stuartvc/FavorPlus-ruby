class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :destroy]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = @current_user.transactions + @current_user.inverse_transactions

    render json: @transactions
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    render json: @transaction
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = @current_user.transactions.build(transaction_params)
    
    if @transaction.save
      render json: @transaction, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy

    head :no_content
  end

  def friendsTransactions
    @transactions = Transaction.where(:user_id => @current_user.id, :friend_id => params[:friend_id]) +
                    Transaction.where(:user_id => params[:friend_id] , :friend_id =>@current_user.id)

    render json: @transactions
  end

  private

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:friend_id, :value, :description)
    end
end
