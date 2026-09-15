//
//  ImageLoader.swift
//  CineListUIKit
//
//  Created by breno.farias on 15/09/26.
//

import UIKit

actor ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    func image(from url: URL) async -> UIImage? {
        if let cachedImage = cache.object(forKey: url as NSURL) { return cachedImage }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode),
                    let image = UIImage(data: data) else {
                return nil
            }
            
            cache.setObject(image, forKey: url as NSURL)
            return image
        } catch {
            return nil
        }
    }
}
