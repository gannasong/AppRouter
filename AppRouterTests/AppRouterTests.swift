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
    func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory)
}

public class AppRouter {
    private let navigator: NavigatorProtocol
    
    public init(navigator: NavigatorProtocol) {
        self.navigator = navigator
    }
    
    public func register() {
        navigator.register("https://icook.tw/amp/categories/<int:id>") { (_, value, _) -> UIViewController? in
            guard let id = value["id"] as? Int else {
                return ErrorVC()
            }
            let vc = CategoryVC()
            vc.id = id
            return vc
        }
    }
    
}

class AppRouterTests: XCTestCase {
    func test_init_nilPattern() {
        //
        let spy = NavigatorSpy()
        let _ = AppRouter(navigator: spy)
        
        //
        XCTAssertNil(spy.registeredPattern)
    }
    
    func test_register_requestNavigatorRegisterPattern() {
        // given
        let myPattern = "https://icook.tw/amp/categories/<int:id>"
        let spy = NavigatorSpy()
        let sut = AppRouter(navigator: spy)
        
        //when
        sut.register()
        
        // then
        XCTAssertEqual(spy.registeredPattern, myPattern)
    }
    
    func test_mapToCategoryVC_onNavigatorExtractIntID() {
        // given
        let (_, spy) = makeSUT()
        
        //when
        let mappedVC = spy.mappingVC(from: ["id": 55]) as? CategoryVC
        
        // then
        XCTAssertEqual(mappedVC?.id, 55)
    }
    
    func test_mapToCategoryVC_onNavigatorExtractEmptyValue() {
        // given
        let (_, spy) = makeSUT()
        
        //when
        let mappedVC = spy.mappingVC(from: [:])
        
        // then
        XCTAssertTrue(mappedVC is ErrorVC)
    }
    
    // MARK: - Helpers
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: AppRouter, navigatorSpy: NavigatorSpy)
    {
        let navigatorSpy = NavigatorSpy()
        let sut = AppRouter(navigator: navigatorSpy)
        sut.register()
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(navigatorSpy, file: file, line: line)
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
        
        func mappingVC(from values: [String: Any]) -> UIViewController? {
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
