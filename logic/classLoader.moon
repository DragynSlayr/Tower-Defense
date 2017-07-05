queue = {}

--+------------+--
--| Load utils |--
--+------------+--
table.insert queue, "utils.utilsLoader"

--+---------+--
--| Load ui |--
--+---------+--
table.insert queue, "ui.uiLoader"

--+------------------+--
--| Depends on utils |--
--+------------------+--
table.insert queue, "logic.gameObject"
table.insert queue, "logic.player"

--+--------------+--
--| Load Enemies |--
--+--------------+--
table.insert queue, "enemies.enemyLoader"

--+-------------------------+--
--| Load background objects |--
--+-------------------------+--
table.insert queue, "backgrounds.backgroundLoader"

--+------------------+--
--| Load Projectiles |--
--+------------------+--
table.insert queue, "projectiles.projectileLoader"

--+--------------+--
--| Load Turrets |--
--+--------------+--
table.insert queue, "turrets.turretLoader"

--+-------------+--
--| Load Bosses |--
--+-------------+--
table.insert queue, "bosses.bossLoader"

--+-----------------+--
--| Load Objectives |--
--+-----------------+--
table.insert queue, "objectives.objectiveLoader"

--+----------------+--
--| Load particles |--
--+----------------+--
table.insert queue, "particles.particleLoader"

--+------------+--
--| Load items |--
--+------------+--
table.insert queue, "items.itemLoader"

--+-----------+--
--| Load maps |--
--+-----------+--
table.insert queue, "maps.mapLoader"

--+--------------+--
--| Load screens |--
--+--------------+--
table.insert queue, "screens.screenLoader"

--+------------------------------+--
--| Dependent on everything else |--
--+------------------------------+--
table.insert queue, "logic.driver"

return queue
