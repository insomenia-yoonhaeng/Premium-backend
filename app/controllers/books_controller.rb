require 'rake'
PremiumBackend::Application.load_tasks

class BooksController < ApiController
  before_action :authorize_request
  before_action :check_books, only: %i(create update)

  def index
    @books = Book.all
  end
  
  def create
    begin
      @book = Book.create book_params 
      render json: serializer(@book, BookSerializer,[:id, :title, :image]) ,status: :ok
    rescue => exception
      render json: {errors: @book&.errors&.full_messages&.first}, status: :bad_request      
    end
  end
  
  def update;end

  def get_list # 목차 가져오기
    # https://sampatbadhe.medium.com/rake-task-invoke-or-execute-419cd689c3bd
    if @book ||= Book.find_by(title: params.dig(:book, :title))
      puts @book
      render json: serializer(@book, BookSerializer), status: :ok 
    else
      path = "https://search.daum.net/search?w=bookpage&bookId=848781&q=%EC%A4%91%ED%95%99+%EC%88%98%ED%95%99+2-1%282021%29%28%EA%B0%9C%EB%85%90%EC%9B%90%EB%A6%AC%29"
      # parameter 감쌀 때 book: {title: "fdsafdsfads", url: "dfdsafdasfdas"} 으로 요청하기
      Rake::Task['crawl:example'].execute(url: path, book: Book.find(11))
      render json: serializer(Book.find(11), BookSerializer), status: :ok
    end
  end

  private 

  def book_params
    params.require(:book).permit(Book::PERMIT_COLUMNS)
  end

  def check_books
    return render json: {result: "이미 책이 존재합니다"}, status: :bad_request if Book.where(title: params.dig(:book,:title)).present?
  end
end
