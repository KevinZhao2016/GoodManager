//
//  APIProvider.swift
//  GoodManager
//
//  Created by KevinZhao on 2019/1/18.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire

class APIProvider<Target: APITarget>: MoyaProvider<Target> {
//    
//    override init(
//        endpointClosure: @escaping (Target) -> Endpoint = APIProvider.APIEndpointMapping,
//        requestClosure: @escaping (Endpoint, @escaping MoyaProvider<Target>.RequestResultClosure) -> Void = MoyaProvider.defaultRequestMapping,
//        stubClosure: @escaping (Target) -> StubBehavior = MoyaProvider.neverStub,
//        manager: Manager = APIProvider<Target>.APIDefaultAlamofireManager(),
//        plugins: [PluginType] = [APINetworkActivityPlugin()],
//        trackInflights: Bool = false) {
//        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
//
//    }
//
//
//    override func request(_ token: Target) -> Observable<Moya.Response> {
//        // Creates an observable that starts a request each time it's subscribed to.
//        return Observable.create { [weak self] observer in
//            var cancellableToken: Cancellable?
//            var refreshingObserver: Disposable?
//
//            refreshingObserver = Network.tokenRefreshingBehavior
//                .subscribe { (event) -> Void in
//                    switch event {
//                    case .next(false):
//                        refreshingObserver?.dispose()
//                        cancellableToken = self?.request(token) { result in
//                            switch result {
//                            case let .success(response):
//                                observer.onNext(response)
//                                observer.onCompleted()
//                            case let .failure(error):
//                                observer.onError(error)
//                            }
//                        }
//                    case .error(let error):
//                        observer.onError(error)
//                        refreshingObserver?.dispose()
//                    default:
//                        break
//                    }
//            }
//            return Disposables.create {
//                refreshingObserver?.dispose()
//                cancellableToken?.cancel()
//
//            }
//        }
//    }
}

// MARK: - Alamofire Provider
extension APIProvider {
//    class func APIDefaultAlamofireManager() -> Manager {
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
//        
//        var policies: [String: ServerTrustPolicy] = [:]
//        Network.productionBases.forEach { (host) in
//            policies[host.rawValue] = ServerTrustPolicy.pinPublicKeys(
//                publicKeys: ServerTrustPolicy.publicKeys(in: Bundle.main),
//                validateCertificateChain: true,
//                validateHost: true)
//            //            policies[host.rawValue] = .PinPublicKeys(
//            //                publicKeys: ServerTrustPolicy.publicKeysInBundle(),
//            //                validateCertificateChain: true,
//            //                validateHost: true
//            //            )
//        }
//        
//        #if DEBUG
//        let manager = Manager(configuration: configuration)
//        #else
//        let manager = Manager(
//            configuration: configuration,
//            serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies)
//        )
//        #endif
//        
//        manager.startRequestsImmediately = false
//        return manager
//    }
//}
//
//// MARK: - Mapping
//extension APIProvider {
//    final class func APIEndpointMapping(_ target: Target) -> Endpoint {
//        let url = URL(
//            string: target.path,
//            relativeTo: target.baseURL
//            )?.absoluteString
//        let endpoint = Endpoint(
//            URL: url!,
//            sampleResponseClosure: {
//                return EndpointSampleResponse.networkResponse(200, target.sampleData)
//        },
//            method: target.method,
//            parameters: target.parameters,
//            httpHeaderFields: target.headers
//        )
//        
//        return endpoint.endpointByAddingAPIHeaders(target)
//    }
//    
//    final class func APIJSONEndpointMapping(_ target: Target) -> Endpoint {
//        let url = URL(
//            string: target.path,
//            relativeTo: target.baseURL
//            )?.absoluteString
//        let endpoint = Endpoint(
//            URL: url!,
//            sampleResponseClosure: {
//                return EndpointSampleResponse.networkResponse(200, target.sampleData)
//        },
//            method: target.method,
//            parameters: target.parameters,
//            parameterEncoding:URLEncoding.default
//        )
//        return endpoint.endpointByAddingAPIHeaders(target)
//    }
}

