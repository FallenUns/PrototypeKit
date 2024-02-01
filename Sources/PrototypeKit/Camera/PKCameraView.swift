//
//  PKCameraView.swift
//
//
//  Created by James Dale on 1/2/2024.
//

import SwiftUI
import AVFoundation

protocol PKCameraViewReceiver {
    func recieveBuffer(_ buffer: CMSampleBuffer)
}

public struct PKCameraView: UIViewControllerRepresentable {
    
    private var receiver: PKCameraViewReceiver?
    
    public init() {}
    
    init(receiver: PKCameraViewReceiver) {
        self.receiver = receiver
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator.cameraViewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self, receiver: receiver)
        coordinator.setupReceiver()
        return coordinator
    }
    
    public class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        
        var cameraView: PKCameraView
        
        var receiver: PKCameraViewReceiver?
        
        var cameraViewController = CameraViewController()
        
        private let receiverQueue = DispatchQueue(label: "receiverQueue")
        
        init(_ cameraView: PKCameraView, receiver: PKCameraViewReceiver?) {
            self.cameraView = cameraView
            self.receiver = receiver
        }
        
        func setupReceiver() {
            guard receiver != nil else { return }
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: receiverQueue)
            cameraViewController.addOutput(output)
        }
        
        public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            receiver?.recieveBuffer(sampleBuffer)
        }
    }
}