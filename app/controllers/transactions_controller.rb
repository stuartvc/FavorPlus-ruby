class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :destroy]

  # GET /transactions
  # GET /transactions.json
  def index
    @allTransactions = @current_user.transactions + @current_user.inverse_transactions

    current_page = params.fetch(:page, 1).to_f
    @transactions = @allTransactions.slice((current_page - 1) * WillPaginate.per_page, (current_page * WillPaginate.per_page) - 1) || []
    has_more = @allTransactions.size >= current_page * WillPaginate.per_page

    to_json(@transactions, has_more)
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
    @allTransactions = Transaction.where(:user_id => @current_user.id, :friend_id => params[:friend_id]) +
                    Transaction.where(:user_id => params[:friend_id] , :friend_id =>@current_user.id)

    current_page = params.fetch(:page, 1).to_f
    @transactions = @allTransactions.slice((current_page - 1) * WillPaginate.per_page, (current_page * WillPaginate.per_page) - 1) || []
    has_more = @allTransactions.size >= current_page * WillPaginate.per_page

    to_json(@transactions, has_more)
  end

  private

    def to_json(transactions, has_more)
      render json: {
        transaction_list:  {
          transactions:  ActiveModel::ArraySerializer.new(transactions, each_serializer: TransactionSerializer, root: false),
          has_more: has_more
        }
      }
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:friend_id, :value, :description)
    end
end
