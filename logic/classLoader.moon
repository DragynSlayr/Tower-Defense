--+------------+--
--| Load utils |--
--+------------+--
require "utils.utilsLoader"

--+---------+--
--| Load ui |--
--+---------+--
require "ui.uiLoader"

--+------------------+--
--| Depends on utils |--
--+------------------+--
require "logic.gameObject"
require "logic.player"

--+--------------+--
--| Load Enemies |--
--+--------------+--
require "enemies.enemyLoader"

--+------------------+--
--| Load Projectiles |--
--+------------------+--
require "projectiles.projectileLoader"

--+--------------+--
--| Load Turrets |--
--+--------------+--
require "turrets.turretLoader"

--+-----------------+--
--| Load Objectives |--
--+-----------------+--
require "objectives.objectiveLoader"

--+------------------------------+--
--| Dependent on everything else |--
--+------------------------------+--
require "logic.driver"
require "logic.upgrade"
