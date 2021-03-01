//
//  AppRouterTests.swift
//  AppRouterTests
//
//  Created by SUNG HAO LIN on 2021/2/24.
//

import XCTest
import URLNavigator
import AppRouter

public class CategoryVC: UIViewController {
    var id: Int?
}

public class ErrorVC: UIViewController {
    
}

public protocol NavigatorProtocol {
    func register(_ patterns: URLPattern, _ factory: @escaping ViewControllerFactory)
}

/* 解釋不動 NavigatorProtocol 的原因：
AppDelegate -> AppRouter <|- URLNavAppRouter -> NavigatorProtocol <|- (NavigatorSpy || Navigaor)
                         <|- Some3rdAppRouter -> SomeMockedInterface <|- SomeSpy || SomeConcreate3rdObj
*/

/*
 1. 重寫 use case or 拆解/訂正目前的 use case
 2. 
 
 */

 public class AppRouter {
    private let navigator: NavigatorProtocol
    
    private var patterns: [String]
    private var factory: [([String: Any])-> UIViewController?]
    
    //????
    public init(navigator: NavigatorProtocol, patterns: [String]) { /// 實驗把 default 數值拿掉
        self.navigator = navigator
        self.patterns = patterns
    }
    
    public func register() {
        
        patterns.forEach { (pattern) in
            navigator.register(pattern) { (_, value, _) -> UIViewController? in
                guard let id = value["id"] as? Int else {
                    return ErrorVC()
                }
                let vc = CategoryVC()
                vc.id = id
                return vc
            }
        }
        
        
    }
    
}

class AppRouterTests: XCTestCase {
    func test_init_nilPattern() { //這個測試名稱要改
        //
        let spy = NavigatorSpy()
        let _ = AppRouter(navigator: spy)
        
        //
        XCTAssertTrue(spy.registeredPatterns.isEmpty)
    }
    
    func test_register_requestNavigatorRegisterPattern() {
        // given
        let myPattern = "https://icook.tw/amp/categories/<int:id>"
        let spy = NavigatorSpy()
        let sut = AppRouter(navigator: spy, patterns: [myPattern])
        
        //when
        sut.register()
        
        // then
        XCTAssertEqual(spy.registeredPatterns, [myPattern])
    }
    

    //test_操作_條件_期待的結果
    func test_register_givenTwoPatterns_reqeustNavigatorRegisterTwice() {
        // given
        let p1 = "https://icook.tw/amp/categories/<int:id>"
        let p2 = "https://icook.tw/amp/test/<int:id>"
        let spy = NavigatorSpy()
        let sut = AppRouter(navigator: spy, patterns: [p1, p2])
        
        //when
        sut.register()
        
        // then
        XCTAssertEqual(spy.registeredPatterns, [p1, p2])
    }
    
    /// 可以用以下的 anyPattern 取代上面的 p1, p2
    private func anyPattern() {
        
    }
    
    /////////////, 分篩兩個
    func test_mapToCategoryVC_onNavigatorExtractIntID() {
        // given
        let pattern = "https://icook.tw/amp/categories/<int:id>"
        let (_, spy) = makeSUTAfterRegister(patterns: [pattern])
        
        //when
        let mappedVC = spy.mappingVC(from: ["id": 55]) as? CategoryVC

        // then
        XCTAssertEqual(mappedVC?.id, 55)
    }
//
    func test_mapToCategoryVC_onNavigatorExtractEmptyValue() {
        // given
        let pattern = "https://icook.tw/amp/categories/<int:id>"
        let (_, spy) = makeSUTAfterRegister(patterns: [pattern])

        //when
        let mappedVC = spy.mappingVC(from: [:])

        // then
        XCTAssertTrue(mappedVC is ErrorVC)
    }
    
    // MARK: - Helpers
    private func makeSUTAfterRegister(
        patterns: [String],
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: AppRouter, navigatorSpy: NavigatorSpy)
    {
        let navigatorSpy = NavigatorSpy()
        let sut = AppRouter(navigator: navigatorSpy, patterns: patterns)
        sut.register()
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(navigatorSpy)
        return (sut, navigatorSpy)
    }
    
    private class NavigatorSpy: NavigatorProtocol {
        var registeredPatterns: [URLPattern] {
            return mappings.map {$0.pattern}
        }
        
        private var mappings: [(pattern: URLPattern, factory: ViewControllerFactory)] = []
        func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) {
            mappings.append((pattern, factory))
        }
        
        func mappingVC(from values: [String: Any], idx: Int = 0) -> UIViewController? {
            return mappings[idx].factory("", values, nil)
        }
    }
    
    private func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance, "Instance should have been deallocated. Potential memory leak.",
                file: file, line: line
            )
        }
    }}
