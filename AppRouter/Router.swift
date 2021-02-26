//
//  Router.swift
//  Router
//
//  Created by SUNG HAO LIN on 2021/2/25.
//

import Foundation
import URLNavigator

public enum TestPaths: String, CaseIterable {
  case home_01 = "https://icook.tw"
  case home_02 = "https://icook.tw/"
  case amp_categories = "https://icook.tw/amp/categories/55"

  public static var allPaths: [String] {
    TestPaths.allCases.map { $0.rawValue }
  }
}

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
