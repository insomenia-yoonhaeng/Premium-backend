ActiveAdmin.register Attendance do
  menu parent: "프로젝트 관리", priority: 1
  actions :all, except: %i(new create edit update)
  permit_params :project_id, :tutee_id, :status

  scope -> { '전체' }, :all
  I18n.t("activerecord.enum.attendance.status").keys.each do |status|
    scope -> { I18n.t("activerecord.enum.attendance.status.#{status}") }, status
  end

  index do
    selectable_column
    id_column
    column "프로젝트 이름" do |attendance|
      link_to "#{attendance&.project&.title}", admin_project_path(attendance&.project&.id) rescue ""
    end
    column "참여 튜티" do |attendance|
      link_to "#{attendance&.tutee&.name}", admin_user_path(attendance&.tutee.id) rescue ""
    end
    column "프로젝트 참여 상태" do |attendance|
      I18n.t("activerecord.enum.attendance.status.#{attendance.status}") rescue ""
    end
    column "인증 목록 보기" do |attendance|
      link_to "인증 목록 보기", admin_auths_path({q: {authable_type_eq: "Attendance", authable_id_eq: attendance.id}})
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row "프로젝트 이름" do |attendance|
        link_to "#{attendance&.project&.title}", admin_project_path(attendance&.project&.id) rescue ""
      end
      row "참여 튜티" do |attendance|
        link_to "#{attendance.tutee&.name}", admin_user_path(attendance&.tutee&.id) rescue ""
      end
      row "프로젝트 참여 상태" do |attendance|
        I18n.t("activerecord.enum.attendance.status.#{attendance.status}") rescue ""
      end
      row "인증 목록 보기" do |attendance|
        link_to "인증 목록 보기", admin_auths_path({q: {authable_type_eq: "Attendance", authable_id_eq: attendance.id}})
      end
      row :created_at
      row :updated_at
    end

  end


  
end
