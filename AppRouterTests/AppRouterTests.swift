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

    XCTAssertNotNil(proxy.navigator, "Expected navigator not nil when app init.")
  }

  func test_init_navigatorShouldRegisterOnePath() {
    let url = RouterPatterns.home.rawValue
    let (sut, proxy) = makeSUT()

    sut.setNavigationMap(url: url)

    XCTAssertEqual(proxy.registeredURLs, [url], "Expected proxy successful register one path.")
  }

  func test_init_navigatorShouldRegisterAllPaths() {
    let urls = RouterPatterns.allPatterns
    let (sut, proxy) = makeSUT()

    urls.forEach { url in
      sut.setNavigationMap(url: url)
    }

    XCTAssertEqual(proxy.registeredURLs, urls, "Expected proxy successful register all paths.")
  }

  // MARK: - Helpers

  private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: AppRouter, proxy: NavigatorProxySpy) {
    let proxy = NavigatorProxySpy()
    let sut = AppRouter(proxy: proxy)
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

    func register(from path: String, completion: () -> Void) {
      registeredURLs.append(path)
      completion()
    }
  }
}
