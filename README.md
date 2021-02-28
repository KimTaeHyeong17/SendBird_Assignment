# SendBird_Assignment - master branch
샌드버드 과제

- 오픈소스 사용금지
- UINavigationController & UIViewController 사용 (SwiftUI 사용X)
- image cache 구현
- HTTP protocol 상황별 핸들링
- Search 부분이 첫 화면
- 검색 결과로 나타낸 책 중 하나를 선택하면 Detail View 로 넘어감
- Search 부터 하고 Detail 순으로 작업 요망 (덜해도 한 부분까지 제출)
- 애플의 기본 Music App 의 UI 참고
- API book store 사용
- Git 이나 email 로 작업물 제출

### Search ViewController
- [x] 검색창에 키워드 입력
- [x] 키워드 검색에 대한 결과 표시
- [x] 준수한 UI
- [x] 응답에 있는 모든 정보 표시
- [ ] 코드로 UI를 짜면 가산점 있음
- [x] 검색결과를 캐싱해야함 (이미지도 별도로)

### Detail ViewController
- [x] 리스트에서 선택된 책의 모든 detail 을 보여줌
- [x] 유저가 메모를 적을 수 있게 해야함
- [x] 책의 url 을 하이퍼링크 달아야함

### 가산점
- [ ] 테스팅 (TDD)
- [ ] 코드로 UI 짜기


### TODO
#### 2/15 월
- [x] 프로젝트 세팅
- [x] 검색창에 키워드 입력
- [x] 키워드 검색에 대한 결과 표시
- [x] 응답에 있는 모든 정보 표시
- [x] 네트워킹 파트 구현
- [x] Book API 연동
- [x] URL이미지 다운 및 캐싱
#### 2/16 화
- [x] 리스트에서 선택된 책의 모든 detail 을 보여줌
- [x] Pagination to search result
- [x] caches search result

#### 2/17 수
- [x] 링크 표시하기
- [x] 책 메모 저장 (UserDefaults)
- [x] 점수 별점으로 바꾸기

#### 2/18 목
- [x] fast scrolling causes book image to flickering fix
- [x] Combine + MVVM 적용 

#### 2/19 금
- [x] 이미지 디스크 캐싱 레이어 추가(file manager)

#### 2/20 토
- [x] 검색결과 디스크 캐싱 (using coredata)


#### 2/21 일
- [x] 버그픽스
- [x] 로딩 전 이미지 placeholder


#### 2/22 월
- [x] 코드정리
- [x] 제출



### bugs
- [x] keyboard hides the memo textview (bookDetail)
- [x] fast scrolling causes book image to flick (cache에 있어도 image fetch 했었음)
- [x] Book API maximum page is 100 (result 4500개 있어도 한장당 10개 결과 최대 100페이지까지만 되고 101페이지 호출하면 1페이지 리턴함)
- [x] (after adding core data) blank cell appear sometimes (check blank cell)
- [x] sometimes there are more results to load but scroll stop (change pagination method)
- [x] (after adding core data) first page 10 element duplication in tableview (completion block was in loop and no return or break was specified, )
- [x] 검색어에 띄워쓰기 있으면 url 생성에서 에러난다.(percentEncoding)
- [x] 가끔 같은 page duplication이 생긴다. (disk cache bug) (2월28일 완료)
    - searchbar 에서 입력이 있을경우 0.3 딜레이를 주면서 keyword를 모은 후 api request를 던지는데 입력 속도에 따라 리쿼스트가 많아져서 이전 요청 응답이 중복 쌓이는 건가? (request cancel 구현?)
    - disk, memory, url 에서 받아오는 데이터 사이 타이밍 문제? (completion handler 말고 combine?)



### 개선해야 하는 것
- [ ] 캐싱 데이터 바뀌었을 경우 E-Tag등 활용해 update 해야함
- [x] core data 에서 fetching 할때 keyword와 page 찾는 로직 (2월28일 완료)
- [ ] 화면에 표시되고 있는 이미지 부터 로딩


