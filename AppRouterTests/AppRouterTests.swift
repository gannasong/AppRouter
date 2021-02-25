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
    let path = TestPaths.firstPath.rawValue
    let (sut, proxy) = makeSUT(urls: [path])

    sut.setNavigationMap()

    XCTAssertEqual(proxy.registeredURLs, [path])
  }

  func test_init_navigatorShouldRegisterTwoPaths() {
    let firstPath = TestPaths.firstPath.rawValue
    let secondPath = TestPaths.secondPath.rawValue
    let (sut, proxy) = makeSUT(urls: [firstPath, secondPath])

    sut.setNavigationMap()
    sut.setNavigationMap()

    XCTAssertEqual(proxy.registeredURLs, [firstPath, secondPath])
  }

  // MARK: - Helpers

  private func makeSUT(urls: [String] = ["https://first-test-url.com"]) -> (sut: AppRouter, proxy: NavigatorProxySpy) {
    let proxy = NavigatorProxySpy()
    let sut = AppRouter(urls: urls, proxy: proxy)
    return (sut, proxy)
  }

  private class NavigatorProxySpy: NavigatorProxy {
    var navigator: Navigator = Navigator()
    var registeredURLs = [String]()

    func register(from paths: [String]) {
      registeredURLs = paths
    }
  }

  private enum TestPaths: String, CaseIterable {
    case firstPath = "https://first-test-url.com"
    case secondPath = "https://second-test-url.com"
  }
}
