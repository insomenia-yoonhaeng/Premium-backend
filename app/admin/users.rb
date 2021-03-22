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
    column :name
    column :email
    # column "사용자 유형" do |user|
    #   I18n.t("activerecord.enum.user.user_type.#{user.user_type}")
    # end
    column :phone
    column "승인 상태" do |user|
      I18n.t("activerecord.enum.user.status.#{user.status}")
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: User.statuses.keys.map{|status| [ I18n.t("activerecord.enum.user.status.#{status}") , status]}
    end
    f.actions
  end
end
