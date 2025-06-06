import Foundation
import SwiftUI
import CreateML
import Vision
import CoreML


class NetworkManager: ObservableObject {
    @Published var extractedData: [FileData] = []
    @Published var croppedImage: CGImage?

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
    
    
    func detectTitleBlock(from cgImage: CGImage, filename: String) throws {
        
        guard let resizedImage = resizeCGImage(cgImage, to: CGSize(width: 600, height: 600)) else {
            return
        }
        
        let model = try VNCoreMLModel(for: InfoPull_Model(configuration: .init()).model)
        let dispatchGroup = DispatchGroup()
        
        var record = FileData(filename: filename, drawingNumber: "", drawingTitle: "", project: "", revision: "")
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("No results or wrong result type")
                print(error?.localizedDescription ?? "Unknown error")
                return
            }

            for result in results {
                
                let label = result.labels.first?.identifier
                let cropImage = self.cropImage(cgImage, to: result.boundingBox)
                guard let cropped = cropImage else { continue }

                dispatchGroup.enter()
                self.performOCR(on: cropped) { texts in
                    let u = texts.filter { text in
                        !text.lowercased().contains("rawin") &&
                        !text.lowercased().contains("blatt") &&
                        !text.lowercased().contains("roject:")
                    }

                    if label == "drawingNumber" {
                        record.drawingNumber = u.joined(separator: " ")
                    } else if label == "drawingTitle" {
                        record.drawingTitle = u.joined(separator: " ")
                    } else if label == "project" {
                        record.project = u.joined(separator: " ")
                    } else if label == "revision" && u.contains("Revision") {
                        record.revision = u.joined(separator: " ")
                        self.croppedImage = cropImage
                    } else {
                        
                    }

                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.extractedData.append(record)
                print("Finished processing record: \(record)")
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
