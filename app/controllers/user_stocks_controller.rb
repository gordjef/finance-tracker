class UserStocksController < ApplicationController
  def create
    stock = Stock.find_by_ticker(params[:stock_ticker])
    if stock.blank?
      stock = Stock.new_from_lookup(params[:stock_ticker])
      stock.save
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:success] = "Stock #{@user_stock.stock.name} was successfully added to portfolio"
    redirect_to my_portfolio_path
  end
  
  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
  
  def destroy
    #debugger
    @usr_id = session[:usr_id]
    @stk_id = session[:stk_id]
    @user = User.find(@usr_id)
    @stock = Stock.find(@stk_id)
    @user_stock_histories = UserStockHistory.where(user: @user, stock: @stock)
    @user_stock_histories.destroy_all
    
    stock = Stock.find(params[:id])
    @user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    @user_stock.destroy
    flash[:notice] = "Stock was successfully removed from portfolio"
    redirect_to my_portfolio_path
  end
end