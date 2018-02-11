--+---------------+--
--| No dependency |--
--+---------------+--
require "items.item"

--+-----------------+--
--| Depends on item |--
--+-----------------+--
require "items.itemBox"
require "items.nullItem"
require "items.passiveItem"
require "items.activeItem"

--+------------------------+--
--| Depends on active item |--
--+------------------------+--
require "items.empActive"
require "items.bombActive"
require "items.dashActive"
require "items.cloneActive"
require "items.trailActive"
require "items.freezeActive"
require "items.poisonActive"
require "items.shieldActive"
require "items.deadeyeActive"
require "items.healingActive"
require "items.missileActive"
require "items.wholeHogActive"
require "items.blackHoleActive"
require "items.moltenCoreActive"
require "items.damageBoostActive"
require "items.dragonStrikeActive"
require "items.earthShatterActive"

--+-------------------------+--
--| Depends on passive item |--
--+-------------------------+--
require "items.bombPassive"
require "items.armorPassive"
require "items.curryPassive"
require "items.trailPassive"
require "items.missilePassive"
require "items.extraLifePassive"
require "items.lifeStealPassive"
require "items.doubleShotPassive"
require "items.rangeBoostPassive"
require "items.speedBoostPassive"
require "items.turretSlagPassive"
require "items.damageBoostPassive"
require "items.extraTurretPassive"
require "items.healthBoostPassive"
require "items.damageAbsorbPassive"
require "items.movingTurretPassive"
require "items.turretShieldPassive"
require "items.damageReflectPassive"
require "items.turretMissilePassive"
require "items.turretRangeBoostPassive"
require "items.speedBoostSpecialPassive"
require "items.turretMultiTargetPassive"

--+------------------+--
--| Depends on items |--
--+------------------+--
require "items.itemPool"
