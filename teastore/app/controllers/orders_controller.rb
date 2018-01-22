class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @teas_menu = Tea.where( is_menu: true )
  end

  # GET /orders/1/edit
  def edit
    @teas_menu = Tea.where( is_menu: true )

    @ordered_teas = []
    @order.teas.each do |tea|
      @ordered_teas << tea
    end

    @order.teas.clear
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new( order_params )

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update( order_params )
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_order
      @order = Order.find( params[ :id ] )
    end

    def order_params
      params.require( :order ).permit( :id, :total_price, :client, teas_attributes: [ :name, :type, :price, :made_in, :steeping_time, :drink_with_milk, :stock_quantity,  :ordered_quantity, :is_menu] )
    end
end
