--+---------------+--
--| No dependency |--
--+---------------+--
require "objectives.attackGoal"
require "objectives.defendGoal"
require "objectives.findGoal"
require "objectives.mode"
require "objectives.wave"

--+-----------------+--
--| Depends on mode |--
--+-----------------+--
require "objectives.eliminationMode"
require "objectives.attackMode"
require "objectives.defendMode"
require "objectives.darkMode"

--+-----------------+--
--| Depends on wave |--
--+-----------------+--
require "objectives.eliminationWave"
require "objectives.attackWave"
require "objectives.defendWave"
require "objectives.darkWave"

--+------------------------------+--
--| Dependent on everything else |--
--+------------------------------+--
require "objectives.objectives"
