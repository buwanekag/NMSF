//
//  ImageService.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/12/21.
//

import AlamofireImage
import Foundation


struct ImageService {
    static let shared: ImageService = ImageService()

    let imageDownloader: ImageDownloader

    private init() {
        imageDownloader = ImageDownloader(
            configuration: URLSessionConfiguration.default,
            downloadPrioritization: .fifo,
            maximumActiveDownloads: 10,
            imageCache: AutoPurgingImageCache(memoryCapacity: 209_715_200, preferredMemoryUsageAfterPurge: 209_715_200)
        )
    }

    func cachedImage(url: URL?) -> UIImage? {
        guard let url = url else {
            return nil
        }
        let urlRequest = URLRequest(url: url)

        guard let image = imageDownloader.imageCache?.image(for: urlRequest, withIdentifier: urlRequest.url?.absoluteString.components(separatedBy: "?")[0]) else {
            return nil
        }
        return image
    }
}
