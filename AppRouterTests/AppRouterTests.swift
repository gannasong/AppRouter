//
//  AppRouterTests.swift
//  AppRouterTests
//
//  Created by SUNG HAO LIN on 2021/2/24.
//

import XCTest
import URLNavigator
@testable import AppRouter

class AppRouter {}

class NavigatorProxy {
  let navigator = Navigator()
}

class AppRouterTests: XCTestCase {

  func test_init_navigatorProxyNavigatorShouldNotNil() {
    let proxy = NavigatorProxy()
    _ = AppRouter()
    XCTAssertNotNil(proxy.navigator)
  }

  func test_init_navigatorShouldRegisterOnePath() {
  }
}