### 제출 이후 trouble shooting
1. duplication 문제의 원인이 무엇인가 (기능 disable 해서 원인파악)
    - disk cache + memory cache + fetch from url (중복 발생)
    - memory cache + fetch from url (중복 발생X)
    - fetch from url (중복 발생X)

2. disk cache 에서 문제가 발생하면 어느 step 에서 문제가 발생할까
    - saving to disk step


```
    Java fetch request page 1
     Java fetch request page 1
2021-02-28 20:17:51.772085+0900 SendbirdAssignment_TaeHyeongKim[29244:458183] [] nw_protocol_get_quic_image_block_invoke dlopen libquic failed
Sams Teach Yourself Java in 24 Hours, 8th Edition
Java Cookbook, 2nd Edition
Expert Oracle and Java Security
JavaScript: The Good Parts
Pro Java ME Apps
Sams Teach Yourself Java in 24 Hours, 6th Edition
Effective JavaScript
JavaScript Creativity
Learning JavaScript
Head First JavaScript
     Java fetch request page 3
     Java fetch request page 3
Java Cookbook, 2nd Edition
Sams Teach Yourself Java in 24 Hours, 8th Edition
Effective JavaScript
Sams Teach Yourself Java in 24 Hours, 6th Edition
Pro Java ME Apps
Head First JavaScript
Learning JavaScript
JavaScript Creativity
JavaScript: The Good Parts
Expert Oracle and Java Security
JavaScript: The Good Parts
Java Design Patterns
Head First JavaScript
JavaScript Creativity
Exploring Java 9
Practical JSF in Java EE 8
The Definitive Guide to JSF in Java EE 8
Java 7 Pocket Guide, 2nd Edition
Java Cookbook, 2nd Edition
Pro Java ME Apps
Learning JavaScript
Sams Teach Yourself Java in 24 Hours, 8th Edition
Learn JavaFX 8
Expert Oracle and Java Security
Sams Teach Yourself Java in 24 Hours, 6th Edition
Scripting in Java
Pro JavaFX 9
JavaScript Testing with Jasmine
Effective JavaScript
JavaMail API
     Java fetch request page 5
     Java fetch request page 5
Learn JavaFX 8
Expert Oracle and Java Security
Learning JavaScript
Effective JavaScript
Java 7 Pocket Guide, 2nd Edition
JavaScript Testing with Jasmine
Pro Java ME Apps
The Definitive Guide to JSF in Java EE 8
JavaScript Creativity
Scripting in Java
Head First JavaScript
Java Cookbook, 2nd Edition
Sams Teach Yourself Java in 24 Hours, 8th Edition
Exploring Java 9
Practical JSF in Java EE 8
JavaScript: The Good Parts
JavaMail API
Pro JavaFX 9
Java Design Patterns
Sams Teach Yourself Java in 24 Hours, 6th Edition
The Well-Grounded Java Developer
Pro JavaFX 9
Java 7 Pocket Guide, 2nd Edition
JavaScript Creativity
Java Design Patterns
The Definitive Guide to JSF in Java EE 8
Simplifying JavaScript
Java by Comparison
Learning JavaScript
Functional Programming in Java
Java Cookbook, 2nd Edition
Head First JavaScript
Java Cookbook, 4th Edition
Modern Java Recipes
Effective JavaScript
Sams Teach Yourself Java in 24 Hours, 8th Edition
Java Performance, 2nd Edition
JavaScript Testing with Jasmine
Sams Teach Yourself Java in 24 Hours, 6th Edition
JavaMail API
Learning Java, 5th Edition
Practical Modern JavaScript
Expert Oracle and Java Security
Pro Java ME Apps
Java Pocket Guide, 4th Edition
Exploring Java 9
Learn JavaFX 8
JavaScript: The Good Parts
Scripting in Java
Practical JSF in Java EE 8
     Java fetch request page 7
     Java fetch request page 7
Learn JavaFX 8
Modern Java Recipes
Simplifying JavaScript
Sams Teach Yourself Java in 24 Hours, 6th Edition
The Definitive Guide to JSF in Java EE 8
Effective JavaScript
Java Cookbook, 2nd Edition
JavaMail API
Practical Modern JavaScript
JavaScript Creativity
Learning JavaScript
Java Performance, 2nd Edition
The Well-Grounded Java Developer
Functional Programming in Java
JavaScript: The Good Parts
Java Cookbook, 4th Edition
Java Pocket Guide, 4th Edition
Scripting in Java
Pro Java ME Apps
Pro JavaFX 9
Learning Java, 5th Edition
Expert Oracle and Java Security
Java 7 Pocket Guide, 2nd Edition
Exploring Java 9
Head First JavaScript
Practical JSF in Java EE 8
Sams Teach Yourself Java in 24 Hours, 8th Edition
JavaScript Testing with Jasmine
Java by Comparison
Java Design Patterns
Java Cookbook, 2nd Edition
Practical JSF in Java EE 8
JavaScript Creativity
Sams Teach Yourself Java in 24 Hours, 6th Edition
Pro JavaFX 9
Learning Behavior-driven Development with JavaScript
Scripting in Java
Java Cookbook, 4th Edition
JavaScript Security
Simplifying JavaScript
Modern Java Recipes
The Definitive Guide to JSF in Java EE 8
Head First JavaScript
Exploring Java 9
Pro Java ME Apps
Mastering JavaScript High Performance
Effective JavaScript
Java 7 Pocket Guide, 2nd Edition
Learning Java, 5th Edition
JavaMail API
Sams Teach Yourself Java in 24 Hours, 8th Edition
Mastering JavaScript Design Patterns
Learn JavaFX 8
Java Design Patterns
Functional Programming in Java
Natural Language Processing with Java
The Well-Grounded Java Developer
JavaScript: The Good Parts
Java Pocket Guide, 4th Edition
Java Performance, 2nd Edition
Learning JavaScript
Test-Driven Java Development
Java by Comparison
Practical Modern JavaScript
Mastering JavaScript
Functional Programming in JavaScript
Expert Oracle and Java Security
JavaScript Testing with Jasmine
Learning Java by Building Android Games
MongoDB for Java Developers

```
 - loading from disk step

