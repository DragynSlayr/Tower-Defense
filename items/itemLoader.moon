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
require "items.bombActive"
require "items.trailActive"
require "items.freezeActive"
require "items.poisonActive"
require "items.shieldActive"
require "items.healingActive"
require "items.blackHoleActive"
require "items.damageBoostActive"

--+-------------------------+--
--| Depends on passive item |--
--+-------------------------+--
require "items.bombPassive"
require "items.trailPassive"
require "items.extraLifePassive"
require "items.rangeBoostPassive"
require "items.speedBoostPassive"
require "items.damageBoostPassive"
require "items.healthBoostPassive"
require "items.movingTurretPassive"

--+------------------+--
--| Depends on items |--
--+------------------+--
require "items.itemPool"
