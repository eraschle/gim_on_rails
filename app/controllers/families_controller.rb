# frozen_string_literal: true

class FamiliesController < ApplicationController
  before_action :set_family, only: %i[show edit update destroy]

  # GET /families
  # GET /families.json
  def index
    @families = Family.all
  end

  # GET /families/1
  # GET /families/1.json
  def show; end

  # GET /families/new
  def new
    @family = Family.new
  end

  # GET /families/1/edit
  def edit; end

  # POST /families
  # POST /families.json
  def create
    @family = Family.new(family_params)

    respond_to do |format|
      if @family.save
        format.html { redirect_to @family, notice: success('created') }
        format.json { render :show, status: :created, location: @family }
      else
        format.html { render :new }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /families/1
  # PATCH/PUT /families/1.json
  def update
    respond_to do |format|
      if @family.update(family_params)
        format.html { redirect_to @family, notice: success('updated') }
        format.json { render :show, status: :ok, location: @family }
      else
        format.html { render :edit }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /families/1
  # DELETE /families/1.json
  def destroy
    @family.destroy
    respond_to do |format|
      format.html { redirect_to families_url, notice: success('destroyed') }
      format.json { head :no_content }
    end
  end

  private

  def success(verb)
    "Family was successfully #{verb}."
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_family
    @family = Family.find(params[:id])
  end

  # Never trust parameters from the scary Internet,
  # only allow the white list through.
  def family_params
    params.require(:family)
          .permit(:name, :unique_id, :workplane_based,
                  :room_calculation_point, :shared, :always_vertical,
                  :round_dimension, :fitting_type, :library_path)
  end
end
