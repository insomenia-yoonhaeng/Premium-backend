ActiveAdmin.register Book do
  menu parent: "프로젝트 관리", priority: 3
  actions :all, except: %i(new edit create update)
  permit_params :author, :content, :isbn, :publisher, :title, :image, :url

  index do
    selectable_column
    id_column
    column :title
    column :author
    column :isbn
    column :publisher
    actions
  end

  show do 
    attributes_table do
      row "표지 이미지" do |book|
        image_tag(book.image)
      end
      row :title
      row :author
      row :isbn
      row :publisher
      row :content
      row :url
      row :created_at
      row :updated_at
    end
  
  end


  
end
