ActiveAdmin.register Category do

  menu parent: "프로젝트 관리", priority: 5
  permit_params :title

end
