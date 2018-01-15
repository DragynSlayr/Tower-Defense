class PairTable
  new: =>
    @colliding = {}

  addPair: (a, b) =>
    found = false
    for k, v in pairs @colliding
      if v[1] == b and v[2] == a
        found = true
        break
    if not found
      table.insert @colliding, {a, b}

  clear: =>
    @colliding = {}

export class CollisionChecker
  new: =>
    @pairs = PairTable!

  update: (dt) =>
    for k, v in pairs Driver.objects
      for k2, o in pairs v
        for k3, c in pairs o.colliders
          for k4, o2 in pairs Driver.objects[c]
            other = o2\getHitBox!
            this = o\getHitBox!
            if (tableContains o2.colliders, k) and (other\contains this)
              @pairs\addPair o, o2
    for k, collision in pairs @pairs.colliding
      a = collision[1]
      b = collision[2]
      a.position\add (a.speed\multiply (-1 * dt))
      b.position\add (b.speed\multiply (-1 * dt))
      --if a\getHitBox!\contains b\getHitBox!
      --  vec = Vector a.position.x - b.position.x, a.position.y - b.position.y
      --  a.position\add vec\multiply 2
    @pairs\clear!
