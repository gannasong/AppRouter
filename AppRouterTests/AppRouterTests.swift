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

  func setNavigationMap() {
    NavigatorProxy.shared.register(from: "https://first-test-url.com")
  }
}

class NavigatorProxy {
  static var shared = NavigatorProxy()

  let navigator = Navigator()

  func register(from path: String) {}
}

class NavigatorProxySpy: NavigatorProxy {
  var registeredURL: String?

  override func register(from path: String) {
    registeredURL = path
  }
}

class AppRouterTests: XCTestCase {

  func test_init_navigatorProxyNavigatorShouldNotNil() {
    let proxy = NavigatorProxySpy()
    _ = AppRouter()

    XCTAssertNotNil(proxy.navigator)
  }

  func test_init_navigatorShouldRegisterOnePath() {
    let proxy = NavigatorProxySpy()
    NavigatorProxy.shared = proxy
    let sut = AppRouter()

    sut.setNavigationMap()

    XCTAssertNotNil(proxy.registeredURL)
  }
}
