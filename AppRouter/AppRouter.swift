//
//  AppRouter.swift
//  AppRouter
//
//  Created by SUNG HAO LIN on 2021/2/25.
//

import Foundation
import URLNavigator

public protocol NavigatorProxy {
  var navigator: Navigator { get set }

  func register(from path: String)
}

public class AppRouter {
  private let proxy: NavigatorProxy
  private let url: String

  public init(url: String, proxy: NavigatorProxy) {
    self.url = url
    self.proxy = proxy
  }

  public func setNavigationMap() {
    proxy.register(from: url)
  }
}


