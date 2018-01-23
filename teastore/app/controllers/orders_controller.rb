class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @origin_client = Client.find( params[ :client_id ] )
    @orders = Order.where( client_id: params[ :client_id ] )
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @origin_client = Client.find( params[ :client_id ] )
    @order = Order.new
    @order.client = @origin_client

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
    @origin_client = Client.find( params[ :client_id ] )

    @order = Order.new( order_params )
    @order.client = @origin_client

    respond_to do |format|
      if @order.save

        converter = OrderConverter.new
        json = converter.to_json( @order )

        puts "Initiazing Connection with Server......"
        puts "JSON was passed: #{ json }"

        requester = OrderRequester.new
        result = requester.send_order( json )

        puts "Result of NET::HTTP operation: #{ result }"

        format.html { redirect_to client_orders_url( @order.client.id ), notice: 'Order was successfully created.' }
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
        format.html { redirect_to client_orders_url( @order.client.id ), notice: 'Order was successfully updated.' }
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
      format.html { redirect_to client_orders_url( @order.client.id ), notice: 'Order was successfully destroyed.' }
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
