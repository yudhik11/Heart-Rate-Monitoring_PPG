#!/bin/bash
echo "Training Set:"
read var1 
echo "Testing Set:"
read var2
echo "Output Directory:"
read var3
echo "var1=$var1, var2=$var2, var3=$var3"
/home/$USER/matlab/bin/matlab -nodesktop -nosplash -nojvm -r "script('$var1','$var2','$var3')"
