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
    NavigatorProxy.shared.registeredURL = "https://first-test-url.com"
  }
}

class NavigatorProxy {
  static let shared = NavigatorProxy()

  let navigator = Navigator()

  private init() {}

  var registeredURL: String?
}

class AppRouterTests: XCTestCase {

  func test_init_navigatorProxyNavigatorShouldNotNil() {
    let proxy = NavigatorProxy.shared
    _ = AppRouter()
    XCTAssertNotNil(proxy.navigator)
  }

  func test_init_navigatorShouldRegisterOnePath() {
    let proxy = NavigatorProxy.shared
    let sut = AppRouter()

    sut.setNavigationMap()

    XCTAssertNotNil(proxy.registeredURL)
  }
}
