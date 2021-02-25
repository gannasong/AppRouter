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

  init(proxy: NavigatorProxy) {
    self.proxy = proxy
  }

  func setNavigationMap() {
    proxy.register(from: "https://first-test-url.com")
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
    let proxy = NavigatorProxySpy()
    _ = AppRouter(proxy: proxy)

    XCTAssertNotNil(proxy.navigator)
  }

  func test_init_navigatorShouldRegisterOnePath() {
    let proxy = NavigatorProxySpy()
    let sut = AppRouter(proxy: proxy)

    sut.setNavigationMap()

    XCTAssertNotNil(proxy.registeredURL)
  }
}
