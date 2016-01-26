import Foundation

/**
 A type that knows the location of a Kickstarter API and web server.
*/
public protocol ServerConfigType {
  var apiBaseUrl: NSURL { get }
  var webBaseUrl: NSURL { get }
  var apiClientAuth: ClientAuthType { get }
  var basicHTTPAuth: BasicHTTPAuthType? { get }
}

public struct ServerConfig : ServerConfigType {
  public let apiBaseUrl: NSURL
  public let webBaseUrl: NSURL
  public let apiClientAuth: ClientAuthType
  public let basicHTTPAuth: BasicHTTPAuthType?

  public static let production: ServerConfigType = ServerConfig(
    apiBaseUrl: NSURL(string: "https://***REMOVED***")!,
    webBaseUrl: NSURL(string: "https://www.kickstarter.com")!,
    apiClientAuth: ClientAuth.production,
    basicHTTPAuth: nil
  )

  public static let staging: ServerConfigType = ServerConfig(
    apiBaseUrl: NSURL(string: "https://***REMOVED***")!,
    webBaseUrl: NSURL(string: "https://***REMOVED***")!,
    apiClientAuth: ClientAuth.development,
    basicHTTPAuth: nil
  )

  public static let local: ServerConfigType = ServerConfig(
    apiBaseUrl: NSURL(string: "http://api.ksr.dev")!,
    webBaseUrl: NSURL(string: "http://ksr.dev")!,
    apiClientAuth: ClientAuth.development,
    basicHTTPAuth: nil
  )

  public init(apiBaseUrl: NSURL, webBaseUrl: NSURL, apiClientAuth: ClientAuthType, basicHTTPAuth: BasicHTTPAuthType?) {
    self.apiBaseUrl = apiBaseUrl
    self.webBaseUrl = webBaseUrl
    self.apiClientAuth = apiClientAuth
    self.basicHTTPAuth = basicHTTPAuth
  }

  /**
   Create a server type with just the base dev instance name.
  */
  public init(devEnv: String) {
    self.apiBaseUrl = NSURL(string: "https://api-\(devEnv).***REMOVED***")!
    self.webBaseUrl = NSURL(string: "https://\(devEnv).***REMOVED***")!
    self.apiClientAuth = ClientAuth.development
    self.basicHTTPAuth = BasicHTTPAuth.development
  }
}