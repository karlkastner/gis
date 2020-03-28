# 2015-06-25 12:53:26.754251919 +0200

# fix for qgis bug to apply transparency (?)

in='<rasterTransparency/>';
out='<rasterTransparency>
                        <threeValuePixelList>
                            <pixelListEntry red="0" blue="0" green="0" percentTransparent="100"/>
                        </threeValuePixelList>
                    </rasterTransparency>';
out=`echo ${out} | tr '\n' "\\n"`
#while read line
#do
#	sed -e "s#$in#$out" "$line"
#done
sed -e "s#$in#$out#" $1


