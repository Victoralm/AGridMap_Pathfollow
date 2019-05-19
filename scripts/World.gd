extends Spatial

onready var sun = $SunLight
onready var WEnv = $WorldEnvironment.get_environment()
var sunRotation = Vector3(0, -90, 0)
onready var house1 = $Navigation/Buildings/HouseTerrain
var sunEnergy = 0.01
export var dayCycle = true


func DayCyle(delta):
#	sun.set_rotation_degrees(5)
#	print("Sun rotation x: " + str(sun.get_rotation()))
#	print("Sun rotation x: " + str(sun.get_rotation_degrees()))
	if sunRotation.x > -180:
		sunRotation.x -= 10 * delta
	else:
		sunRotation.x = 0
	if sunRotation.x <= 0 and sunRotation.x > -90:
		WEnv.set_tonemap_exposure(clamp(WEnv.get_tonemap_exposure()+0.005, 0.01, 1.0))
		sunEnergy = clamp(sunEnergy + 0.003, 0.01, 1.0)
		sun.light_energy = sunEnergy
#		print("Maior que...")
	elif sunRotation.x < -91:
		WEnv.set_tonemap_exposure(clamp(WEnv.get_tonemap_exposure()-0.002, 0.01, 1.0))
		sunEnergy = clamp(sunEnergy - 0.0005, 0.01, 1.0)
		sun.light_energy = sunEnergy
#		print(abs(sunRotation.x / 1.1)/100)
#		print("Menor que...")
	elif sunRotation.x < -130:
		WEnv.set_tonemap_exposure(clamp(WEnv.get_tonemap_exposure()-0.005, 0.01, 1.0))
		sunEnergy = clamp(sunEnergy - 0.0015, 0.01, 1.0)
	sun.set_rotation_degrees(sunRotation)
	print("Sun rotation: " + str(sun.get_rotation_degrees()))
#	print("WEnv tonemap Exopsure: " + str(WEnv.get_tonemap_exposure()))
#	print("Sun energy: " + str(sun.light_energy))



func _ready():
	sun.set_rotation_degrees(sunRotation)
	sun.light_energy = 0.01
	WEnv.set_tonemap_exposure(0.01)
#	print("House1 area: " + str(house1.get_area()))
	pass


func _process(delta):
	if dayCycle:
		DayCyle(delta)
	pass