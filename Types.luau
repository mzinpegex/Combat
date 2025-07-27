local types = {}

export type HitBoxProperties = {
	DetectionMode: ("Default" | "MultiHits"),
	OverlapParams: OverlapParams,

	Size: Vector3,
	Shape: Enum.PartType,
	CFrame: CFrame,
	Offset: CFrame,

	VelocityPredictionTime: number?,
	VelocityPrediction: boolean?,
}

export type Hitbox = {
	DetectionMode: ("Default" | "MultiHits"),
	OverlapParams: OverlapParams,

	Size: Vector3,
	Shape: Enum.PartType,
	CFrame: CFrame,
	Offset: CFrame,

	VelocityPredictionTime: number?,
	VelocityPrediction: boolean?,
	
	Start: (self: Hitbox) -> (),
	Stop: (self: Hitbox) -> (),
	
	HitList: {}?,
	TouchingParts: {BasePart}?,
	Connection: RBXScriptConnection?,
}

export type HighlightModule = {
	DephtMode: Enum.HighlightDepthMode,
	FillColor: Color3,
	FillTransparency: number,
	OutlineColor: Color3,
	OutlineTransparency: number,
	
	FadeIn: boolean,
	FadeInTime: number,
	FadeOut: boolean,
	FadeOutTime: number,
	
	LifeTime: number,
}

return types
