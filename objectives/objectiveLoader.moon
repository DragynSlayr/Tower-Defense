--+---------------+--
--| No dependency |--
--+---------------+--
require "objectives.attackGoal"
require "objectives.defendGoal"
require "objectives.mode"
require "objectives.wave"

--+-----------------+--
--| Depends on mode |--
--+-----------------+--
require "objectives.eliminationMode"
require "objectives.attackMode"
require "objectives.defendMode"

--+-----------------+--
--| Depends on wave |--
--+-----------------+--
require "objectives.eliminationWave"
require "objectives.attackWave"
require "objectives.defendWave"

--+------------------------------+--
--| Dependent on everything else |--
--+------------------------------+--
require "objectives.objectives"
