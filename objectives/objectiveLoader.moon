--+---------------+--
--| No dependency |--
--+---------------+--
require "objectives.attackGoal"
require "objectives.defendGoal"
require "objectives.findGoal"
require "objectives.captureGoal"
require "objectives.mode"
require "objectives.wave"

--+-----------------+--
--| Depends on mode |--
--+-----------------+--
require "objectives.eliminationMode"
require "objectives.attackMode"
require "objectives.defendMode"
require "objectives.darkMode"
require "objectives.captureMode"

--+-----------------+--
--| Depends on wave |--
--+-----------------+--
require "objectives.eliminationWave"
require "objectives.attackWave"
require "objectives.defendWave"
require "objectives.darkWave"
require "objectives.captureWave"

--+------------------------------+--
--| Dependent on everything else |--
--+------------------------------+--
require "objectives.objectives"
