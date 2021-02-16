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
- [ ] 검색결과를 캐싱해야함 (이미지도 별도로)

### Detail ViewController
- [x] 리스트에서 선택된 책의 모든 detail 을 보여줌
- [ ] 유저가 메모를 적을 수 있게 해야함
- [ ] 책의 url 을 하이퍼링크 달아야함

### 가산점
- [ ] 테스팅 (TDD)
- [ ] 코드로 UI 짜기


### TODO
#### 2/15
- [x] 프로젝트 세팅
- [x] 검색창에 키워드 입력
- [x] 키워드 검색에 대한 결과 표시
- [x] 응답에 있는 모든 정보 표시
- [x] 네트워킹 파트 구현
- [x] Book API 연동
- [x] URL이미지 다운 및 캐싱
#### 2/16
- [x] 리스트에서 선택된 책의 모든 detail 을 보여줌
- [ ] Pagination to search result
- [ ] caches search result

