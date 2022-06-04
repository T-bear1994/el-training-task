class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :only_own_tasks, only: [:show, :edit]
  skip_before_action :logout_required

  # GET /tasks or /tasks.json
  def index
    if params[:sort_deadline_on]
      @tasks = current_user.tasks.sort_deadline_on.ordered_by_created_at.page(params[:page]).per(10)
    elsif params[:sort_priority]
      @tasks = current_user.tasks.sort_priority.ordered_by_created_at.page(params[:page]).per(10)
    else
      @search_params = task_search_params
      @tasks = current_user.tasks.search_index(@search_params).ordered_by_created_at.page(params[:page]).per(10)
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: t("notice.create") }
        format.json { head :no_content }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)        
        format.html { redirect_to tasks_path, notice: t("notice.update") }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t("notice.destroy") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
    end

    def task_search_params
      params.fetch(:search, {}).permit(:status, :title)
    end

    def only_own_tasks
      redirect_to tasks_path, flash: {notice: "本人以外アクセスできません"} unless @task.user_id == current_user.id
    end
end