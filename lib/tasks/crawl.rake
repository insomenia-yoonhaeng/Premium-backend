namespace :crawl do
  desc "TODO"
  task :example, :url, :book do |task, args|
    
    require "selenium-webdriver"
    Selenium::WebDriver::Chrome.driver_path = "/usr/local/bin/chromedriver"
  
    options = Selenium::WebDriver::Chrome::Options.new # 크롬 헤드리스 모드 위해 옵션 설정
    options.add_argument('--disable-extensions')
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    
    # 셀레니움 + 크롬 + 헤드리스 옵션으로 브라우저 실행
    @browser = Selenium::WebDriver.for :chrome, options: options
    
    @browser.navigate().to args[:url]
    
    @content = @browser.find_elements(css: "#tabContent > .tab_body > .info_section > .coll_tit")
    @content.each do |dom|
      if dom.find_element(css: "h3.tit").text == "목차"
        @list_content = dom.find_element(xpath: "..").find_element(css: "p.desc").text
        break
      end
    end

    book = args[:book]

    chapters = []

    @list_content.split("\n") do |chapter|
      chapters << Chapter.new(title: chapter)
    end

    # bulk insert
    book.chapters.import chapters

    @browser.quit
  end
 
end