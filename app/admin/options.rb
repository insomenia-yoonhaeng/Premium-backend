ActiveAdmin.register Option do

  menu parent: "프로젝트 관리", priority: 2
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :tutor_id, :chapter_id, :weight, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:tutor_id, :chapter_id, :weight, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
