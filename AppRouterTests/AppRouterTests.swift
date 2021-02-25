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
    let url = "https://first-test-url.com"
    let (sut, proxy) = makeSUT(url: url)

    sut.setNavigationMap()

    XCTAssertEqual(proxy.registeredURL, url)
  }

  func test_init_navigatorShouldRegisterTwoPaths() {
    let url = "https://first-test-url.com"
    let (sut, proxy) = makeSUT(url: url)

    sut.setNavigationMap()
    sut.setNavigationMap()

    XCTAssertEqual(proxy.registeredURLs, [url, url])
  }

  // MARK: - Helpers

  private func makeSUT(url: String = "https://first-test-url.com") -> (sut: AppRouter, proxy: NavigatorProxySpy) {
    let proxy = NavigatorProxySpy()
    let sut = AppRouter(url: url, proxy: proxy)
    return (sut, proxy)
  }

  private class NavigatorProxySpy: NavigatorProxy {
    var navigator: Navigator = Navigator()
    var registeredURL: String?
    var registeredURLs = [String]()

    func register(from path: String) {
      registeredURL = path
      registeredURLs.append(path)
    }
  }
}
