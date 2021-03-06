import UIKit
import SpriteKit


class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate {
    var scene: GameScene!
    var swiftris:SwifTris!
    
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    /// It keeps track of the last point on the screen at which a shape movement occurred or where a pan begins.
    var panPointReference:CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view.
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        self.scene = GameScene(size: skView.bounds.size)
        self.scene.scaleMode = .AspectFill
        
        self.scene.tick = didTick
        
        swiftris = SwifTris()
        swiftris.delegate = self
        swiftris.beginGame()
        
        // Present the scene.
        skView.presentScene(scene)
        
        
        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /// It lowers the falling shape by one row and then asks GameScene to redraw the shape at its new location.
    func didTick() {
        swiftris.letShapeFall()
    }
    
    func nextShape() {
        let newShapes = swiftris.newShape()
        if let fallingShape = newShapes.fallingShape {
            self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
            self.scene.movePreviewShape(fallingShape) {
                
                self.view.userInteractionEnabled = true
                self.scene.startTicking()
            }
        }
    }
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translationInView(self.view)
        if let originalPoint = panPointReference {
            
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                
                if sender.velocityInView(self.view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .Began {
            panPointReference = currentPoint
        }
    }
   
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        swiftris.rotateShape()
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        swiftris.dropShape()
    }
    
    /// Optional delegate method found in UIGestureRecognizerDelegate which will allow each gesture recognizer to work in tandem with the others. However, at times a gesture recognizer may collide with another.
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }

    /// Pan gesture recognizer take precedence over the swipe gesture and the tap to do likewise over the pan.
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        if let swipeRec = gestureRecognizer as? UISwipeGestureRecognizer {
            if let panRec = otherGestureRecognizer as? UIPanGestureRecognizer {
                return true
            }
        } else if let panRec = gestureRecognizer as? UIPanGestureRecognizer {
            if let tapRec = otherGestureRecognizer as? UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    func gameDidBegin(swiftris: SwifTris) {
        // The following is false when restarting a new game
        levelLbl.text = "\(swiftris.level)"
        scoreLbl.text = "\(swiftris.score)"
        scene.tickLengthMillis = TickLengthLevelOne

        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(swiftris: SwifTris) {
        view.userInteractionEnabled = false
        scene.stopTicking()
        scene.playSound("gameover.mp3")
        scene.animateCollapsingLines(swiftris.removeAllBlocks(), fallenBlocks: Array<Array<Block>>()) {
            swiftris.beginGame()
        }
    }
    
    func gameDidLevelUp(swiftris: SwifTris) {
        levelLbl.text = "\(swiftris.level)"
        if scene.tickLengthMillis >= 100 {
            scene.tickLengthMillis -= 100
        } else if scene.tickLengthMillis > 50 {
            scene.tickLengthMillis -= 50
        }
        scene.playSound("levelup.mp3")
    }
    
    func gameShapeDidDrop(swiftris: SwifTris) {
        scene.stopTicking()
        scene.redrawShape(swiftris.fallingShape!) {
            swiftris.letShapeFall()
        }
        scene.playSound("drop.mp3")
    }
    
    func gameShapeDidLand(swiftris: SwifTris) {
        scene.stopTicking()
        self.view.userInteractionEnabled = false
        
        let removedLines = swiftris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLbl.text = "\(swiftris.score)"
            scene.animateCollapsingLines(removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                
                self.gameShapeDidLand(swiftris)
            }
            scene.playSound("bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    
    func gameShapeDidMove(swiftris: SwifTris) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }

}
