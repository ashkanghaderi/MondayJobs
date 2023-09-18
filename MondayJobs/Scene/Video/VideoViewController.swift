//
//  VideoViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/11/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import UIKit
import TwilioVideo
import RxSwift
import RxCocoa
import Domain

class VideoViewController: BaseViewController {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var overlayToolsView: UIView!
    @IBOutlet weak var selfScreenView: VideoView!
    @IBOutlet weak var backBtnView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var agentPosition: UILabel!
    @IBOutlet weak var waittingLabel: UILabel!
    @IBOutlet weak var durationVIew: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var silentCallVIew: UIView!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var swapView: UIView!
    @IBOutlet weak var swapViewLabel: UILabel!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var voiceView: UIView!
    @IBOutlet weak var voiceBtn: UIButton!
    
    // Video SDK components
    var room: Room?
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var remoteView: VideoView?
    var viewModel: VideoViewModel!
    var timerIsPaused: Bool = false
    var timer: Timer?
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    public var didParticipantJoined = PublishSubject<Void>()
    deinit {
        // We are done with camera
        if let camera = self.camera {
            camera.stopCapture()
            self.camera = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        bindData()
        self.startPreview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            UIView.animate(withDuration: 0.8, animations: { [weak self] in
               
                self?.waittingLabel.isHidden = true
               
                self?.selfScreenView.frame = CGRect(x: (self?.view.frame.size.width)! - 175, y: 105, width: (self?.view.frame.size.width)! / 4.5, height: (self?.view.frame.size.height)!/4)
                
            })
        }

        if UIDevice.current.orientation.isPortrait {
            UIView.animate(withDuration: 0.8, animations: { [weak self] in
               
                self?.waittingLabel.isHidden = true
               
                self?.selfScreenView.frame = CGRect(x: (self?.view.frame.size.width)! - 120, y: 105, width: (self?.view.frame.size.width)! / 4, height: (self?.view.frame.size.height)!/4.5)
                
            })
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return self.room != nil
    }
    
    func setupUI(){
        
        [swapView,backBtnView,durationVIew,cameraView,voiceView].forEach({
            $0?.layer.cornerRadius = 16
            $0?.backgroundColor = AppColor.blur.withAlphaComponent(0.38)
        })
        silentCallVIew.layer.cornerRadius = 16
        silentCallVIew.backgroundColor = AppColor.red_100
        
        agentName.font = Fonts.Bold.Bold18()
        agentPosition.font = Fonts.Light.Light12()
        durationLabel.font = Fonts.Regular.Regular16()
        waittingLabel.font = Fonts.Regular.Regular16()
        swapViewLabel.font = Fonts.Regular.Regular16()
        
        [agentName,agentPosition,durationLabel,waittingLabel,swapViewLabel].forEach({
            $0?.textColor = UIColor.white
        })
        durationLabel.text = String(format:"%02i:%02i:%02i", 0, 0, 0)
        durationLabel.font = Fonts.Regular.Regular14()
        selfScreenView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.bringSubviewToFront(overlayToolsView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        overlayToolsView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func viewTapped() {
        
    }
    
    func startTimer(){
        timerIsPaused = false
        // 1. Make a new timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
          // 2. Check time to add to H:M:S
          if self.seconds == 59 {
            self.seconds = 0
            if self.minutes == 59 {
              self.minutes = 0
              self.hours = self.hours + 1
                self.updateTimerLabel()
            } else {
              self.minutes = self.minutes + 1
                self.updateTimerLabel()
            }
          } else {
            self.seconds = self.seconds + 1
            self.updateTimerLabel()
          }
        }
      }
    
    func updateTimerLabel(){
        durationLabel.text = String(format:"%02i:%02i:%02i", self.hours, self.minutes, self.seconds)
    }
    
    func bindData() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        
        let input = VideoViewModel.Input(disconnectTrigger: callBtn.rx.tap.asDriver(), backTrigger: backBtn.rx.tap.asDriver(), joinTrigger: viewWillAppear)
        
        let output = viewModel.transform(input: input)
        
        [output.joinAction.drive(VideoBinding),output.backAction.drive(),output.agentName.drive(agentName.rx.text),output.agentPosition.drive(agentPosition.rx.text),
         output.error.drive(errorBinding),output.isFetching.drive(fetchingBinding)].forEach { (item) in
            item.disposed(by: disposeBag)
         }
    }
    
    var VideoBinding: Binder<VideoModel> {
        return Binder(self, binding: { (vc, video) in
            
            vc.connect(token: video.token ?? "",roomId: video.room ?? "")
            
        })
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            if let eError = error as? EliniumError{
                vc.ShowSnackBar(snackModel: SnackModel(title: eError.localization , duration: 5))
            }
        })
    }
    var fetchingBinding: Binder<Bool> {
        return Binder(self, binding: { (vc, status) in
            
            if status == true {
                
            } else {
                
            }
        })
    }
    
    func setupRemoteVideoView() {
        // Creating `VideoView` programmatically
        
        self.remoteView = VideoView(frame: CGRect.zero, delegate: self)
        
        self.previewView.insertSubview(self.remoteView!, at: 0)
        
        // `VideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit
        // scaleAspectFit is the default mode when you create `VideoView` programmatically.
        self.remoteView!.contentMode = .scaleAspectFill;
        
        self.remoteView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.previewView.addConstraint(NSLayoutConstraint(item: self.remoteView!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.previewView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        self.previewView.addConstraint(NSLayoutConstraint(item: self.remoteView!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.previewView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        self.previewView.addConstraint(NSLayoutConstraint(item: self.remoteView!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.previewView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
        self.previewView.addConstraint(NSLayoutConstraint(item: self.remoteView!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.previewView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
        
    }
    
    func connect(token: String,roomId: String) {
        
        // Prepare local media which we will share with Room Participants.
        self.prepareLocalMedia()
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = ConnectOptions(token: token) { (builder) in
            
            // Use the local media that we prepared earlier.
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
            
            // Use the preferred audio codec
           // if let preferredAudioCodec = VideoSettings.shared.supportedAudioCodecs {
                builder.preferredAudioCodecs = [IsacCodec(),
                                                OpusCodec(),
                                                PcmaCodec(),
                                                PcmuCodec(),
                                                G722Codec()]
            //}
            
            // Use the preferred video codec
            //if let preferredVideoCodec = VideoSettings.shared.videoCodec {
                builder.preferredVideoCodecs = [H264Codec(),
                                                Vp8Codec(simulcast: true),
                                                H264Codec(),
                                                Vp9Codec()]
           // }
            
            // Use the preferred encoding parameters
           // if let encodingParameters = VideoSettings.shared.getEncodingParameters() {
               // builder.encodingParameters = EncodingParameters(audioBitrate: 600,
                                                               // videoBitrate: 600)
            //}
            
            // Use the preferred signaling region
            //if let signalingRegion = VideoSettings.shared.signalingRegion {
                builder.region = "us2"
           // }
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = roomId
        }
        
        // Connect to the Room using the options we provided.
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        
        logMessage(messageText: "Attempting to connect to room \(String(describing: ""))")
        
        self.showRoomUI(inRoom: true)
        
    }

    
    @IBAction func disconnect(sender: AnyObject) {
        self.room!.disconnect()
        logMessage(messageText: "Attempting to disconnect from room \(room!.name)")
    }
    
    @IBAction func toggleMic(sender: AnyObject) {
        if (self.localAudioTrack != nil) {
            self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
            
            // Update the button title
            if (self.localAudioTrack?.isEnabled == true) {
                // self.micButton.setTitle("Mute", for: .normal)
            } else {
                // self.micButton.setTitle("Unmute", for: .normal)
            }
        }
    }
    
    @IBAction func toggleVideo(sender: AnyObject) {
        if (self.localVideoTrack != nil) {
            self.localVideoTrack?.isEnabled = !(self.localVideoTrack?.isEnabled)!
            
            // Update the button title
            if (self.localVideoTrack?.isEnabled == true) {
                // self.micButton.setTitle("Mute", for: .normal)
            } else {
                // self.micButton.setTitle("Unmute", for: .normal)
            }
        }
    }
    
    func startPreview() {
        
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        
        if (frontCamera != nil || backCamera != nil) {
            
            let options = CameraSourceOptions { (builder) in
                if #available(iOS 13.0, *) {
                    // Track UIWindowScene events for the key window's scene.
                    // The example app disables multi-window support in the .plist (see UIApplicationSceneManifestKey).
                    builder.orientationTracker = UserInterfaceTracker(scene: UIApplication.shared.keyWindow!.windowScene!)
                }
            }
            // Preview our local camera track in the local video preview view.
            camera = CameraSource(options: options, delegate: self)
            localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")
            
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.selfScreenView)
            logMessage(messageText: "Video track created")
            
            if (frontCamera != nil && backCamera != nil) {
                // We will flip camera on tap.
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.flipCamera))
                self.previewView.addGestureRecognizer(tap)
            }
            
            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    self.logMessage(messageText: "Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                } else {
                    self.selfScreenView.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            self.logMessage(messageText:"No front or back capture device found!")
        }
    }
    
    @objc func flipCamera() {
        var newDevice: AVCaptureDevice?
        
        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }
            
            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        self.logMessage(messageText: "Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        self.selfScreenView.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }
    
    func prepareLocalMedia() {
        
        // We will share local audio and video when we connect to the Room.
        
        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")
            
            if (localAudioTrack == nil) {
                logMessage(messageText: "Failed to create audio track")
            }
        }
        
        // Create a video track which captures from the camera.
        if (localVideoTrack == nil) {
            self.startPreview()
        }
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
        print(messageText)
    }
    
    // Update our UI based upon if we are in a Room or not
    func showRoomUI(inRoom: Bool) {
        
        self.agentName.isHidden = inRoom
        self.agentPosition.isHidden = inRoom
        self.backBtnView.isHidden = inRoom
        self.durationVIew.isHidden = !inRoom
        self.silentCallVIew.isHidden = !inRoom
        self.cameraView.isHidden = !inRoom
        self.voiceView.isHidden = !inRoom
        //self.navigationController?.setNavigationBarHidden(inRoom, animated: true)
        UIApplication.shared.isIdleTimerDisabled = inRoom
        
        // Show / hide the automatic home indicator on modern iPhones.
        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
               publication.isTrackSubscribed {
                setupRemoteVideoView()
                subscribedVideoTrack.addRenderer(self.remoteView!)
                
                self.remoteParticipant = participant
                return true
            }
        }
        return false
    }
    
    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
               renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }
    
    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
    
}

// MARK:- RoomDelegate
extension VideoViewController : RoomDelegate {
    func roomDidConnect(room: Room) {
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        
        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
        
        self.cleanupRemoteParticipant()
        self.room = nil
        
        self.showRoomUI(inRoom: false)
    }
    
    func roomDidFailToConnect(room: Room, error: Error) {
        logMessage(messageText: "Failed to connect to room with error = \(String(describing: error))")
        self.room = nil
        
        self.showRoomUI(inRoom: false)
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }
    
    func roomDidReconnect(room: Room) {
        logMessage(messageText: "Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self
        
        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
        
        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
}

// MARK:- RemoteParticipantDelegate
extension VideoViewController : RemoteParticipantDelegate {
    
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
    }
    
    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
        
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }
    
    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
        
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.
        
        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.
        
        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        //self.localAudioTrack?.isEnabled = true
        self.selfScreenView.layer.cornerRadius = 10
        UIView.animate(withDuration: 0.8, animations: { [weak self] in
           
            self?.waittingLabel.isHidden = true
           
            self?.selfScreenView.frame = CGRect(x: (self?.view.frame.size.width)! - 120, y: 105, width: (self?.view.frame.size.width)! / 4, height: (self?.view.frame.size.height)!/4.5)
            
        }) { [weak self] _ in
            self?.startTimer()
        }
        
        if (self.remoteParticipant == nil) {
            _ = renderRemoteParticipant(participant: participant)
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        
        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()
            
            UIView.animate(withDuration: 0.4, animations: { [weak self] in
               
                self?.waittingLabel.isHidden = true
                self?.selfScreenView.layer.cornerRadius = 0
                self?.selfScreenView.frame = (self?.view.frame)!
                
                
            }) { [weak self] _ in
                self?.startTimer()
            }
            
            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
               let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }
    
    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
        
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        
        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }
    
    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }
    
    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }
    
    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// MARK:- VideoViewDelegate
extension VideoViewController : VideoViewDelegate {
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.previewView.setNeedsLayout()
    }
}

// MARK:- CameraSourceDelegate
extension VideoViewController : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
    }
}

extension Reactive where Base: VideoViewController {
    

    internal var didJoin: ControlEvent<Void> {
        
        return ControlEvent(events: self.base.didParticipantJoined)
        
    }
}

