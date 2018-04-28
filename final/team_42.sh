#!/bin/bash
echo "Please variables 1 and 2:"
read var1 
read var2
read var3
echo "var1=$var1, var2=$var2, var3 = $var3"
matlab -nodesktop -nosplash -nojvm -r "script($var1,$var2,$var3)"