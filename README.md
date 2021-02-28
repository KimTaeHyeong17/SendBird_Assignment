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
    - loading from disk step
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

### 중복 원인 찾음
![image](https://user-images.githubusercontent.com/37135317/109421229-cd2d4800-7a19-11eb-83e9-857b9c04ecbd.png)

저기 왜 completion이 있는지 모르겠네 하 race condition 이런 문제가 아니라 그냥 실수였음

문제는 completion block 에 대한 이해가 부족했음
disk에서 데이터 가져올때 completion 이후 코드는 실행 안되는 것 처럼 생각하고 코드를 짰음
return 과 달리 completion 이후에도 코드 실행되는데 잠깐 헷갈린듯


#### 중복되는건 이제 해결했고 disk cache hit 이 안되는 문제 해결해야함

지금은 코어데이터 엔티티를 전부 들고와서(저장된 모든 페이지)
loop 돌면서 페이지를 찾는다. 
예를들어 디스크에서 1페이지 찾으면
엔티티 불러옴 -> 1페이지 찾음 -> 리턴
디스크에서 2페이지 찾으면
엔티티 다시 불러옴 -> 1페이지 아님 -> 2페이지 맞음 리턴

이런 방식인데 비효율 적이고 또 지금 hit 이 안되니 이쪽 로직 수정한다
일단 코어 데이터에는 keyword page 가 섞여서 들어가 있고 이걸 불러오면 각종 keyword와 page가 섞인 한 뭉텅이가 로드된다.
얘를 처음 앱 실행 될 때 keyword기준 Map과 page는 array로 정리해놓고 불러쓰면 좋을 것 같다. (완료)

완료하니 디스크에서 잘 불러와짐
특히 저장을 NSOrderedSet으로 해서 순서대로 불러오는게 가능하긴 함

### 2월28 이후 남은작업
- [ ] 캐싱 데이터 바뀌었을 경우 E-Tag등 활용해 update 해야함
- [ ] 화면에 표시되고 있는 이미지 부터 로딩
- [ ] 빠르게 스크롤 하면 이미지 flickering (url image library 참고해보면될듯)
