//
//  SendbirdAssignment_TaeHyeongKimUITests.swift
//  SendbirdAssignment_TaeHyeongKimUITests
//
//  Created by TaeHyeong Kim on 2021/02/28.
//

import XCTest

@testable import SendbirdAssignment_TaeHyeongKim

class SendbirdAssignment_TaeHyeongKimUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        //searchbar 찾기
        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.exists)
        //키보드 올려서
        searchBar.tap()
        //java 검색하고 키보드 내림
        searchBar.typeText("java\n")
        sleep(2)
        
        //tableview 찾기
        let tableView = app.tables.firstMatch
        //duplication 검사용 Set
        var set: Set<String> = []
        var swipeCount = 0
        //계속 swipe up 해서 tableview scroll, 일단 10번 swipe 해서 통과하면 성공
        while true {
            //페이지의 마지막 cell 접근
            guard let pageLastCell = tableView.cells.allElementsBoundByIndex.last else {
                return
            }
            let textInLastCell = pageLastCell.descendants(matching: .staticText).firstMatch
            //마지막 셀이 중복된다면 테스트 실패
            XCTAssertFalse(set.contains(textInLastCell.label), "duplication found \(textInLastCell.label)")
            
            set.insert(textInLastCell.label)
            
            tableView.swipeUp(velocity: .fast)
            swipeCount += 1
        }
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
