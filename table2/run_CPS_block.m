range = 1:20;
jobnames = cell(length(range), 1);
filenames = cell(length(range), 1);
mkdir 'CPS'

cur = 0;

while cur < max(range)

cur = cur+1;
experiment_CPS_block(cur)

end
