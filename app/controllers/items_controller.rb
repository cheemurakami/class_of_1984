class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :only => [:new, :edit, :create, :destroy, :update] do
    redirect_to items_path unless current_user && current_user.admin
  end

  def index
    @items = Item.all
    render :index
  end

  def new
    @location = Location.find(params[:location_id])
    @item = @location.items.new
    render :new
  end

  def create
    @location = Location.find(params[:location_id])
  
    @item = @location.items.new(item_params)
    @item.item_photo.attach(params[:item][:item_photo])
    if @item.save
      flash[:notice] = "Item added!"
      redirect_to location_path(@location)
    else
      render :new
    end    
  end

  def edit 
    @item = Item.find(params[:id])
    @location = @item.location
    render :edit
  end

  def show
    @location = Location.find(params[:location_id])
    @item = Item.find(params[:id])
    render :show
  end

  def update
    @item = Item.find(params[:id])
    @item.item_photo.attach(params[:item][:item_photo])
    if @item.update(item_params)
      redirect_to items_path()
    else  
      render :edit
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to items_path
  end

  private
  def item_params
    params.require(:item).permit(:name, :hp_mod, :atk_mod, :user_id, :location_id)
  end

end