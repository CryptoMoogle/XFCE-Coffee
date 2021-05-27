#!/bin/bash

home_dir=$(eval echo ~$USER)
panel=$home_dir/.config/xfce4/panel
rel_path=$(dirname "${BASH_SOURCE[0]}")
list=$(xfconf-query -c xfce4-panel -p /plugins -l | cut -d/ -f 3 | cut -d- -f 2 | sort -n | uniq)

for i in {1..30}
do   
echo $list | grep -w -q $i
if [ $? != 0 ]
then 
mkdir $panel/launcher-$i
break
esle 
fail and exit script
fi
done

#cp $rel_path/* $panel/launcher-$i
find $rel_path ! -name '*.sh' -type f | xargs cp -t $panel/launcher-$i

echo "Exec=$panel/launcher-$i/coffee.sh" >> $panel/launcher-$i/coffee.desktop
cp $panel/launcher-$i/coffee.desktop $panel/launcher-$i/empty.txt
echo "Icon=$panel/launcher-$i/empty.png" >> $panel/launcher-$i/coffee.desktop
cp $panel/launcher-$i/coffee.desktop $panel/launcher-$i/full.txt
echo "Icon=$panel/launcher-$i/full.png" >> $panel/launcher-$i/empty.txt

echo "#!/bin/bash" >> $panel/launcher-$i/coffee.sh
echo " " >> $panel/launcher-$i/coffee.sh
echo "grep -q .*empty.png $panel/launcher-$i/coffee.desktop" >> $panel/launcher-$i/coffee.sh
echo " " >> $panel/launcher-$i/coffee.sh
echo "if [ \$? = 1 ]" >> $panel/launcher-$i/coffee.sh
echo "then" >> $panel/launcher-$i/coffee.sh
echo "  cp $panel/launcher-$i/full.txt $panel/launcher-$i/coffee.desktop" >> $panel/launcher-$i/coffee.sh
echo "  xset +dpms" >> $panel/launcher-$i/coffee.sh
echo "  xset s 60" >> $panel/launcher-$i/coffee.sh
echo "else" >> $panel/launcher-$i/coffee.sh
echo "  cp $panel/launcher-$i/empty.txt $panel/launcher-$i/coffee.desktop" >> $panel/launcher-$i/coffee.sh
echo "  xset -dpms" >> $panel/launcher-$i/coffee.sh
echo "  xset s off" >> $panel/launcher-$i/coffee.sh
echo "fi" >> $panel/launcher-$i/coffee.sh

chmod 755 $panel/launcher-$i/coffee.sh

xfconf-query -c xfce4-panel -p /plugins/plugin-$i -t string -s "launcher" --create

xfconf-query -c xfce4-panel -p /plugins/plugin-16/items -t string -s "coffee.desktop" -a --create

array=$(xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids | grep -v "Value is an\|^$")
array=$(echo $array | sed -e 's/ / -t int -s /g')

xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -rR
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -t int -s $array -t int -s $i --create
xfce4-panel -r

sleep 2
cp $panel/launcher-$i/empty.txt $panel/launcher-$i/coffee.desktop




#┌──(cryptomoogle㉿KaliLinux)-[~]
#└─$ xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids| grep -v "Value is an\|^$" | sed ':a;N;$!ba;s/\n/ -t int -s /g' 
#1 -t int -s 11 -t int -s 12 -t int -s 13 -t int -s 2 -t int -s 10 -t int -s 14 -t int -s 22 -t int -s 15 -t int -s 16 -t int -s 20











