//
//  AppRouterTests.swift
//  AppRouterTests
//
//  Created by SUNG HAO LIN on 2021/2/24.
//

import XCTest
import URLNavigator
import AppRouter

class AppRouterTests: XCTestCase {
  func test_init_navigatorProxyNavigatorShouldNotNil() {
    let (_, proxy) = makeSUT()

    XCTAssertNotNil(proxy.navigator)
  }

  func test_init_navigatorShouldRegisterOnePath() {
    let url = TestPaths.home_01.rawValue
    let (sut, proxy) = makeSUT(urls: [url])

    sut.setNavigationMap()

    XCTAssertEqual(proxy.registeredURLs, [url])
  }

  func test_init_navigatorShouldRegisterTwoPaths() {
    let urls = [TestPaths.home_01.rawValue, TestPaths.home_02.rawValue]
    let (sut, proxy) = makeSUT(urls: urls)

    sut.setNavigationMap()

    XCTAssertEqual(proxy.registeredURLs, urls)
  }

  func test_init_navigatorShouldRegisterAllPaths() {
    let urls = TestPaths.allPaths
    let (sut, proxy) = makeSUT(urls: urls)

    sut.setNavigationMap()

    XCTAssertEqual(proxy.registeredURLs, urls)
  }

  // MARK: - Helpers

  private func makeSUT(urls: [String] = [], file: StaticString = #file, line: UInt = #line) -> (sut: Router, proxy: NavigatorProxySpy) {
    let proxy = NavigatorProxySpy()
    let sut = Router(urls: urls, proxy: proxy)
    trackForMemoryLeaks(sut)
    trackForMemoryLeaks(proxy)
    return (sut, proxy)
  }

  private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
    addTeardownBlock { [weak instance] in
      XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
    }
  }

  private class NavigatorProxySpy: NavigatorProxy {
    var navigator: Navigator = Navigator()
    var registeredURLs = [String]()

    func register(from paths: [String], completion: () -> Void) {
      registeredURLs = paths
      completion()
    }
  }
}
