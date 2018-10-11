//
//  main.swift
//  subway_downloader
//
//  Created by Ivan Murashov on 07.10.2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import Foundation

private var key: String {
    
    guard  let dict = NSDictionary(contentsOfFile: "token.plist") else {
        print("File with key does not exists")
        exit(1)
    }
    
    guard let apiKey = dict["ApiKey"] else {
        print("ApiKey does not exists")
        exit(1)
    }
    
    print("ApiKey: \(apiKey)")
    return apiKey as! String
}

private let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

private let output = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("stations")

private let semaphore = DispatchSemaphore(value: 0)

private func load(nextPageToken: String?) {
    let request = NSMutableURLRequest(url: buildURL(nextPageToken))
    print("Make request: \(request.url!)")
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        if error != nil {
            print(error!)
        } else if data != nil {
            handleResponse(data!)
        }
    }
    task.resume()
}

private func buildURL(_ pageToken: String?) -> URL {
    var urlComponents: URLComponents = URLComponents(string: urlString)!
    if pageToken != nil {
        urlComponents.queryItems = [URLQueryItem(name: "key", value: key),
                                    URLQueryItem(name: "pagetoken", value: pageToken)]
    } else {
        urlComponents.queryItems = [URLQueryItem(name: "location", value: "55.753960,37.620393"),
                                    URLQueryItem(name: "type", value: ""),
                                    URLQueryItem(name: "keyword", value: ""),
                                    URLQueryItem(name: "radius", value: "500"),
                                    URLQueryItem(name: "key", value: key)]
    }
    return urlComponents.url!
}

private func handleResponse(_ dataResponse: Data) {
    do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(Response.self, from: dataResponse) as Response
        print("\(response.results.count) was loaded")
        
        if response.results.count > 0 {
            for station in response.results {
                writeToFile(buildString(station))
            }
        }
        
        if response.next_page_token != nil {
            sleep(2)    // sleep between requests
            load(nextPageToken: response.next_page_token)
        } else {
            semaphore.signal();
        }
        
    } catch let err {
        print(err)
    }
}

private func writeToFile(_ str: String) {
//    print(str)
    if !FileManager.default.fileExists(atPath: output.path) {
        FileManager.default.createFile(atPath: output.path, contents: nil)
    }
    
    do {
        let fileHandle = try FileHandle(forWritingTo: output)
        fileHandle.seekToEndOfFile()
        fileHandle.write(str.data(using: .utf8)!)
        fileHandle.closeFile()
    } catch let err {
        print(err)
    }
}

private func buildString(_ station: Station) -> String {
    return "\(station.name),\(station.getLat()),\(station.getLng())\n"
}

private struct Response: Codable {
    let next_page_token: String?
    let results: [Station]
}

private struct Station: Codable {
    let name: String
    let geometry: Geometry
    
    func getLat() -> Double {
        return geometry.location.lat
    }
    
    func getLng() -> Double {
        return geometry.location.lng
    }
}

private struct Geometry: Codable {
    let location: Location
}

private struct Location: Codable {
    let lat: Double
    let lng: Double
}

private enum TokenError: Error {
    case fileDoesNotExist
    case apiKeyDoesNotExist
}

load(nextPageToken: nil)
semaphore.wait()
