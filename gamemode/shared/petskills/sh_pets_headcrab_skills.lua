AddCSLuaFile()
<<<<<<< Updated upstream

local health_1 = CreatePetSkill("Health Boost", 
	"Your pet can live\nfor longer\n+25HP", 
=======
--[[ SKILL TEMPLATES
	local health = CreatePetSkill("Health Boost", 
		"Your pet can live\nfor longer", 
		"npc_hl2cr_pet_headcrab", nil, 
		"materials/hl2cr/skill_pet_health.jpg", 
		50, 100
	)

	local dmg = CreatePetSkill("Strength Buff", 
		"Your pet deals more\ndamage to opponents", 
		"npc_hl2cr_pet_headcrab", nil, 
		"materials/hl2cr/skill_pet_dmg.jpg", 
		250, 100
	)

	local speed = CreatePetSkill("Agility Increase", 
		"Your pet can move\nand attack faster", 
		"npc_hl2cr_pet_headcrab", nil, 
		"materials/hl2cr/skill_pet_speed.jpg", 
		350, 100
	)

	local genEvo = CreatePetSkill("Genetic Evolution", 
		"Mutate your pet into\nsomething better", 
		"npc_hl2cr_pet_headcrab", nil, 
		"materials/hl2cr/skill_pet_genetics.jpg", 
		550, 100
	)
--]]

local health_1 = CreatePetSkill("Health Boost", 
	"Your pet can live\nfor longer", 
>>>>>>> Stashed changes
	"npc_hl2cr_pet_headcrab", nil, 
	"materials/hl2cr/skill_pet_health.jpg", 
	50, 100
)

local health_2 = CreatePetSkill("Health Boost II", 
<<<<<<< Updated upstream
	"Your pet can live\nfor longer\n+25HP", 
	"npc_hl2cr_pet_headcrab", "Health Boost", 
	"materials/hl2cr/skill_pet_health.jpg", 
	150, 100
=======
	"Your pet can live\nfor longer", 
	"npc_hl2cr_pet_headcrab", "Health Boost", 
	"materials/hl2cr/skill_pet_health.jpg", 
	150, 100
)

local dmg_1 = CreatePetSkill("Strength Buff", 
	"Your pet deals more\ndamage to opponents", 
	"npc_hl2cr_pet_headcrab", "Health Boost II", 
	"materials/hl2cr/skill_pet_dmg.jpg", 
	250, 100
)

local speed_1 = CreatePetSkill("Agility Increase", 
	"Your pet can move\nand attack faster", 
	"npc_hl2cr_pet_headcrab", "Health Boost", 
	"materials/hl2cr/skill_pet_speed.jpg", 
	350, 100
)

local dmg_2 = CreatePetSkill("Strength Buff II", 
	"Your pet deals more\ndamage to opponents", 
	"npc_hl2cr_pet_headcrab", "Agility Increase", 
	"materials/hl2cr/skill_pet_dmg.jpg", 
	450, 100
)

local genEvo = CreatePetSkill("Genetic Evolution", 
	"Mutate your pet into\nsomething better", 
	"npc_hl2cr_pet_headcrab", "Strength Buff II", 
	"materials/hl2cr/skill_pet_genetics.jpg", 
	550, 100
>>>>>>> Stashed changes
)