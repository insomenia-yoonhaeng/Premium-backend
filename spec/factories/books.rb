FactoryGirl.define do
  factory :book do
    author { "홍성대" }
    content { "- 독자대상 : 고등학교 1학년 및 고등학교 수학 학습자 - 구성 : 개념 정리 + 연습 문제 - 특징 : ① 수학의 기본을 알기 쉽게 정리 ② 새 교육과정에 맞추어 꾸며짐"}
    isbn { "8988399005 9788988399002" }
    publisher { "성지출판" }
    image { "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1271676%3Ftimestamp%3D20190127134651" }
    url { "https://search.daum.net/search?w=bookpage&bookId=1271676&q=%EC%88%98%ED%95%992+%EA%B3%A01%28%EA%B8%B0%EB%B3%B8%ED%8E%B8%29%282017%29%28%EC%88%98%ED%95%99%EC%9D%98+%EC%A0%95%EC%84%9D%29%28%EA%B0%9C%EC%A0%95%ED%8C%90+11%ED%8C%90%29%28%EC%96%91%EC%9E%A5%EB%B3%B8+HardCover%29"}
  end
end