```
     Book fetch request page 1
get from disk       1
2021-02-28 20:19:51.400106+0900 SendbirdAssignment_TaeHyeongKim[29383:460637] [] nw_protocol_get_quic_image_block_invoke dlopen libquic failed
     Book fetch request page 2
     Book fetch request page 2
The Social Media Marketing Book
Linux All-In-One For Dummies, 6th Edition
EPUB 3 Best Practices
PHP & MySQL: The Missing Manual, 2nd Edition
The Little Book on CoffeeScript
Canon EOS Rebel T7/2000D For Dummies
HTML5: The Missing Manual
Google+: The Missing Manual
Adobe Edge Animate Preview 7: The Missing Manual
Adobe Edge Preview 5: The Missing Manual
     Book fetch request page 4
     Book fetch request page 4
The Little Book on CoffeeScript
Adobe Edge Animate Preview 7: The Missing Manual
Linux All-In-One For Dummies, 6th Edition
Adobe Edge Preview 5: The Missing Manual
Canon EOS Rebel T7/2000D For Dummies
HTML5: The Missing Manual
The Social Media Marketing Book
PHP & MySQL: The Missing Manual, 2nd Edition
Google+: The Missing Manual
EPUB 3 Best Practices
PHP & MySQL: The Missing Manual, 2nd Edition
HTML5: The Missing Manual
The Book of CSS3
EPUB 3 Best Practices
Adobe Edge Animate Preview 7: The Missing Manual
The Book of F#
The Social Media Marketing Book
The Book of Xen
Adobe Edge Preview 5: The Missing Manual
The Book of Ruby
The LEGO MINDSTORMS EV3 Idea Book
The Book of PF, 3rd Edition
Linux All-In-One For Dummies, 6th Edition
The Little Book on CoffeeScript
The Book of CSS3, 2nd Edition
The Book of Qt 4
The Book of IMAP
Canon EOS Rebel T7/2000D For Dummies
The Book of PF, 2nd Edition
Google+: The Missing Manual
     Book fetch request page 6
     Book fetch request page 6
EPUB 3 Best Practices
HTML5: The Missing Manual
The Book of PF, 3rd Edition
The Book of PF, 2nd Edition
The Book of Qt 4
Linux All-In-One For Dummies, 6th Edition
The Book of Ruby
The Book of F#
Adobe Edge Preview 5: The Missing Manual
The Book of Xen
The Little Book on CoffeeScript
Canon EOS Rebel T7/2000D For Dummies
The Book of IMAP
The Social Media Marketing Book
Google+: The Missing Manual
The Book of CSS3
PHP & MySQL: The Missing Manual, 2nd Edition
The Book of CSS3, 2nd Edition
The LEGO MINDSTORMS EV3 Idea Book
Adobe Edge Animate Preview 7: The Missing Manual
Linux All-In-One For Dummies, 6th Edition
Fundamentals of Python Programming
Mastering Swift 2
Learning Objective-C by Developing iPhone Games
The LEGO MINDSTORMS EV3 Idea Book
LaTeX: Beginner's Guide
The Book of IMAP
The Social Media Marketing Book
WCF 4.0 Multi-tier Services Development with LINQ to Entities
The Book of PF, 3rd Edition
The Book of CSS3, 2nd Edition
The Cucumber for Java Book
Do more with SOA Integration: Best of Packt
The Book of Ruby
Adobe Edge Preview 5: The Missing Manual
The Book of PF, 2nd Edition
The RSpec Book
The Book of Xen
The Little Book on CoffeeScript
EPUB 3 Best Practices
PHP & MySQL: The Missing Manual, 2nd Edition
Adobe Edge Animate Preview 7: The Missing Manual
Fundamentals of C++ Programming
The Book of Qt 4
The Book of CSS3
The dRuby Book
The Book of F#
HTML5: The Missing Manual
Canon EOS Rebel T7/2000D For Dummies
Google+: The Missing Manual
     Book fetch request page 8
     Book fetch request page 8
Google+: The Missing Manual
Learning Objective-C by Developing iPhone Games
Fundamentals of C++ Programming
The Book of CSS3
The Book of Qt 4
The dRuby Book
Canon EOS Rebel T7/2000D For Dummies
EPUB 3 Best Practices
Mastering Swift 2
Fundamentals of Python Programming
The Book of Xen
The Book of IMAP
LaTeX: Beginner's Guide
Adobe Edge Preview 5: The Missing Manual
The Book of F#
The Social Media Marketing Book
The Book of PF, 3rd Edition
The Book of PF, 2nd Edition
The Book of CSS3, 2nd Edition
The Little Book on CoffeeScript
WCF 4.0 Multi-tier Services Development with LINQ to Entities
The LEGO MINDSTORMS EV3 Idea Book
Adobe Edge Animate Preview 7: The Missing Manual
HTML5: The Missing Manual
Linux All-In-One For Dummies, 6th Edition
The Cucumber for Java Book
Do more with SOA Integration: Best of Packt
The Book of Ruby
The RSpec Book
PHP & MySQL: The Missing Manual, 2nd Edition
Python re(gex)?
Full Speed Python
The dRuby Book
3D Game Development with LWJGL 3
Fundamentals of Python Programming
Canon EOS Rebel T7/2000D For Dummies
Statistics with Julia
Google+: The Missing Manual
The Book of CSS3, 2nd Edition
Learning Objective-C by Developing iPhone Games
LaTeX: Beginner's Guide
EPUB 3 Best Practices
The Book of Ruby
The Book of PF, 3rd Edition
The Book of F#
PHP & MySQL: The Missing Manual, 2nd Edition
The RSpec Book
The Book of PF, 2nd Edition
The Little Book on CoffeeScript
The Book of CSS3
Do more with SOA Integration: Best of Packt
The Cucumber for Java Book
The LEGO MINDSTORMS EV3 Idea Book
The Book of IMAP
The Social Media Marketing Book
The Book of Qt 4
The Little MongoDB Book
Professor Frisby's Mostly Adequate Guide to Functional Programming
The Book of Xen
Fundamentals of C++ Programming
The Basics of User Experience Design
Adobe Edge Animate Preview 7: The Missing Manual
Linux All-In-One For Dummies, 6th Edition
WCF 4.0 Multi-tier Services Development with LINQ to Entities
Mastering Swift 2
A Byte of Python
Adobe Edge Preview 5: The Missing Manual
Reintroducing React
HTML5: The Missing Manual
Webapps in Go

```

