//
//  Router.swift
//  Router
//
//  Created by SUNG HAO LIN on 2021/2/25.
//

import Foundation
import URLNavigator

public protocol NavigatorProxy {
  var navigator: Navigator { get set }

  func register(from paths: [String], completion: () -> Void)
}

public class Router {
  private let proxy: NavigatorProxy
  private let urls: [String]

  public init(urls: [String], proxy: NavigatorProxy) {
    self.urls = urls
    self.proxy = proxy
  }

  public func setNavigationMap() {
    proxy.register(from: urls) {
      // do production register
    }
  }
}
