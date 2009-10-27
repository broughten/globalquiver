class BlackOutDatesController < ApplicationController

  before_filter :login_required, :except => [:index, :show]


  # GET /black_out_dates
  # GET /black_out_dates.xml
  def index
    @black_out_dates = BlackOutDate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @black_out_dates }
    end
  end

  # GET /black_out_dates/1
  # GET /black_out_dates/1.xml
  def show
    @black_out_date = BlackOutDate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @black_out_date }
    end
  end

  # GET /black_out_dates/new
  # GET /black_out_dates/new.xml
  def new
    @black_out_date = BlackOutDate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @black_out_date }
    end
  end

  # GET /black_out_dates/1/edit
  def edit
    @black_out_date = BlackOutDate.find(params[:id])
  end

  # POST /black_out_dates
  # POST /black_out_dates.xml
  def create
    @black_out_date = BlackOutDate.new(params[:black_out_date])

    respond_to do |format|
      if @black_out_date.save
        flash[:notice] = 'BlackOutDate was successfully created.'
        format.html { redirect_to(@black_out_date) }
        format.xml  { render :xml => @black_out_date, :status => :created, :location => @black_out_date }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @black_out_date.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /black_out_dates/1
  # PUT /black_out_dates/1.xml
  def update
    @black_out_date = BlackOutDate.find(params[:id])

    respond_to do |format|
      if @black_out_date.update_attributes(params[:black_out_date])
        flash[:notice] = 'BlackOutDate was successfully updated.'
        format.html { redirect_to(@black_out_date) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @black_out_date.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /black_out_dates/1
  # DELETE /black_out_dates/1.xml
  def destroy
    @black_out_date = BlackOutDate.find(params[:id])
    @black_out_date.destroy

    respond_to do |format|
      format.html { redirect_to(black_out_dates_url) }
      format.xml  { head :ok }
    end
  end
end
