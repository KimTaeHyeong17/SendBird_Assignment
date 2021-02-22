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
- [ ] 가끔 같은 page duplication이 생긴다. (disk cache bug)
    - searchbar 에서 입력이 있을경우 0.3 딜레이를 주면서 keyword를 모은 후 api request를 던지는데 입력 속도에 따라 리쿼스트가 많아져서 이전 요청 응답이 중복 쌓이는 건가? (request cancel 구현?)
    - disk, memory, url 에서 받아오는 데이터 사이 타이밍 문제? (completion handler 말고 combine?)



### 개선해야 하는 것
- [ ] 캐싱 데이터 바뀌었을 경우 E-Tag등 활용해 update 해야함
- [ ] core data 에서 fetching 할때 keyword와 page 찾는 로직
- [ ] 화면에 표시되고 있는 이미지 부터 로딩
