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

--+----------------------------+--
--| Depends on everything else |--
--+----------------------------+--
require "items.shieldActive"
require "items.extraLifePassive"
require "items.movingTurretPassive"
require "items.damageBoostActive"
require "items.blackHoleActive"
require "items.bombPassive"

--+------------------+--
--| Depends on items |--
--+------------------+--
require "items.itemPool"
