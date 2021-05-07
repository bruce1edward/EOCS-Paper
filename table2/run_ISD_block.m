range = 1:20;
jobnames = cell(length(range), 1);
filenames = cell(length(range), 1);
mkdir 'ISD'

cur = 0;

while cur < max(range)

cur = cur+1;
experiment_ISD_block(cur)

end