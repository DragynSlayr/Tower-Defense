--+---------------+--
--| No dependency |--
--+---------------+--
require "ui.uiElement"

--+----------------------+--
--| Depends on UIElement |--
--+----------------------+--
require "ui.background"
require "ui.button"
require "ui.text"

--+---------------------+--
--| Depends on elements |--
--+---------------------+--
require "ui.tooltip"
require "ui.tooltipButton"
require "ui.ui"

--+----------------------------+--
--| Depends on everything else |--
--+----------------------------+--
require "ui.screenCreator"
