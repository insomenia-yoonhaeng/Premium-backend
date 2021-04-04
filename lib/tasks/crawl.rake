namespace :crawl do
  desc "TODO"
  task :example,[:path] => [:environment] do |t, args|
    require "selenium-webdriver"
    Selenium::WebDriver::Chrome.driver_path = "/usr/local/bin/chromedriver"
    
    ## 헤드리스 개념 : https://beomi.github.io/2017/09/28/HowToMakeWebCrawler-Headless-Chrome/
    options = Selenium::WebDriver::Chrome::Options.new # 크롬 헤드리스 모드 위해 옵션 설정
    options.add_argument('--disable-extensions')
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    
    # 셀레니움 + 크롬 + 헤드리스 옵션으로 브라우저 실행
    @browser = Selenium::WebDriver.for :chrome, options: options
    
    # 다음 페이지로 이동
    #@browser.navigate().to "https://search.daum.net/search?w=bookpage&bookId=848781&q=%EC%A4%91%ED%95%99+%EC%88%98%ED%95%99+2-1%282021%29%28%EA%B0%9C%EB%85%90%EC%9B%90%EB%A6%AC%29"
    @browser.navigate().to args[:path]
    #@browser.navigate().to "https://search.daum.net/search?w=bookpage&bookId=1271676&q=%EC%88%98%ED%95%992+%EA%B3%A01%28%EA%B8%B0%EB%B3%B8%ED%8E%B8%29%282017%29%28%EC%88%98%ED%95%99%EC%9D%98+%EC%A0%95%EC%84%9D%29%28%EA%B0%9C%EC%A0%95%ED%8C%90+11%ED%8C%90%29%28%EC%96%91%EC%9E%A5%EB%B3%B8+HardCover%29"
    # iframe에서 frame 형으로 전환
    #@browser.switch_to.frame("cafe_main")
    
    ## find_element랑 find_elements의 차이를 꼭 알아두자.
    # https://stackoverflow.com/a/14425080
    @content = @browser.find_elements(css: "#tabContent > .tab_body > .info_section > .coll_tit")
    @content.each do |t|
      if t.find_element(css: "h3.tit").text == "목차"
        @list_content = t.find_element(xpath: "..").find_element(css: "p.desc").text
        break
      end
    #   @title = t.find_element(css: "a.article").text
    #   @nickname = t.find_element(css: "a.m-tcol-c").text
    #   @date = t.find_element(css: "td.td_date").text
    #   @url = t.find_element(tag_name: "a").attribute("href")
    #   ## 서버 로그 확인용
    #   puts "제목 : #{@title} / 닉네임 : #{@nickname} / 작성기간 : #{@date} / URL : #{@url}"
    #   #Market.create(title: @title, nickname: @nickname, date: @date, url: @url)
    end
    @list_content.split("\n") do |lc|
      Book.create(title: lc) unless lc == ""
      #p lc.class
    end
    @browser.quit
  end
 
end