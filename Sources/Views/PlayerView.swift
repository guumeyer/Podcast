//
//  PlayerView.swift
//  Podcast
//
//  Created by Meyer, Gustavo on 7/17/19.
//  Copyright © 2019 Meyer Systems. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

final class PlayerView: UIView {
    /// The playlist
    private var playList = [Episode]()
    /// The episode
    private var episode: Episode! {
        didSet {
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            miniTitleLabel.text = episode.title
            
            setupSessionAudio()
            playEpisode()
            setupNowPlayinfo(for: episode)
            
            episodeImageView.image = nil
            miniEpisodeImageView.image = nil
            guard let imageUrl = episode.image else {
                print("Not found image")
                return
            }
            
            miniEpisodeImageView.load(url: imageUrl){[weak self] (image) in
                guard let image = image else {
                    print("miniEpisodeImageView.load:: nil")
                    return
                }
                
                self?.episodeImageView.image = image
                self?.setupNowPlayinfoArtwork(image)
            }
        }
    }
    
    /// The player track directions to play the next or preview audio
    ///
    /// - next: the next track in the playlist
    /// - preview: the preview track in the playlist
    private enum PlayerMoveForward {
        case next
        case preview
    }
    private let seek: Int64 = 15
    private static let scale: CGFloat = 0.7
    private static let scaleEpisodeImageView  = CGAffineTransform(scaleX: PlayerView.scale, y: PlayerView.scale)
    private var mainController: MainTabController? {
        return UIApplication.mainController()
    }
    /// The player
    private let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    /// Loads PlayerView
    ///
    /// - Returns: an instance of PlayerView
    static func instanceFromNib() -> PlayerView {
        return Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as! PlayerView
    }

    // MARK: - Mini Player IBOutlet
    
    @IBOutlet weak var miniEpisodeImageView: UIURLImageView!
    @IBOutlet weak var miniTitleLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayAndPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniFastForwardButton: UIButton!

    // MARK: - Maximize Player IBOutlet
    @IBOutlet weak var maximazePlayer: UIStackView!
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentiTimeSlider: UISlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIURLImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            episodeImageView.transform = PlayerView.scaleEpisodeImageView
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!  {
        didSet {
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var playAndPauseButton: UIButton! {
        didSet {
            playAndPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            playAndPauseButton.addTarget(self, action: #selector(handlePlayAndPause), for: .touchUpInside)
        }
    }

    @IBAction func handleDismissAction(_ sender: Any) {
        mainController?.minimazePlayerViewAnimation()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupRemoteControl()
        setupGesture()
        setupInterruptionObserver()

        addPeriodicTimeObserver()
        addBoundaryTimeObserver()
    }

    /// Prepares the player
    ///
    /// - Parameters:
    ///   - episode: the episode
    ///   - playlist: the playlist
    func prepare(by episode: Episode, _ playlist: [Episode] = []) {
        self.playList = playlist
        self.episode = episode
    }

    @objc private func handleTapMaximizePlayer() {
        mainController?.maximizePlayerViewAnimation()
    }

    @objc private func handlePan(gestore: UIPanGestureRecognizer) {
        switch gestore.state {
        case .changed:
            handletPanChanged(gestore)
        case .ended:
            handlePanEnded(gestore)
        default:
            break
        }
    }

    @objc private func handlePanDismissal(gestore: UIPanGestureRecognizer) {
        switch gestore.state {
        case .changed:
            let translation = gestore.translation(in: superview)
            maximazePlayer.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gestore.translation(in: superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maximazePlayer.transform = .identity
                if translation.y > 50 {
                   self.mainController?.minimazePlayerViewAnimation()
                }
            });
        default:
            break
        }
    }

    @objc func handlePlayAndPause() {
        switch player.timeControlStatus {
        case .paused:
            handlePlayAction()
        default:
            handlePauseAction()
        }
    }

    @IBAction func handleCurrenTimeSlider(_ sender: Any) {
        guard let durantion = player.currentItem?.duration else { return }
        let percentage = Float64(currentiTimeSlider.value)
        let durantionSeconds = CMTimeGetSeconds(durantion)
        let seekTimeInSeconds = percentage * durantionSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        updateElapsedPlaybackTime(for: seekTimeInSeconds)
        player.seek(to: seekTime)
    }

    @IBAction func handleRewind(_ sender: Any) {
        seekToCurrentTime(for: seek)
    }

    @IBAction func handleFastFoward(_ sender: Any) {
        seekToCurrentTime(for: -seek)
    }

    @IBAction func handleVolumeChanges(_ sender: UISlider) {
        player.volume = sender.value
    }

    @objc func handleAudioRouteChanged(note: Notification) {
        if let userInfo = note.userInfo {
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? Int {
                if reason == AVAudioSession.RouteChangeReason.oldDeviceUnavailable.hashValue {
                    print("Headphones plugged out: pause audio")
                    handlePauseAction()
                }
            }
        }
    }

    // MARK: - Setups
    private func setupSessionAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("Failed to activate session audio: ", error)
        }
    }

