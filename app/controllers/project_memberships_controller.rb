class ProjectMembershipsController < ApplicationController
  def assign_member_with_selected_project_role_to_project
    @project = Project.find_by_id params[:project_id]
    @project_role = ProjectRole.find_by_id params[:project_role_id]
    @employees = current_office.elligible_employees_for_project_role(@project_role)
    
    
    add_breadcrumb "Select Project", 'select_project_for_project_membership_assignment_url'
    set_breadcrumb_for @project, 'select_role_to_assign_employee_url' + "(#{@project.id})", 
          "Select Role"
    set_breadcrumb_for @project, 'assign_member_with_selected_project_role_to_project_url' + "(#{@project_role.id}, #{@project.id})", 
          "Assign Employee"
  end
  
  def create
    @project = Project.find_by_id params[:project_id]
    @decision = params[:membership_decision].to_i
    @project_role = ProjectRole.find_by_id params[:membership_provider]
    @user = User.find_by_id params[:membership_consumer]
    
  
    if @decision == TRUE_CHECK
      @project.add_project_membership( current_user, @user,  @project_role  )
    elsif @decision == FALSE_CHECK
      @project.remove_project_membership(current_user,  @user,  @project_role  )
    end
    
    respond_to do |format|
      format.html {  redirect_to root_url }
      format.js
    end
  end
end
