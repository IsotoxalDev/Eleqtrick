class_name Charge2D
extends CharacterBody2D

## CONST
const K = 9e9 # implies 9 x 10^9

## Charge in electron
@export var charge: float = 1
## Dielectric constant Default: 85 (Water)
@export var dielectric: int = 85
## If the particle is fixed
@export var fixed: bool = false

## Mass in electron mass
@export var mass: float = 50

@onready var parent = get_parent()

func _ready():
	if charge > 0:
		self.modulate = Color("#ff7d7d")
	else:
		self.modulate = Color("#6cadd9")

# Called 60 times every second
func _physics_process(delta):
	if fixed: return
	var force = Vector2.ZERO # Vector2 signifies a 2D Vector
	for q2 in parent.get_children(): # Looping over all charges
		if !q2 is Charge2D or q2 == self or not q2.charge: continue # Checks
		var r = q2.position - self.position # Self is q1
		var fm = Vector2(-K/dielectric * self.charge * q2.charge / # Coulomb's law
			 (r.length()*15)**2, 0) # 15 times distance in space
		force += (fm.x/fm.length())*(fm.length() * (r/r.length()))
		print(fm)
		
	var acc = force/mass # Getting acceleration from force
	velocity += acc # Adding acceleration to velocity
	move_and_slide()
	
