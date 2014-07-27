// Playground: SceneKit

import Cocoa
import SceneKit
import QuartzCore // for the basic animation
import XCPlayground // for the live preview

// create a scene view with an empty scene
var sceneView = SCNView(frame:CGRect(x:0, y:0, width:300, height:300))
// New scene
var scene = SCNScene()
// Connect the scene to the view
sceneView.scene = scene

// Start a live preview of the scene
XCPShowView("The Scene View", sceneView)

// Default lighting
sceneView.autoenablesDefaultLighting = true

// Camera
var camera = SCNCamera()
var cameraNode = SCNNode()
cameraNode.camera = camera
cameraNode.position = SCNVector3(x:0, y:0, z:3)
// Connect the camera to the scene
scene.rootNode.addChildNode(cameraNode)

// Geometry object
var torus = SCNTorus(ringRadius: 1, pipeRadius: 0.35)
var torusNode = SCNNode(geometry: torus)
// Connect the object to the scene
scene.rootNode.addChildNode(torusNode)