    private func audioRouteChangedObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioRouteChanged),
            name: AVAudioSession.routeChangeNotification,
            object: nil)
    }

    private func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action: #selector(handleCommanderCenterPlayTrack))

        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget(self, action: #selector(handleCommanderCenterPauseTrack))
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(handleCommanderCenterTogglePlayPause))
        
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleCommanderCenterNextTrack))
    }
    
    private func setupInterruptionObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }

    // MARK: - Handler CommanderCenter
    @objc private func handleCommanderCenterNextTrack() {
        print("CommanderCenter: NextTrack")
        changeTrack(.next)
    }
    
    @objc private func handleCommanderCenterPreviewTrack() {
        print("CommanderCenter: PreviewTrack")
        changeTrack(.preview)
    }
    
    @objc private func handleCommanderCenterPlayTrack() {
        print("CommanderCenter: Play")
        handlePlayAction()
        setupNowPlayinfoElapsedPlaybackTime()
    }
    
    @objc private func handleCommanderCenterPauseTrack() {
        print("CommanderCenter: Pause")
        handlePauseAction()
        setupNowPlayinfoElapsedPlaybackTime()
    }

    @objc private func handleCommanderCenterTogglePlayPause() {
        // Headset button
        print("CommanderCenter: TogglePlayPause")
        if player.timeControlStatus == .playing {
            handlePauseAction()
        } else if  player.timeControlStatus == .paused {
            handlePlayAction()
        }
    }
    
    // MARK: - Interruption
    @objc private func handleInterruption(notification: Notification){
        print("AVAudioSession.interruptionNotification")
        guard let userInfo = notification.userInfo,
            let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        
        if type == AVAudioSession.InterruptionType.began.rawValue {
            handlePauseUiAction()
        } else if type == AVAudioSession.InterruptionType.ended.rawValue,
            let option = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt,
                option != AVAudioSession.InterruptionOptions.shouldResume.rawValue {
            handlePlayAction()
        }
    }
    
    private func changeTrack(_ move: PlayerMoveForward) {
        // TODO: implement Episode UUID instead search for title
        guard playList.count > 1,
            let currentEpisodeIndex = playList.firstIndex(where: { $0.id == episode.id }) else { return }
        let offset = move == .next ? 1 : playList.count - 1
        let nextEpisodeIndex = (currentEpisodeIndex + offset) % playList.count
        episode = playList[nextEpisodeIndex]
    }
    
    private func setupGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximizePlayer)))
        miniPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        maximazePlayer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanDismissal)))
    }

    // MARK: - Pan
    private func handlePanEnded(_ gestore: UIPanGestureRecognizer) {
        let translation = gestore.translation(in: superview)
        let velocity = gestore.velocity(in: superview)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity

            if translation.y < -200 || velocity.y < -500 {
                self.mainController?.maximizePlayerViewAnimation()
            } else {
                self.miniEpisodeImageView.alpha = 1
                self.maximazePlayer.alpha = 0
            }
        })
    }

    private func handletPanChanged(_ gestore: UIPanGestureRecognizer) {
        let translation = gestore.translation(in: superview)
        transform = CGAffineTransform(translationX: 0, y: translation.y)

        miniEpisodeImageView.alpha = 1 + translation.y / 200
        maximazePlayer.alpha = -translation.y / 200
    }

    // MARK: - Now Playing Info
    private func setupNowPlayinfo(for: Episode) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func setupNowPlayinfoArtwork(_ image: UIImage) {
        let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> UIImage in
            return image
        })
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
    }

    private func setupNowPlayinfoCurrentTime() {
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
    }
    
    private func setupNowPlayinfoElapsedPlaybackTime() {
        let elapseTime = CMTimeGetSeconds(player.currentTime())
        updateElapsedPlaybackTime(for: elapseTime)
    }
    
    private func updateElapsedPlaybackTime(for elapseTime: Float64) {
       MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapseTime
    }

    // MARK: - Player observer
    private func addPeriodicTimeObserver() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {[weak self] (time) in
            guard let strongSelf = self else { return }
            strongSelf.currentTimeLabel.text = time.formartDisplay()
            strongSelf.durationLabel.text = strongSelf.player.currentItem?.duration.formartDisplay()
            strongSelf.updateCurrentTimeSlider()
        }
    }

    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durantionSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durantionSeconds

        currentiTimeSlider.value = Float(percentage)
    }

    private func addBoundaryTimeObserver() {
        //Observer when player will start to play the audio
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            // The audio streaming is playing
            self?.enlargeEpisodeImageViewAnimation()
            self?.setupNowPlayinfoCurrentTime()
        }
    }

    // MARK: - Animation
    private func enlargeEpisodeImageViewAnimation() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        })
    }

    private func scaleEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.episodeImageView.transform = PlayerView.scaleEpisodeImageView
        })
    }

    // MARK: - Player action
    private func handlePlayAction() {
        playAndPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        player.play()
        enlargeEpisodeImageViewAnimation()
    }

    private func handlePauseAction() {
        player.pause()
        handlePauseUiAction()
    }
    
    private func handlePauseUiAction() {
        playAndPauseButton.setImage(UIImage(named: "play"), for: .normal)
        miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
        scaleEpisodeImageView()
    }

    // MARK: - Helper
    private func seekToCurrentTime(for delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeSubtract(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }

    private func playEpisode() {
        guard let url = URL(string: episode.mediaUrl) else {
            return
        }

        let playItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playItem)
        player.play()
    }
}
