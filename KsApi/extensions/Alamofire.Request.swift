import Foundation
import Alamofire
import Argo
import ReactiveCocoa

internal extension Alamofire.Request {
  static let queue = dispatch_queue_create("com.kickstarter.ksapi", nil)
  /*
  Turns an Alamofire request into a signal of a model by:

  - Download data and parsing JSON.
  - Decoding JSON into a model.
  - Fail if the decoding returns `nil`.
  */
  internal func decodeModel <M: Decodable where M == M.DecodedType> (klass: M.Type) -> SignalProducer<M, ErrorEnvelope> {
    return self.rac_JSONResponse()
      .map { json in decode(json) as M? }
      .failOnNil(ErrorEnvelope.couldNotDecodeJSON)
  }

  /**
   Convert an Alamofire request into a signal producer of `NSData`.
  */
  private func rac_dataResponse() -> SignalProducer<NSData, ErrorEnvelope> {

    return SignalProducer { observer, dispossable in
      return self.responseData { response in

        switch response.result {
        case let .Success(value):
          print("[KsApi] Success \(self)")
          observer.sendNext(value)
          observer.sendCompleted()
        case .Failure:
          print("[KsApi] Failure \(self)")
          // Try parsing the failure JSON into an envelope that we understand
          if let data = response.data,
            json = parseJSONData(data),
            envelope = decode(json) as ErrorEnvelope? {
              observer.sendFailed(envelope)
          } else {
            // When that's not possible send a general error
            observer.sendFailed(ErrorEnvelope.couldNotParseErrorEnvelopeJSON)
          }
        }
      }
    }
  }

  /**
   Converts an Alamofire request into a signal producer of raw JSON data. If the JSON does not parse
   successfully, an `ErrorEnvelope.errorJSONCouldNotParse()` error is emitted.
  */
  private func rac_JSONResponse() -> SignalProducer<AnyObject, ErrorEnvelope> {
    return rac_dataResponse()
      .observeOn(QueueScheduler(queue: Alamofire.Request.queue))
      .map(parseJSONData)
      .failOnNil(ErrorEnvelope.couldNotParseJSON)
  }
}