- 일단 처음 디스크 캐시에 저장할때 두번 fetch request 호출하는 게 보이고
- 디스크 캐시에서 불러올 때 분명 page2가 디스크에 있어야 하는데 fetch request를 보내는 걸로 보아 저장과정이 잘 안된 것 같다.

캐시에서 확인하고 없으면 api 호출하는 코드를 보면

```swift
    public func getSearchResultFromCache(keyword: String, page: Int, completion: @escaping (BookSearchModel?) -> ()) {
        //get from memory cache
        getSearchResultFromMemory(keyword: keyword, page: page) { (data) in
            if let data = data {
                print("get from memory     \(page)")
                completion(data)
            } else {
                self.getSearchResultFromDisk(keyword: keyword, page: page) { (data) in
                    if let data = data {
                        print("get from disk       \(page)")
                        completion(data)
                        self.saveAtMemory(keyword: keyword, page: page, data: data)
                    }else {
                        print("call api")
                    }
                }
            }
        }
    }
```
로그를 찍어보면 
call api
get from disk       1
save to memory      1
call api
get from disk       2
save to memory      2

completion 되기 전에 좌좌좍 else 로 빠져서 api 호출 한 다음 뒤늦게 가져오는 거시였다.
그리고 메모리에 올라간 뒤에는 
get from memory     1
get from memory     2
메모리에서 잘 받아온다.

