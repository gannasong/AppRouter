//
//  AppRouterTests.swift
//  AppRouterTests
//
//  Created by SUNG HAO LIN on 2021/2/24.
//

import XCTest
import AppRouter
import URLNavigator

public protocol NavigatorProtocol {
    func register(_ patterns: URLPattern, _ factory: @escaping ViewControllerFactory)
}

 public class AppRouter {
    private let navigator: NavigatorProtocol
    
    public typealias Factory = ([String: Any]) -> UIViewController?
    
    public typealias Mapping = (pattern: String, factory: Factory)
    
    private var mappings: [Mapping]
    
    public init(navigator: NavigatorProtocol, mappings: [Mapping] = []) {
        self.navigator = navigator
        self.mappings = mappings
    }
    
    public func register() {
        mappings.forEach { (mapping) in
            navigator.register(
                mapping.pattern,
                { _, value, _ in
                    mapping.factory(value)
                }
            )
        }
    }
}

class AppRouterTests: XCTestCase {
    func test_init_doesNotMessageCollaborator_onAlways() {
        // given
        
        // when
        let spy = NavigatorSpy()
        let _ = AppRouter(navigator: spy)
        
        // then
        XCTAssertTrue(spy.registeredPatterns.isEmpty)
    }
        
    func test_register_messageCollaboratorTwice_onTwoMappings() {
        // given
        let mappings = anyMappings()
        
        let spy = NavigatorSpy()
        let sut = AppRouter(navigator: spy, mappings: mappings)
        
        //when
        sut.register()
        
        // then
        assertMappings(mappings, registeredOn: spy, mappedVCType: AnyViewController.self)
    }
    
    private func assertMappings<T: UIViewController>(
        _ mappings: [AppRouter.Mapping],
        registeredOn spy: NavigatorSpy,
        mappedVCType type: T.Type,
        file: StaticString = #file, line: UInt = #line)
    {
        assertPatterns(on: mappings, registeredOn: spy)
        assertFactories(on: mappings, registeredOn: spy, mappedVCType: type)
    }
    
    private func assertPatterns(
        on mappings: [AppRouter.Mapping],
        registeredOn spy: NavigatorSpy,
        file: StaticString = #file, line: UInt = #line
    ) {
        XCTAssertEqual(spy.registeredPatterns, mappings.map { $0.pattern }, file: file, line: line)
    }
    
    private func assertFactories<T: UIViewController>(
        on mappings: [AppRouter.Mapping],
        registeredOn spy: NavigatorSpy,
        mappedVCType type: T.Type,
        file: StaticString = #file, line: UInt = #line
    ) {
        let actualVCs = spy.registeredFactories.map { $0("",[:], nil)  }
        let expectedVCs = mappings.map { $0.factory([:]) }
        
        XCTAssertEqual(
            actualVCs.count, expectedVCs.count,
            "expect map to \(expectedVCs.count) ViewControllers, but got \(actualVCs.count) instead,",
            file: file, line: line
        )
        
        expectedVCs.enumerated().forEach { (idx, expectedVC) in
            XCTAssertTrue(
                expectedVC is T,
                "expect map to \(T.self) type, but got \(String(describing: expectedVC.self)) at \(idx)",
                file: file, line: line
            )
        }
    }
    
    private func anyMappings() -> [AppRouter.Mapping] {
        return [anyMapping(), anyMapping()]
    }
    
    private func anyMapping() -> AppRouter.Mapping {
        return (anyPattern(), anyFactory())
    }
    
    private func anyFactory() -> AppRouter.Factory {
        return { _ in AnyViewController() }
    }
    
    private func anyPattern() -> String {
        return "anyPatter://any.com/pattern/<int:id>"
    }
    
    private class AnyViewController: UIViewController {}
    
    // MARK: - Helpers
    private func makeSUTAfterRegister(
        mappings: [AppRouter.Mapping],
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: AppRouter, navigatorSpy: NavigatorSpy)
    {
        let navigatorSpy = NavigatorSpy()
        let sut = AppRouter(navigator: navigatorSpy, mappings: mappings)
        sut.register()
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(navigatorSpy, file: file, line: line)
        return (sut, navigatorSpy)
    }
    
    private class NavigatorSpy: NavigatorProtocol {
        var registeredPatterns: [URLPattern] {
            return mappings.map { $0.pattern }
        }
        
        var registeredFactories: [ViewControllerFactory] {
            return mappings.map { $0.factory }
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
