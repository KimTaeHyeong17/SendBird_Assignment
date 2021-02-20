//
//  ImageCacheManager.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import UIKit

class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
    
}

class UrlImageManager {
    
    static let shared = UrlImageManager()
    
    public func getImage(url: String, completion: @escaping (UIImage) -> ()) {
        ///get from memory cache
        getImageFromMemory(url) { (image) in
            if let image = image {
//                print("get from memory     \(url)")
                completion(image)
            }else {
                ///get from disk cache
                ///save to memory cache
                self.getImageFromDisk(url: url) { (image) in
                    if let image = image {
//                        print("get from disk       \(url)")
                        completion(image)
                        self.saveAtMemory(url: url, image: image)
                    }else {
                        ///get from url
                        ///save to disk cahce
                        ///save to memory cache
                        self.downloadUrlImage(url: url) { (image) in
                            completion(image)
//                            print("download from url   \(url)")
                            self.saveAtMemory(url: url, image: image)
                            self.saveAtDisk(url: url, image: image)
                        }
                    }
                }
            }
        }
    }
    
    private func getImageFromMemory(_ url: String, completion: @escaping (UIImage?) -> ()) {
        let cacheKey = NSString(string: url) // 캐시에 사용될 Key 값
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) { // 해당 Key 에 캐시이미지가 저장되어 있으면 이미지를 사용
            completion(cachedImage)
        } else {
            completion(nil)
        }
    }
    
    private func getImageFromDisk(url: String, completion: @escaping (UIImage?) -> ()) {
        let fileManager = FileManager.default
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        else { return }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(URL(string:url)!.lastPathComponent)
        if fileManager.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath) else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }else {
            completion(nil)
        }
    }
    
    private func saveAtMemory(url: String, image: UIImage) {
        DispatchQueue.global(qos: .background).async {
            let cacheKey = NSString(string: url) // 캐시에 사용될 Key 값
            ImageCacheManager.shared.setObject(image, forKey: cacheKey) // 다운로드된 이미지를 캐시에 저장
//            print("save to memory      \(url)")
        }
    }
    
    private func saveAtDisk(url: String, image: UIImage) {
        DispatchQueue.global(qos: .background).async {
            guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
                return
            }
            let fileManager = FileManager.default
            var filePath = URL(fileURLWithPath: path)
            filePath.appendPathComponent(URL(string:url)!.lastPathComponent)
            fileManager.createFile(atPath: filePath.path, contents: image.pngData() , attributes: nil)
//            print("save to disk        \(filePath)")
        }
    }
    
    private func downloadUrlImage(url: String, completion: @escaping (UIImage) -> ()){
        DispatchQueue.global(qos: .background).async {
            if let imageUrl = URL(string: url) {
                URLSession.shared.dataTask(with: imageUrl) { (data, res, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        DispatchQueue.main.async {
                            completion(UIImage())
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data, let image = UIImage(data: data) {
                            completion(image)
                        }
                    }
                }.resume()
            }
        }
    }
    
}
