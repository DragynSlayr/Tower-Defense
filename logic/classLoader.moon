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
require "logic.turret"
require "logic.basicTurret"

--+------------------------------+--
--| Dependent on everything else |--
--+------------------------------+--
require "logic.driver"
return
