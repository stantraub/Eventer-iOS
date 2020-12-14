//
//  Service.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/9/20.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Service {
    static func fetchEvents(completion: @escaping(Result<[Event], Error>) -> Void) {
        let endpoint = "https://api.seatgeek.com/2/events?client_id=MjE0MjczMzF8MTYwNzU4MjU1NC4zODc2NDA3"
        
        AF.request(endpoint).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let json = try JSON(data: data)
                let decoder = JSONDecoder()
                let events = try decoder.decode([Event].self, from: try json["events"].rawData())
                completion(.success(events))
            } catch let jsonErr {
                completion(.failure(DecodingError.failedToDecode(error: jsonErr)))
            }
        }
    }
    
    public enum DecodingError: Error {
        case failedToDecode(error: Error)
        
        public var localizedDescription: String {
            switch self {
            case .failedToDecode(let error):
                return "Failed to decode: \(error)"
            }
        }
    }
}
