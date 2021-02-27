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

public protocol NavigatorProtocol {
    func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory)
}

public class AppRouter {
    private let navigator: NavigatorProtocol
    
    public init(navigator: NavigatorProtocol) {
        self.navigator = navigator
        navigator.register("https://icook.tw/amp/categories/<int:id>") { (_, value, _) -> UIViewController? in
            let id = value["id"] as! Int
            let vc = CategoryVC()
            vc.id = id
            return vc
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
    
    func test_mapToCategoryVC_onNavigatorExtractIntID() {
        // given
        let (_, spy) = makeSUT()
        
        //when
        let mappedVC = spy.triggeredToExtract(["id": 55]) as? CategoryVC
        
        // then
        XCTAssertEqual(mappedVC?.id, 55)
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
        
        func triggeredToExtract(_ values: [String: Any]) -> UIViewController? {
            return mapping?.factory("", values, nil)
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
