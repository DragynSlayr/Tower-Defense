--+---------------+--
--| No dependency |--
--+---------------+--
require "utils.renderer"
require "utils.sound"

--+------------------+--
--| Depends on sound |--
--+------------------+--
require "utils.musicHandler"

--+--------------------+--
--| Basic math classes |--
--+--------------------+--
require "utils.vector"
require "utils.point"
require "utils.circle"
require "utils.mathHelper"

--+-------------------------+--
--| Depends on math classes |--
--+-------------------------+--
require "utils.sprite"

--+-------------------+--
--| Depends on sprite |--
--+-------------------+--
require "ui.button"
require "ui.ui"

--+--------------------------+--
--| State and Type constants |--
--+--------------------------+--
require "logic.state"
require "logic.entityTypes"

--+-----------------------------+--
--| Depends on sprite and types |--
--+-----------------------------+--
require "logic.gameObject"
require "logic.player"

--+---------+--
--| Enemies |--
--+---------+--
require "logic.enemy"
require "logic.basicEnemy"
require "logic.playerEnemy"
require "logic.turretEnemy"
require "logic.strongEnemy"
require "logic.spawnerEnemy"

--+---------+--
--| Turrets |--
--+---------+--
require "logic.bullet"
require "logic.playerBullet"
require "logic.turret"
require "logic.basicTurret"

--+------------+--
--| Objectives |--
--+------------+--
require "logic.mode"
require "logic.eliminationMode"
require "logic.objectives"

--+------------------------------+--
--| Dependent on everything else |--
--+------------------------------+--
require "logic.driver"
return
