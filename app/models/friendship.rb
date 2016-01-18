class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  def transaction_total
    @transaction_total = 0

    @transactions = Transaction.where(:user_id => user.id, :friend_id => friend.id)
    for transaction in @transactions
    	@transaction_total += transaction.value
    end
    @transactions = Transaction.where(:user_id => friend.id, :friend_id => user.id)
    for transaction in @transactions
    	@transaction_total -= transaction.value
    end
    return @transaction_total
  end
end
