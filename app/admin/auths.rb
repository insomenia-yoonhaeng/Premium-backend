ActiveAdmin.register Auth do
  menu parent: "인증 관리", priority: 0
<<<<<<< HEAD
  permit_params :description, :authable_type, :authable_id

  index do
    selectable_column
    id_column
    column "인증 대상 모델" do |auth|
      I18n.t("activerecord.models.#{auth.authable_type.downcase}")
    end
    column "인증 주체" do |auth|
      # 나중에 인증 주체가 여러개로 바뀔 경우는 case when 문으로 각각의 path 설정 필요
      link_to "#{auth.authable_type&.constantize&.find(auth.authable_id)&.name}", admin_user_path(auth.authable_id) if auth.authable_type.constantize.find(auth.authable_id).present?
    end
    column :created_at
=======
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
    
>>>>>>> 7044e9bd4ba341e8111b857cef255418ee72c099
    actions
  end

  show do 
    attributes_table do
<<<<<<< HEAD
      row "인증 이미지" do |auth|
        ul do
          auth.images.each do |image|
            span do 
              image_tag(image.image.url(:small)) if auth.images.present?
            end
          end
        end
      end
      row :description
      row "인증 주체" do |auth|
        # 나중에 인증 주체가 여러개로 바뀔 경우는 case when 문으로 각각의 path 설정 필요
        link_to "#{auth.authable_type&.constantize&.find(auth.authable_id)&.name}", admin_user_path(auth.authable_id) if auth.authable_type.constantize.find(auth.authable_id).present?
      end
    
=======
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
>>>>>>> 7044e9bd4ba341e8111b857cef255418ee72c099
    end
  end
end
