ActiveAdmin.register Auth do
  menu parent: "인증 관리", priority: 0
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
    actions
  end

  show do 
    attributes_table do
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
    
    end
  end
end
