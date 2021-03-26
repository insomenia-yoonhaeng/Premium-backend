ActiveAdmin.register Project do

  menu parent: "프로젝트 관리", priority: 0
  permit_params :tutor_id, :description, :deposit, :image, :experience_period, :title


  index do 
    selectable_column
    id_column
    column "담당 튜터" do |project|
      project.tutor      
    end
    column :title
    column :created_at
    actions
  end


end
