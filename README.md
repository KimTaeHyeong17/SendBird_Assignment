# SendBird_Assignment
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
- [ ] 준수한 UI
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
- [x] 이미지 디스크 캐싱 레이어 추가 

#### 2/20 토


#### 2/21 일

### bugs
- [x] keyboard hides the memo textview (bookDetail)
- [x] fast scrolling causes book image to flick (cache에 있어도 image fetch 했었음)
- [x] Book API maximum page is 100 (result 4500개 있어도 한장당 10개 결과 최대 100페이지까지만 되고 101페이지 호출하면 1페이지 리턴함)
