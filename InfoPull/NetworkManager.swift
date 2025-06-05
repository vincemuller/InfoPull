import Foundation
import SwiftUI
import CreateML
import Vision
import CoreML


class NetworkManager {
    
    private var apiToken: String = "d7ec475b45d3857d171a283e336ed6cc77d14c835943747a9ceec549e0f0b6ef"
    var artefactIDs: [Int] = []
    var artefactImages: [ArtefactPreviewResponse] = []
    
    init() {}
    
    private let base: String = "https://uat-api.redeyedms.com/"
    private let decoder = JSONDecoder()
    
    private func previewImageRequest(artefactID: Int) async throws {
        
        let endPoint: String = "api/v1/artefacts/\(artefactID)/preview"
        
        var request = URLRequest(url: URL(string: base + endPoint)!,timeoutInterval: Double.infinity)

        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let decodedData = try decoder.decode(ArtefactPreviewResponse.self, from: data)
            artefactImages.append(decodedData)
            
            downloadImage(from: URL(string: decodedData.url)!) { image in
                do {
                    try self.detectTitleBlock(from: image!)
                } catch let error {
                    print(error)
                }
            }
            
        } catch {
            print("Decoding error")
        }
    }
    
    func getPreviewImages() async {
        for artefact in artefactIDs {
            Task {
                do {
                    try await previewImageRequest(artefactID: artefact)
                } catch {
                    print("Error")
                }
            }
        }
        
    }
    
    func getArtefactsByGroup(groupdID: Int = 86157) async throws {
        
        batchReset()
        
        let endPoint: String = "api/v1/search"

        var request = URLRequest(url: URL(string: base + endPoint)!)

        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let parameters = ["advanced": ["and": [
            [
              "exact": true,
              "property": "group",
              "value": groupdID,
              "relation": "intersects"
            ]
          ]]] as [String : Any]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
        }

        let (data, _) = try await URLSession.shared.data(for: request)

        do {
            let decodedData = try decoder.decode(GetArtefactsResponse.self, from: data)

            for i in decodedData.results {
                artefactIDs.append(i.id)

                print(i.id.description)
            }
        } catch {
            print("decoding error")
        }
    }
    
    private func batchReset() {
        artefactImages.removeAll()
        artefactIDs.removeAll()
    }
    
    
    //CoreML and Vision Functions
    
    func downloadImage(from url: URL, completion: @escaping (CGImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let nsImage = NSImage(data: data),
                  let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                completion(nil)
                return
            }
            completion(cgImage)
        }.resume()
    }
    
    
    func detectTitleBlock(from cgImage: CGImage) throws {
        
        guard let resizedImage = resizeCGImage(cgImage, to: CGSize(width: 932, height: 932)) else {
            return
        }
        
        let model = try VNCoreMLModel(for: HawkEye_Model(configuration: .init()).model)
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("No results or wrong result type")
                print(error?.localizedDescription)
                return
            }

            for result in results {
                print("Label: \(result.labels.first?.identifier ?? "Unknown")")
                print("Confidence: \(result.confidence)")
                print("Bounding Box: \(result.boundingBox)")
                let cropImage = self.cropImage(cgImage, to: result.boundingBox)
                self.performOCR(on: cropImage!) { texts in
                    var t = texts
                    var u = texts.filter({!$0.contains("Drawing")})
                    print("OCR Texts found: \(u)")
                    // Here you can parse and assign the OCR text data to your metadata model
                }
            }
        }
        

        let handler = VNImageRequestHandler(cgImage: resizedImage, options: [:])
        try handler.perform([request])
    }
    
    func resizeCGImage(_ image: CGImage, to size: CGSize) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        ) else { return nil }

        context.interpolationQuality = .high
        context.draw(image, in: CGRect(origin: .zero, size: size))
        return context.makeImage()
    }
    
    func performOCR(on cgImage: CGImage, completion: @escaping ([String]) -> Void) {
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("OCR error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            // Extract recognized text strings
            let recognizedStrings = observations.compactMap { observation in
                // Get the top candidate string
                observation.topCandidates(1).first?.string
            }
            completion(recognizedStrings)
        }
        
        request.recognitionLevel = .accurate  // or .fast for faster but less accurate
        request.usesLanguageCorrection = true // Helps fix common OCR mistakes
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                print("Failed to perform OCR request: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func cropImage(_ image: CGImage, to boundingBox: CGRect) -> CGImage? {
        let width = CGFloat(image.width)
        let height = CGFloat(image.height)

        let rect = CGRect(
            x: boundingBox.origin.x * width,
            y: (1 - boundingBox.origin.y - boundingBox.height) * height, // flip y-axis
            width: boundingBox.width * width,
            height: boundingBox.height * height
        ).integral

        return image.cropping(to: rect)
    }
    
    func appendToCSV(fileURL: URL, data: [[String]]) {
        let rows = data.map { $0.joined(separator: ",") }.joined(separator: "\n")
        if let handle = try? FileHandle(forWritingTo: fileURL) {
            handle.seekToEndOfFile()
            if let rowData = ("\n" + rows).data(using: .utf8) {
                handle.write(rowData)
            }
            try? handle.close()
        } else {
            try? rows.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }
}
