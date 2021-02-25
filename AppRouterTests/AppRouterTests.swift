//
//  AppRouterTests.swift
//  AppRouterTests
//
//  Created by SUNG HAO LIN on 2021/2/24.
//

import XCTest
import URLNavigator
@testable import AppRouter

class AppRouter {
  let proxy: NavigatorProxy
  let url: String

  init(url: String, proxy: NavigatorProxy) {
    self.url = url
    self.proxy = proxy
  }

  func setNavigationMap() {
    // "https://first-test-url.com"
    proxy.register(from: url)
  }
}

protocol NavigatorProxy {
  var navigator: Navigator { get set }

  func register(from path: String)
}

class NavigatorProxySpy: NavigatorProxy {
  var navigator: Navigator = Navigator()
  var registeredURL: String?

  func register(from path: String) {
    registeredURL = path
  }
}

class AppRouterTests: XCTestCase {

  func test_init_navigatorProxyNavigatorShouldNotNil() {
    let url = "https://first-test-url.com"
    let proxy = NavigatorProxySpy()
    _ = AppRouter(url: url, proxy: proxy)

    XCTAssertNotNil(proxy.navigator)
  }

  func test_init_navigatorShouldRegisterOnePath() {
    let url = "https://first-test-url.com"
    let proxy = NavigatorProxySpy()
    let sut = AppRouter(url: url, proxy: proxy)

    sut.setNavigationMap()

    XCTAssertEqual(url, proxy.registeredURL)
  }
}
