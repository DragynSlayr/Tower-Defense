export Stats = {}

export loadBaseStats = () ->
  for k, v in pairs Base_Stats
    Stats[k] = {}
    count = 1
    for k2, v2 in pairs v
      Stats[k][k2] = v2
      Stats[k][count] = v2
      count += 1
