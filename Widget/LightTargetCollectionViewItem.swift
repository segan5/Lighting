import Cocoa
import LIFXHTTPKit

class LightTargetCollectionViewItem: NSCollectionViewItem, LightTargetControlViewDelegate {
	@IBOutlet weak var controlView: LightTargetControlView?
	@IBOutlet weak var labelTextField: NSTextField?

	var lightTarget: LightTarget { return representedObject as! LightTarget }
	var observer: LightTargetObserver!

	override func viewWillAppear() {
		super.viewWillAppear()

		updateUI()
		observer = lightTarget.addObserver { [unowned self] in
			dispatch_async(dispatch_get_main_queue()) {
				self.updateUI()
			}
		}
		controlView?.delegate = self
	}

	override func viewWillDisappear() {
		super.viewWillDisappear()

		lightTarget.removeObserver(observer)
		controlView?.delegate = nil
	}

	private func updateUI() {
		if lightTarget.connected {
			if lightTarget.power {
				controlView?.setPower(true, animated: true)
				//controlView?.layer?.backgroundColor = NSColor.whiteColor().CGColor
			} else {
				controlView?.setPower(false, animated: true)
				//controlView?.layer?.backgroundColor = NSColor.blackColor().CGColor
			}
			controlView?.layer?.opacity = 1.0
			controlView?.enabled = true
		} else {
			controlView?.layer?.backgroundColor = NSColor.darkGrayColor().CGColor
			controlView?.layer?.opacity = 0.2
			controlView?.enabled = false
		}
		labelTextField?.stringValue = lightTarget.label
	}

	// MARK: LightControlViewDelegate

	func controlViewDidGetClicked(view: LightTargetControlView) {
		lightTarget.setPower(!lightTarget.power, duration: 0.5)
	}
}
