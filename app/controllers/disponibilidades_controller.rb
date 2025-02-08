class DisponibilidadesController < ApplicationController
  before_action :authenticate_user! # Assumindo que você usa Devise para Admin
  before_action :set_disponibilidade, only: [ :show, :edit, :update, :destroy ]
  before_action :set_professionals, only: [ :new, :edit, :create, :update ]

  def index
    @disponibilidades = Disponibilidade.all
  end

  def show
  end

  def new
    @disponibilidade = Disponibilidade.new
    @professionals = User.where(admin: false)
  end

  def edit
  end

  def create
    @disponibilidade = Disponibilidade.new(disponibilidade_params)

    if @disponibilidade.save
      redirect_to @disponibilidade, notice: "Disponibilidade criada com sucesso."
    else
      render :new
    end
  end

  def update
    if @disponibilidade.update(disponibilidade_params)
      redirect_to @disponibilidade, notice: "Disponibilidade atualizada com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @disponibilidade.destroy
    redirect_to disponibilidades_url, notice: "Disponibilidade excluída com sucesso."
  end

  private

  def set_professionals
    @professionals = User.all
  end

  private
    def set_disponibilidade
      @disponibilidade = Disponibilidade.find(params[:id])
    end

    def disponibilidade_params
      params.require(:disponibilidade).permit(:user_id, :data, :horario)
    end
end
