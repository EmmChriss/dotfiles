# Detection
# ‾‾‾‾‾‾‾‾‾‾

hook global BufCreate .*\.gd %{
	set-option buffer filetype gdscript
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook -group gdscript-highlight global WinSetOption filetype=gdscript %{
	add-highlighter window/gdscript ref gdscript
	hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/gdscript }
}

# Highlighters & Completion
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/gdscript regions
add-highlighter shared/gdscript/code default-region group
add-highlighter shared/gdscript/double_string region @?(?<!')" (?<!\\)(\\\\)*"B? fill string
add-highlighter shared/gdscript/single_string region @?(?<!')' (?<!\\)(\\\\)*'B? fill string
add-highlighter shared/gdscript/comment-line region '#' '$' fill comment

### FUNCTIONS
add-highlighter shared/gdscript/code/ regex '([_a-zA-Z][_a-zA-Z0-9]*(?=\())' 0:function

### VARIABLES
# add-highlighter shared/gdscript/code/ regex '(?<=[\h(])\w*((?=\.\w)|(?=\[\w))' 0:variable
# add-highlighter shared/gdscript/code/ regex '(^\h*|(?<=\w)\h+|(?<=;)\h*)\w*\h*((?=;)|(?==)|(?=\+)|(?=-)|(?=\*))' 0:variable
# add-highlighter shared/gdscript/code/ regex '(^\h*|(?<=[\w\]>])\h+|(?<=[;=+\-*/<>{}(,])\h*)\w*\h*((?=[,;)=+\-*/<>])\h*|(?=\.\w)|(?=\[\w))' 0:variable

### TYPES
# declaration
add-highlighter shared/gdscript/code/ regex '(((?<=class)|(?<=class_name)|(?<=extends))\h+\w*)' 0:type
# :, is, and ->
add-highlighter shared/gdscript/code/ regex '((?<=:)|(?<=is\h)|(?<=->\h))\h*\w*' 0:type
# nodepaths using $
add-highlighter shared/gdscript/code/ regex '(?<=\$)[\w|/]*' 0:type

### SURROUNDERS
add-highlighter shared/gdscript/code/ regex '[\[\]\(\){}]' 0:bracket

### NUMBERS
# doesn't cover base16, base2, or scientific notation
add-highlighter shared/gdscript/code/ regex '(?<![^\s(,=\[])(-|)([0-9]+)(\.([0-9]+)|)' 0:value

### OPERATORS
add-highlighter shared/gdscript/code/ regex '(\+%?|-%?|/|\*%?|=|\^|&|\?|\||!|>|<|%|<<%?|>>)=?' 0:operator

evaluate-commands %sh{
	keywords="if|elif|else|for|while|match|break|continue|pass|return|class"
	keywords="${keywords}|class_name|extends|is|and|or|not|in|as|self|tool|signal"
	keywords="${keywords}|func|static|const|enum|var|onready|export|setget|breakpoint"
	keywords="${keywords}|preload|yield|assert|remote|master|puppet|remotesync"
	keywords="${keywords}|mastersync|puppetsync"

	# ALL TYPES
	# Generated with following shell pipeline (reqires pup:https://github.com/ericchiang/pup)
	# curl https://docs.godotengine.org/en/3.2/classes/index.html | pup "li a[href\$=.html]" | pup "a[href^=class] text{}" | sed '/^[[:space:]]*$/d' | awk '{$1=$1};1' | sort | uniq | tr '\n' '|'
	types="@C#|@GDScript|@GlobalScope|@NativeScript|@VisualScript|AABB|ARVRAnchor|ARVRCamera|ARVRController|ARVRInterface|ARVRInterfaceGDNative|ARVROrigin|ARVRPositionalTracker|ARVRServer|AStar|AcceptDialog|AnimatedSprite|AnimatedSprite3D|AnimatedTexture|Animation|AnimationNode|AnimationNodeAdd2|AnimationNodeAdd3|AnimationNodeAnimation|AnimationNodeBlend2|AnimationNodeBlend3|AnimationNodeBlendSpace1D|AnimationNodeBlendSpace2D|AnimationNodeBlendTree|AnimationNodeOneShot|AnimationNodeOutput|AnimationNodeStateMachine|AnimationNodeStateMachinePlayback|AnimationNodeStateMachineTransition|AnimationNodeTimeScale|AnimationNodeTimeSeek|AnimationNodeTransition|AnimationPlayer|AnimationRootNode|AnimationTrackEditPlugin|AnimationTree|AnimationTreePlayer|Area|Area2D|Array|ArrayMesh|AtlasTexture|AudioBusLayout|AudioEffect|AudioEffectAmplify|AudioEffectBandLimitFilter|AudioEffectBandPassFilter|AudioEffectChorus|AudioEffectCompressor|AudioEffectDelay|AudioEffectDistortion|AudioEffectEQ|AudioEffectEQ10|AudioEffectEQ21|AudioEffectEQ6|AudioEffectFilter|AudioEffectHighPassFilter|AudioEffectHighShelfFilter|AudioEffectInstance|AudioEffectLimiter|AudioEffectLowPassFilter|AudioEffectLowShelfFilter|AudioEffectNotchFilter|AudioEffectPanner|AudioEffectPhaser|AudioEffectPitchShift|AudioEffectRecord|AudioEffectReverb|AudioEffectSpectrumAnalyzer|AudioEffectSpectrumAnalyzerInstance|AudioEffectStereoEnhance|AudioServer|AudioStream|AudioStreamGenerator|AudioStreamGeneratorPlayback|AudioStreamMicrophone|AudioStreamOGGVorbis|AudioStreamPlayback|AudioStreamPlaybackResampled|AudioStreamPlayer|AudioStreamPlayer2D|AudioStreamPlayer3D|AudioStreamRandomPitch|AudioStreamSample|BackBufferCopy|BakedLightmap|BakedLightmapData|BaseButton|Basis|BitMap|BitmapFont|Bone2D|BoneAttachment|BoxContainer|BoxShape|BulletPhysicsDirectBodyState|BulletPhysicsServer|Button|ButtonGroup|CPUParticles|CPUParticles2D|CSGBox|CSGCombiner|CSGCylinder|CSGMesh|CSGPolygon|CSGPrimitive|CSGShape|CSGSphere|CSGTorus|CSharpScript|Camera|Camera2D|CanvasItem|CanvasItemMaterial|CanvasLayer|CanvasModulate|CapsuleMesh|CapsuleShape|CapsuleShape2D|CenterContainer|CheckBox|CheckButton|CircleShape2D|ClassDB|ClippedCamera|CollisionObject|CollisionObject2D|CollisionPolygon|CollisionPolygon2D|CollisionShape|CollisionShape2D|Color|ColorPicker|ColorPickerButton|ColorRect|ConcavePolygonShape|ConcavePolygonShape2D|ConeTwistJoint|ConfigFile|ConfirmationDialog|Container|Control|ConvexPolygonShape|ConvexPolygonShape2D|CubeMap|CubeMesh|Curve|Curve2D|Curve3D|CurveTexture|CylinderMesh|CylinderShape|DampedSpringJoint2D|Dictionary|DirectionalLight|Directory|DynamicFont|DynamicFontData|EditorExportPlugin|EditorFileDialog|EditorFileSystem|EditorFileSystemDirectory|EditorImportPlugin|EditorInspector|EditorInspectorPlugin|EditorInterface|EditorPlugin|EditorProperty|EditorResourceConversionPlugin|EditorResourcePreview|EditorResourcePreviewGenerator|EditorSceneImporter|EditorScenePostImport|EditorScript|EditorSelection|EditorSettings|EditorSpatialGizmo|EditorSpatialGizmoPlugin|EncodedObjectAsID|Engine|Environment|Expression|File|FileDialog|Font|FuncRef|GDNative|GDNativeLibrary|GDNativeLibraryResourceLoader|GDNativeLibraryResourceSaver|GDScript|GDScriptFunctionState|GDScriptNativeClass|GIProbe|GIProbeData|Generic6DOFJoint|Geometry|GeometryInstance|GodotSharp|Gradient|GradientTexture|GraphEdit|GraphNode|GridContainer|GridMap|GrooveJoint2D|HBoxContainer|HScrollBar|HSeparator|HSlider|HSplitContainer|HTTPClient|HTTPRequest|HeightMapShape|HingeJoint|IP|IP_Unix|Image|ImageTexture|ImmediateGeometry|Input|InputDefault|InputEvent|InputEventAction|InputEventGesture|InputEventJoypadButton|InputEventJoypadMotion|InputEventKey|InputEventMIDI|InputEventMagnifyGesture|InputEventMouse|InputEventMouseButton|InputEventMouseMotion|InputEventPanGesture|InputEventScreenDrag|InputEventScreenTouch|InputEventWithModifiers|InputMap|InstancePlaceholder|InterpolatedCamera|ItemList|JSON|JSONParseResult|JavaScript|Joint|Joint2D|KinematicBody|KinematicBody2D|KinematicCollision|KinematicCollision2D|Label|LargeTexture|Light|Light2D|LightOccluder2D|Line2D|LineEdit|LineShape2D|LinkButton|Listener|MainLoop|MarginContainer|Marshalls|Material|MenuButton|Mesh|MeshDataTool|MeshInstance|MeshInstance2D|MeshLibrary|MobileVRInterface|MultiMesh|MultiMeshInstance|MultiplayerAPI|MultiplayerPeerGDNative|Mutex|NativeScript|Navigation|Navigation2D|NavigationMesh|NavigationMeshInstance|NavigationPolygon|NavigationPolygonInstance|NetworkedMultiplayerENet|NetworkedMultiplayerPeer|Nil|NinePatchRect|Node|Node2D|NodePath|NoiseTexture|OS|Object|OccluderPolygon2D|OmniLight|OpenSimplexNoise|OptionButton|PCKPacker|PHashTranslation|PackedDataContainer|PackedDataContainerRef|PackedScene|PacketPeer|PacketPeerGDNative|PacketPeerStream|PacketPeerUDP|Panel|PanelContainer|PanoramaSky|ParallaxBackground|ParallaxLayer|Particles|Particles2D|ParticlesMaterial|Path|Path2D|PathFollow|PathFollow2D|Performance|PhysicalBone|Physics2DDirectBodyState|Physics2DDirectBodyStateSW|Physics2DDirectSpaceState|Physics2DServer|Physics2DServerSW|Physics2DShapeQueryParameters|Physics2DShapeQueryResult|Physics2DTestMotionResult|PhysicsBody|PhysicsBody2D|PhysicsDirectBodyState|PhysicsDirectSpaceState|PhysicsMaterial|PhysicsServer|PhysicsShapeQueryParameters|PhysicsShapeQueryResult|PinJoint|PinJoint2D|Plane|PlaneMesh|PlaneShape|PluginScript|Polygon2D|PolygonPathFinder|PoolByteArray|PoolColorArray|PoolIntArray|PoolRealArray|PoolStringArray|PoolVector2Array|PoolVector3Array|Popup|PopupDialog|PopupMenu|PopupPanel|Position2D|Position3D|PrimitiveMesh|PrismMesh|ProceduralSky|ProgressBar|ProjectSettings|ProximityGroup|ProxyTexture|QuadMesh|Quat|RID|RandomNumberGenerator|Range|RayCast|RayCast2D|RayShape|RayShape2D|Rect2|RectangleShape2D|Reference|ReferenceRect|ReflectionProbe|RegEx|RegExMatch|RemoteTransform|RemoteTransform2D|Resource|ResourceFormatDDS|ResourceFormatImporter|ResourceFormatLoader|ResourceFormatLoaderBMFont|ResourceFormatLoaderBinary|ResourceFormatLoaderDynamicFont|ResourceFormatLoaderGDScript|ResourceFormatLoaderImage|ResourceFormatLoaderNativeScript|ResourceFormatLoaderShader|ResourceFormatLoaderStreamTexture|ResourceFormatLoaderText|ResourceFormatLoaderTextureLayered|ResourceFormatLoaderTheora|ResourceFormatLoaderVideoStreamGDNative|ResourceFormatLoaderWebm|ResourceFormatPKM|ResourceFormatPVR|ResourceFormatSaver|ResourceFormatSaverBinary|ResourceFormatSaverGDScript|ResourceFormatSaverNativeScript|ResourceFormatSaverShader|ResourceFormatSaverText|ResourceImporter|ResourceImporterOGGVorbis|ResourceInteractiveLoader|ResourceLoader|ResourcePreloader|ResourceSaver|ResourceSaverPNG|RichTextLabel|RigidBody|RigidBody2D|RootMotionView|SceneState|SceneTree|SceneTreeTimer|Script|ScriptCreateDialog|ScriptEditor|ScrollBar|ScrollContainer|SegmentShape2D|Semaphore|Separator|Shader|ShaderMaterial|Shape|Shape2D|ShortCut|Skeleton|Skeleton2D|SkeletonIK|Sky|Slider|SliderJoint|SoftBody|Spatial|SpatialGizmo|SpatialMaterial|SpatialVelocityTracker|SphereMesh|SphereShape|SpinBox|SplitContainer|SpotLight|SpringArm|Sprite|Sprite3D|SpriteBase3D|SpriteFrames|StaticBody|StaticBody2D|StreamPeer|StreamPeerBuffer|StreamPeerGDNative|StreamPeerSSL|StreamPeerTCP|StreamTexture|String|StyleBox|StyleBoxEmpty|StyleBoxFlat|StyleBoxLine|StyleBoxTexture|SurfaceTool|TCP_Server|TabContainer|Tabs|TextEdit|TextFile|Texture|Texture3D|TextureArray|TextureButton|TextureLayered|TextureProgress|TextureRect|Theme|Thread|TileMap|TileSet|Timer|ToolButton|TouchScreenButton|Transform|Transform2D|Translation|TranslationLoaderPO|TranslationServer|Tree|TreeItem|TriangleMesh|Tween|UPNP|UPNPDevice|UndoRedo|VBoxContainer|VScrollBar|VSeparator|VSlider|VSplitContainer|Variant|Vector2|Vector3|VehicleBody|VehicleWheel|VideoPlayer|VideoStream|VideoStreamGDNative|VideoStreamTheora|VideoStreamWebm|Viewport|ViewportContainer|ViewportTexture|VisibilityEnabler|VisibilityEnabler2D|VisibilityNotifier|VisibilityNotifier2D|VisualInstance|VisualScript|VisualScriptBasicTypeConstant|VisualScriptBuiltinFunc|VisualScriptClassConstant|VisualScriptComment|VisualScriptCondition|VisualScriptConstant|VisualScriptConstructor|VisualScriptCustomNode|VisualScriptDeconstruct|VisualScriptEditor|VisualScriptEmitSignal|VisualScriptEngineSingleton|VisualScriptExpression|VisualScriptFunction|VisualScriptFunctionCall|VisualScriptFunctionState|VisualScriptGlobalConstant|VisualScriptIndexGet|VisualScriptIndexSet|VisualScriptInputAction|VisualScriptIterator|VisualScriptLocalVar|VisualScriptLocalVarSet|VisualScriptMathConstant|VisualScriptNode|VisualScriptOperator|VisualScriptPreload|VisualScriptPropertyGet|VisualScriptPropertySet|VisualScriptResourcePath|VisualScriptReturn|VisualScriptSceneNode|VisualScriptSceneTree|VisualScriptSelect|VisualScriptSelf|VisualScriptSequence|VisualScriptSubCall|VisualScriptSwitch|VisualScriptTypeCast|VisualScriptVariableGet|VisualScriptVariableSet|VisualScriptWhile|VisualScriptYield|VisualScriptYieldSignal|VisualServer|VisualShader|VisualShaderNode|VisualShaderNodeColorConstant|VisualShaderNodeColorOp|VisualShaderNodeColorUniform|VisualShaderNodeCubeMap|VisualShaderNodeCubeMapUniform|VisualShaderNodeDotProduct|VisualShaderNodeInput|VisualShaderNodeOutput|VisualShaderNodeScalarConstant|VisualShaderNodeScalarFunc|VisualShaderNodeScalarInterp|VisualShaderNodeScalarOp|VisualShaderNodeScalarUniform|VisualShaderNodeTexture|VisualShaderNodeTextureUniform|VisualShaderNodeTransformCompose|VisualShaderNodeTransformConstant|VisualShaderNodeTransformDecompose|VisualShaderNodeTransformMult|VisualShaderNodeTransformUniform|VisualShaderNodeTransformVecMult|VisualShaderNodeUniform|VisualShaderNodeVec3Constant|VisualShaderNodeVec3Uniform|VisualShaderNodeVectorCompose|VisualShaderNodeVectorDecompose|VisualShaderNodeVectorFunc|VisualShaderNodeVectorInterp|VisualShaderNodeVectorLen|VisualShaderNodeVectorOp|WeakRef|WebSocketClient|WebSocketMultiplayerPeer|WebSocketPeer|WebSocketServer|WindowDialog|World|World2D|WorldEnvironment|XMLParser|YSort|bool|float|int|void"

	values="true|false|null|PI|TAU|INF|NAN"

	# Add the language's grammar to the static completion list
	printf '%s\n' "hook global WinSetOption filetype=gdscript %{
		set-option window static_words ${keywords} ${types}
	}" | tr '|' ' '

    # Highlight keywords
    printf '%s\n' "
        add-highlighter shared/gdscript/code/ regex '\b(${keywords})\b' 0:keyword
        add-highlighter shared/gdscript/code/ regex '\b(${types})\b' 0:type
        add-highlighter shared/gdscript/code/ regex '\b(${values})\b' 0:value
    "
}
