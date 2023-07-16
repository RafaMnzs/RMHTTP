//
//  RMDispatcher.swift
//  
//
//  Created by Rafael Menezes on 12/07/23.
//

import Foundation

protocol RMDispatcherProtocol {
    func execute<T: Codable>(_ request: RMRequest, to type: T.Type, debug: Bool?, completion: @escaping(Result<T, Error>) -> Void)
}

public class RMDispatcher: RMDispatcherProtocol {

   public static var shared: RMDispatcher = {
        let instance = RMDispatcher()
        return instance
    }()

    public func execute<T: Decodable>(_ request: RMRequest, to type: T.Type, debug: Bool? = false, completion: @escaping (Result<T, Error>) -> Void) {
        var config = NSMutableURLRequest()
        guard let host = request.host else { return }
        config.url = URL(string: "\(host)\(request.path)")
        header(header: request.header, config: &config)

        switch request.method {
        case .GET:
            config.httpMethod = "GET"
            query(query: request.params, config: &config)
        case .POST:
            config.httpMethod = "POST"
            config.httpBody = try? JSONSerialization.data(withJSONObject: request.body as Any, options: .prettyPrinted)
        case .PUT:
            config.httpMethod = "PUT"
            config.httpBody = try? JSONSerialization.data(withJSONObject: request.body as Any, options: .prettyPrinted)
        case .DELETE:
            config.httpMethod = "DELETE"
            config.httpBody = try? JSONSerialization.data(withJSONObject: request.body as Any, options: .prettyPrinted)
        }

        let session = URLSession.shared
        session.dataTask(with: config as URLRequest, completionHandler: { data, response, error  in
            if error != nil {
                if let err = error {
                    completion(.failure(err))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }

            guard 200 ..< 300 ~= httpResponse.statusCode else {
                completion(.failure(RMStatus(statusCode: httpResponse.statusCode)))
                return
            }

            DispatchQueue.main.async {
                do {
                    guard let data = data else { return }
                    self.show(debug: debug, content: data)
                    let content = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(content))
                } catch {
                    completion(.failure(error))
                }
            }
        }).resume()
    }
}

private extension RMDispatcher {

    private func header(header: [String: AnyHashable]?, config: inout NSMutableURLRequest) {
        guard let params = header else { return }
        for (key, value) in params {
            config.addValue(value.description, forHTTPHeaderField: key)
        }
    }

    private func query(query: [String: AnyHashable]?, config: inout NSMutableURLRequest) {
        guard let queries = query else { return }
        var components = URLComponents()
        for (key, value) in queries {
            components.queryItems?.append(URLQueryItem(name: key.description, value: value.description))
        }
    }

    private func show(debug: Bool?, content: Data?) {
        guard let debug = debug,
              let content = content
                else {
                    return
                }

        if debug {
            print("<=============== RESPONSE ===============>")
            guard let str = content.prettyPrintedJSONString else {
                return
            }
            debugPrint(str)
        }
    }
}
