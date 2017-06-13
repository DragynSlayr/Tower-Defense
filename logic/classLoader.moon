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

--+----------------+--
--| Load particles |--
--+----------------+--
require "particles.particleLoader"

--+-----------+--
--| Load maps |--
--+-----------+--
require "maps.mapLoader"

--+--------------+--
--| Load screens |--
--+--------------+--
require "screens.screenLoader"

--+------------------------------+--
--| Dependent on everything else |--
--+------------------------------+--
require "logic.driver"
