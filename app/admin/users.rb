ActiveAdmin.register User do
  
  menu parent: "사용자 관리", priority: 1
  permit_params :name, :email, :password, :status, :phone, images: []
  
  scope -> { '전체' }, :all
  I18n.t("activerecord.enum.user.status").keys.each do |status|
    scope -> { I18n.t("activerecord.enum.user.status.#{status}") }, status
  end

  batch_action "#{I18n.t("activerecord.attributes.user.status")} 변경", form: {
    "승인 상태": I18n.t("activerecord.enum.user.status").keys
  }, confirm: '정말 해당 작업을 진행하시겠습니까?' do |ids, inputs|
    users = User.find(ids)
    users.update_all!(status: inputs[:status])
    flash[:notice] = '해당 리스트들의 변경을 성공적으로 완료했습니다.'
    redirect_back(fallback_location: collection_path)
  end

  filter :name_cont, label: "이름 검색"
  filter :email_cont, label: "이메일 검색"

  index do
    selectable_column
    id_column
    column "프로필 사진" do |user|
      image_tag user.image.url(:small) ,class: "user-index-image" if user.image.present?
    end
    column :name
    column :email
    column :phone
    column "승인 상태" do |user|
      I18n.t("activerecord.enum.user.status.#{user.status}")
    end
    column :type do |user|
      I18n.t("activerecord.enum.user.type.#{user.type}")
    end
    actions
  end

  show do 
    attributes_table do
      row :name
      row :email
      row :phone
      row :info
      row :likes_count
      row :created_at
      row :updated_at
      
      row "승인 상태" do |user|
        I18n.t("activerecord.enum.user.status.#{user.status}")
      end

      row :image do |user|
        image_tag user.image.url(:small) if user.image.present?
      end

      row "인증 이미지" do |user|
        auth = Auth.find_by(authable_type: "User", authable_id: user.id)
        link_to "유저 인증 이미지 보기", admin_auth_path(auth&.id) if user.type == "Tutor" && auth.present?
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: User.statuses.keys.map{|status| [ I18n.t("activerecord.enum.user.status.#{status}") , status]}
    end
    f.actions
  end

  controller do
    def update
      user = User.find_by(id: params[:id])
      status = I18n.t("activerecord.enum.user.status.#{params.dig(:user, :status)}")
      UserMailer.send_email(user, "관리자가 #{user.name}님의 튜터 자격을 #{status}하였습니다.").deliver
      super
    end
  end

end
