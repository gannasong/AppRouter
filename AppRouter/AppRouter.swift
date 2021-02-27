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
  case amp_search = "https://icook.tw/amp/search/cake/"
  case richSearch = "https://icook.tw/search/羊肉/空心菜,辣椒/"

  public static var allPaths: [String] {
    TestPaths.allCases.map { $0.rawValue }
  }
}

public enum RouterPatterns: String, CaseIterable {
  case home = "https://icook.tw/"
  case amp_categories = "https://icook.tw/amp/categories/<int:id>"
  case amp_search = "https://icook.tw/amp/search/string:keyword/"
  case richSearch = "https://icook.tw/search/<string:keyword>/<string:ingredients>"

  public static var allPatterns: [String] {
    RouterPatterns.allCases.map { $0.rawValue }
  }
}

public protocol NavigatorProxy {
  var navigator: Navigator { get set }

  func register(from path: String, completion: () -> Void)
}

public class AppRouter {
  private let proxy: NavigatorProxy

  public init(proxy: NavigatorProxy) {
    self.proxy = proxy
  }

  public func setNavigationMap(url: String) {
    proxy.register(from: url) {
      // register all paths to map view controller
    }
  }
}
