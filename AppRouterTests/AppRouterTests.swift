//
//  AppRouterTests.swift
//  AppRouterTests
//
//  Created by SUNG HAO LIN on 2021/2/24.
//

import XCTest
import URLNavigator
import AppRouter

public protocol NavigatorProtocol {
    func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory)
}

public class AppRouter {
    private let navigator: NavigatorProtocol
    
    public init(navigator: NavigatorProtocol) {
        self.navigator = navigator
        navigator.register("https://icook.tw/amp/categories/<int:id>") { (_, value, _) -> UIViewController? in
            return nil
        }
    }
    
}

class AppRouterTests: XCTestCase {
    func test_requestRegisterPattern_onInit() {
        // given
        let myPattern = "https://icook.tw/amp/categories/<int:id>"
        
        //when
        let (_, spy) = makeSUT()
        
        // then
        XCTAssertEqual(spy.registeredPattern, myPattern)
    }
    
    // MARK: - Helpers
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: AppRouter, navigatorSpy: NavigatorSpy)
    {
        let navigatorSpy = NavigatorSpy()
        let sut = AppRouter(navigator: navigatorSpy)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(navigatorSpy)
        return (sut, navigatorSpy)
    }
    
    private class NavigatorSpy: NavigatorProtocol {
        var registeredPattern: URLPattern? {
            return mapping?.pattern
        }
        
        private var mapping: (pattern: URLPattern, factory: ViewControllerFactory)?
        func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) {
            mapping = (pattern, factory)
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
