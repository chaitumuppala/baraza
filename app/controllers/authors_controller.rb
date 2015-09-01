class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]
  before_action :new_author_from_params, only: [:create]

  # GET /authors
  # GET /authors.json
  def index
    @authors = Author.all
  end

  # GET /authors/1
  # GET /authors/1.json
  def show
  end

  # GET /authors/new
  def new
  end

  # GET /authors/1/edit
  def edit
  end

  # POST /authors
  # POST /authors.json
  def create
    respond_to do |format|
      if @author.save
        format.html { redirect_to authors_path, notice: 'Author was successfully created.' }
        format.json { render json: true }
      else
        format.html { render :new }
        format.json { render json: @author.errors.full_messages.to_sentence, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authors/1
  # PATCH/PUT /authors/1.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to authors_path, notice: 'Author was successfully updated.' }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit }
        format.json { render json: @author.errors.full_messages.to_sentence, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_author
    @author = Author.find(params[:id])
  end

  def new_author_from_params
    @author = params[:author] ? Author.new(author_params) : Author.new
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def author_params
    params.require(:author).permit(:full_name, :email)
  end
end
