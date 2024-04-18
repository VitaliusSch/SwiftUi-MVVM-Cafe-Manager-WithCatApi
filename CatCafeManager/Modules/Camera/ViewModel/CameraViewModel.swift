//
//  CameraModel.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 10.01.2023.
//

import Foundation
import AVFoundation
import SwiftUI

final class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var photoData = Data(count: 0)
    
    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp() {
        do {
            self.session.beginConfiguration()
         
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video,
                                                       position: .back) else {
                return
            }
            let input = try AVCaptureDeviceInput(device: device)
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            } else {
                // TODO: input not taken
            }
            if self.session.canAddOutput(output) {
                self.session.addOutput(output)
            }
            self.session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func takePhoto() {
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        // this delay is needed for stopRunning after the capturePhoto
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.session.stopRunning()
            withAnimation {
                self.isTaken.toggle()
            }
        }
    }
 
    func reTake() {
        session.startRunning()
        DispatchQueue.main.async {
            withAnimation {
                self.isTaken.toggle()
            }
        }
        photoData=Data(count: 0)
    }
 
    nonisolated func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
         if error != nil {
             return
         }
         guard let imageData = photo.fileDataRepresentation() else {
             return
         }
        DispatchQueue.main.async {
            self.photoData = imageData
        }
     }
    func getPhoto() -> UIImage? {
        UIImage(data: self.photoData)
    }
}
