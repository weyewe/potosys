module DraftsHelper
  def add_default_hidden_create_deadline_for_draft(params)
    if params[:action] != 'assign_deadline_for_draft'
      return  'default-hidden'
    end
  end
end
