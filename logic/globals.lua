Stats = { }
for k, v in pairs(Base_Stats) do
  Stats[k] = { }
  local count = 1
  for k2, v2 in pairs(v) do
    Stats[k][k2] = v2
    Stats[k][count] = v2
    count = count + 1
  end
end
