require 'rake'
PremiumBackend::Application.load_tasks

class BooksController < ApiController
  before_action :current_api_user
  before_action :authorize_check_request
  before_action :check_books, only: %i(create update)
  before_action :load_book, except: %i(index create get_list)
  
  def index
    @books = Book.all
    render json: each_serializer(@books, BookSerializer), status: :ok
  end
  
  def create
    begin
      @book = Book.create book_params 
      render json: serializer(@book, BookSerializer) ,status: :ok
    rescue => exception
      render json: {errors: @book&.errors&.full_messages&.first}, status: :bad_request      
    end
  end

  def show
    begin
      render json: serializer(@book, BookSerializer), status: :ok
    rescue => exception
      render json: {errors: @book&.errors&.full_messages.first}, status: :not_found
    end
  end
  
  def update
    begin
      @book.update(book_params)
      render json: { status: :ok }
    rescue => exception
      render json: {errors: @book&.errors&.full_messages.first}, status: :not_found
    end
  end

  def destroy
    begin
      @book.destroy
      render json: { status: :ok }
    rescue => exception
      render json: {errors: @book&.errors&.full_messages.first}, status: :not_found
    end
  end

  def get_list # 목차 가져오기
    # https://sampatbadhe.medium.com/rake-task-invoke-or-execute-419cd689c3bd
    book = Book.find_by(title: params.dig(:book, :title))
    if book.chapters.present?
      render json: serializer(book, BookSerializer), status: :ok
    else
      Rake::Task['crawl:example'].execute(url: params[:url], book: book)
      Rake::Task['crawl:example'].reenable # rake file 한번 만 실행
      render json: serializer(book, BookSerializer), status: :ok
    end
  end

  private 

  def book_params
    params.require(:book).permit(Book::PERMIT_COLUMNS)
  end

  def check_books
    return render json: {result: "이미 책이 존재합니다"}, status: :bad_request if Book.where(title: params.dig(:book,:title)).present?
  end

  def load_book
    @book = Book.find(params[:id])
  end
end