disk에서 가져올때 오버헤드가 발생해서 else 로 빠지는 듯

그냥 문제는 completion block 에 대한 이해가 부족했음
disk에서 데이터 가져올때 completion 이후 코드는 실행 안되는 것 처럼 생각하고 코드를 짰음
return 과 달리 completion 이후에도 코드 실행되는데 잠깐 헷갈린듯
중복되는건 이제 해결했고 disk cache hit 이 안되는 문제 해결해야함

지금은 코어데이터 엔티티를 전부 들고와서(저장된 모든 페이지)
loop 돌면서 페이지를 찾는다. 
예를들어 디스크에서 1페이지 찾으면
엔티티 불러옴 -> 1페이지 찾음 -> 리턴
디스크에서 2페이지 찾으면
엔티티 다시 불러옴 -> 1페이지 아님 -> 2페이지 맞음 리턴

이런 방식인데 비효율 적이고 또 지금 hit 이 안되니 이쪽 로직 수정한다
일단 코어 데이터에는 keyword page 가 섞여서 들어가 있고 이걸 불러오면 각종 keyword와 page가 섞인 한 뭉텅이가 로드된다.
얘를 처음 앱 실행 될 때 keyword기준 Map과 page는 array로 정리해놓고 불러쓰면 좋을 것 같다. (완료)


