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

  show do
    attributes_table do
      
      row :title
      row "담당 튜터" do |project|
        project.tutor
      end
      row :created_at
      row :updated_at
      row :image
      row :description
      row "보증금" do |project|
        number_with_delimiter(project.deposit)
      end
    end
  end

end
