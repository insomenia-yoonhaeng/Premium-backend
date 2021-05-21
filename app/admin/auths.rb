ActiveAdmin.register Auth do
  menu parent: "인증 관리", priority: 0
  actions :all, except: %i(new create edit update)
  
  permit_params :description, :authable_type, :authable_id

  
  index do
    selectable_column
    id_column

    column "인증 대상" do |auth|
      path = auth.authable_type.eql?("Attendance") ? admin_attendance_path(auth.authable_id) : admin_user_path(auth.authable_id)
      link_to "인증 대상 정보 보기", path
    end
    column :description
    column :created_at
    column :updated_at
    
    actions
  end

  show do 
    attributes_table do
      row "인증 대상" do |auth|
        path = auth.authable_type.eql?("Attendance") ? admin_attendance_path(auth.authable_id) : admin_user_path(auth.authable_id)
        link_to "인증 대상 정보 보기", path
      end
      row :authable_type do |auth|
        I18n.t("activerecord.models.#{auth.authable_type.downcase}")
      end
      row :description
      row :created_at
      row :updated_at
      row "인증 이미지" do |auth|
        ul do
          auth.images.each do |image|
            span do 
              image_tag(image.image.url(:small)) if image.present?
            end
          end
        end
      end
    end
  end
end
