class GroupsController < ApplicationController
  require 'csv'

  before_action :set_group, only: [:index, :show, :edit, :update, :destroy]


  # GET /groups/1/index
  def index
    @users = @group.users
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @users = @group.users
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /groups/
  def all_groups
    @groups = Group.all
  end

  # GET /meetup_file_import/
  # POST /meetup_file_import/
  def file_upload
    return if request.get?

    file = params[:file]
    @results = []
    @error = nil

    if (file.nil?)
      @error = "Looks like there's no file for us to process :("
      return
    end

    begin
      @results = handle_csv_data(file)
    rescue CSV::MalformedCSVError => e
      @error = e
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name)
    end

    def handle_csv_data(file)
      results = []
      CSV.foreach(file.path,
                  headers: true,
                  converters: :all,
                  header_converters: lambda { |h| h.downcase },
                  encoding:'iso-8859-1:utf-8'
                  ) do |row|
        data = get_csv_data(row)
        records = create_records_from_csv!(data)

        results << {
          user_name: records[:user].full_name,
          group_name: records[:group].name,
          is_group_new: records[:is_group_new],
          role: records[:role].name
        }
      end

      return results
    end

    def get_csv_data(row)
      # downcase all to keep consistent across database
      return {
        user_first_name: row["first name"].downcase,
        user_last_name: row["last name"].downcase,
        group_name: row["group name"].downcase,
        role_name: row["role in group"].downcase
      }
    end

    def create_records_from_csv!(data)
      is_group_new = false

      user = User.create(first_name: data[:user_first_name], last_name: data[:user_last_name])
      role = Role.find_by name: data[:role_name]
      group = Group.find_by name: data[:group_name]
      if (!group)
        group = Group.create(name: data[:group_name])
        is_group_new = true
      end

      group.add_member(user, role)

      return {
        user: user,
        group: group,
        is_group_new: is_group_new,
        role: role
      }
    end
end
