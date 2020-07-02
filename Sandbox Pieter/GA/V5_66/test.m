sub_count = 0;
t_end = 30*8760-240;
time_step = 120;
t = 0;
sub_count = 0;
while t<t_end
    if rem(t,87600) == 0 && t~=0
       t
       sub_count = sub_count+1
    end
    t = t+time_step;
end