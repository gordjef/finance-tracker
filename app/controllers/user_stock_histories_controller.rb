class UserStockHistoriesController < ApplicationController
  
  def create
    #debugger
    @stk_param = params[:id]
    session[:stk_param] = @stk_param
    @stock = Stock.find(@stk_param)
    session[:stock_name] = @stock.name
    session[:stock_ticker] = @stock.ticker
   
    user_stock = UserStock.where(user: current_user, stock: @stock).first
    session[:usr_id] = user_stock.user.id
    session[:stk_id] = user_stock.stock.id
    
    user_stock_history_first = UserStockHistory.where(user: user_stock.user, stock: user_stock.stock).first
    
    if user_stock_history_first.blank?
      @user_stock_histories = UserStockHistory.create(user: user_stock.user, stock: user_stock.stock, date: user_stock.created_at, last_price: @stock.last_price) 
      
    end
    
    new_stock_price = Stock.new_from_lookup(@stock.ticker)
    @user = User.find(user_stock.user.id)
    
    @user_stock_histories = UserStockHistory.create(user: @user, stock: @stock, date: DateTime.current.utc + Time.zone_offset("PDT"), 
      last_price: new_stock_price.last_price) 
    
    redirect_to action: "show", id: 0
  end
  
  def destroy
    #debugger
    user_stock_history = UserStockHistory.find(params[:id])
    user_stock_history.destroy
    
    @usr_id = session[:usr_id]
    @stk_id = session[:stk_id]
    @user = User.find(@usr_id)
    @stock = Stock.find(@stk_id)
    @user_stock_history1 = UserStockHistory.where(user: @user, stock: @stock)
    if @user_stock_history1.count == 1
      flash.now[:notice] = "All history was successfully removed from stock"
      @user_stock_history1.delete_all
      redirect_to my_portfolio_path
    else
      flash[:notice] = "Stock was successfully removed from history"
      redirect_to action: "show", id: 1
    end
    
  end
  
  def show
    #debugger
  
    @stk_param = session[:stk_param]
    @stk_ticker = session[:stock_ticker]
    @stk_id = session[:stk_id]
    @usr_id = session[:usr_id]
  
    @user = User.find(@usr_id)
    @stock = Stock.find(@stk_id)
    
    @user_stock_histories = UserStockHistory.where(user: @user, stock: @stock)
    if params[:id] == "0"
      flash.now[:success] = "#{@stock.name} stock record ##{@user_stock_histories.count-1} was successfully added to history"
    end
  end
  
end
