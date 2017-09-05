export class FakeFindGoal extends FindGoal
  new: (x, y) =>
    super x, y
    @goal_type = GoalTypes.fake_find
    @solid = false

  draw: =>
    return

  onCollide: (object) =>
    return
