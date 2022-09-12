
#初始化alpine环境
startEvn() {
#下载必要文件
sleep 1s
clear;
echo "

======================================================================================
正在下载甜糖/容器魔方脚本文件，请稍等。。。
======================================================================================

";

rm -rf ./ttnode-docker-high;
rm -f ./ttnode-docker-high.zip;
sleep 2s
wget https://gitee.com/zhang0510/ttnode_server/attach_files/1145514/download/ttnode-docker-high.zip
unzip ttnode-docker-high.zip


#删除可能存在的旧文件
sleep 1s;
rm -rf /usr/node;
rm -f /etc/apk/repositories;
rm -f /etc/local.d/mount.start;

#移入甜糖所需文件
sleep 1s;
mv ./ttnode-docker-high/ttnode/alpine/node /usr/;
sleep 1s;
chmod 777 -R /usr/node;
#sleep 1s;
mv -f ./ttnode-docker-high/ttnode/alpine/mount.start /etc/local.d; #移入开机自动挂载硬盘
sleep 1s;
chmod +x /etc/local.d/mount.start;
sleep 1s;
rc-update add local;
sleep 1s;
mv -f ./ttnode-docker-high/ttnode/alpine/repositories /etc/apk/; #替换软件源
sleep 2s;
rm -rf ./ttnode-docker-high;
rm -f ./ttnode-docker-high.zip;

#安装相关应用
sleep 2s;
apk update;
sleep 2s;
apk add docker;
sleep 2s;
rc-update add docker boot;
sleep 2s;
service docker start;
sleep 2s;
mkdir /mnt >& /dev/null ;
sleep 2s;
}



#部署甜糖服务
startTtnodesever() {
clear;
echo "

======================================================================================

正在启动/更新甜糖服务，请耐心等待

======================================================================================

";
docker rm -f ttnode >& /dev/null || echo 'remove ttnode container'
docker rm -f tiptime_wsv >& /dev/null || echo 'remove tiptime_wsv container'
docker rmi -f registry.cn-hangzhou.aliyuncs.com/tiptime/ttnode:latest >& /dev/null || echo 'remove tiptime/ttnode from ali'
docker rmi -f tiptime/ttnode:latest >& /dev/null || echo 'remove tiptime/ttnode from dockerhub'

docker run --privileged -d \
  -v /mnts/ttnode:/mnt/data/ttnode \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /proc:/host/proc:ro \
  --name ttnode \
  --hostname ttnode \
  --net=host \
  -e mode=high \
  --restart=always \
  registry.cn-hangzhou.aliyuncs.com/tiptime/ttnode:latest

sleep 10s;
echo "

======================================================================================

部署完成，请浏览器输入“ http://$(ip route get 1.2.3.4 | awk '{print $7}'):1024 ”进行二维码扫码绑定、业务选择及高质量通道选择等操作！！！

======================================================================================

";
}



#部署网心容器魔方
startWxedgeSever() {
clear;
echo "

======================================================================================

正在部署/更新网心容器魔方，请耐心等待

======================================================================================

";
docker rm -f wxedge >& /dev/null || echo 'remove ttnode container'
docker rmi -f registry.hub.docker.com/onething1/wxedge:latest >& /dev/null || echo 'remove tiptime/ttnode from dockerhub'


docker run \
--name=wxedge \
--restart=always \
--privileged \
--net=host \
--tmpfs /run \
--tmpfs /tmp \
-v /mnts/wxedge1/containerd:/var/lib/containerd \
-v /mnts/wxedge1:/storage:rw \
-d \
registry.hub.docker.com/onething1/wxedge

sleep 10s;
echo "

======================================================================================

部署完成，请浏览器输入“ http://$(ip route get 1.2.3.4 | awk '{print $7}'):18888 ”进行二维码扫码绑定、业务选择等操作！！！

======================================================================================

";
}


#开始前的说明
sleep 1s;
clear;
read -p "
======================================================================================

当前脚本只适用于  “X86的alpine系统”  安装甜糖服务/网心容器魔方，若选错了按Ctrl+C即可结束安装

  请输入下列序号，进行相应操作
	
	1.一键部署甜糖服务（docker部署，默认开启高质量通道）

	2.一键部署网心容器魔方

	3.硬盘分区并格式化（更换缓存盘后使用）

	4.清除甜糖缓存（不会删除绑定信息）

	5.删除甜糖容器

	6.更新甜糖容器

	7.清除容器魔方缓存

	8.删除容器魔方容器

	9.更新容器魔方容器

	10.退出

======================================================================================


请选择相应的数字进行操作：" beforestart


if [[ ${beforestart} == 1 ]];then
sleep 1s;
startEvn
#初始化硬盘
/usr/node/automkfs.sh;
sleep 1s;
#挂载硬盘
echo "

======================================================================================

正在尝试挂载硬盘，请稍等。。。

======================================================================================

";
/usr/node/mount.sh;
sleep 2s;
startTtnodesever

elif [[ ${beforestart} == 2 ]];then
sleep 1s;
startEvn
#初始化硬盘
/usr/node/automkfs.sh;
sleep 1s;
#挂载硬盘
echo "

======================================================================================

正在尝试挂载硬盘，请稍等。。。

======================================================================================

";
/usr/node/mount.sh;
sleep 2s;
startWxedgeSever

elif [[ ${beforestart} == 3 ]];then
sleep 1s;
#初始化硬盘
/usr/node/automkfs.sh;
sleep 1s;
#挂载硬盘
echo "

======================================================================================

正在尝试挂载硬盘，请稍等。。。

======================================================================================

";
/usr/node/mount.sh;
sleep 2s;

elif [[ ${beforestart} == 4 ]];then
sleep 1s;
docker stop $(docker ps -q)
sleep 1s;
rm -rf /mnts/ttnode/.yfnode/cache;
sleep 1s;
docker start $(docker ps -a -q)
 
elif [[ ${beforestart} == 5 ]];then
sleep 1s;
docker rm -f ttnode ||  echo 'remove ttnode container'
docker rm -f tiptime_wsv ||  echo 'remove tiptime_wsv container'
docker rmi -f registry.cn-hangzhou.aliyuncs.com/tiptime/ttnode:latest || echo 'remove tiptime/ttnode from ali'
docker rmi -f tiptime/ttnode:latest || echo 'remove tiptime/ttnode from dockerhub'

elif [[ ${beforestart} == 6 ]];then
sleep 1s;
startTtnodesever

elif [[ ${beforestart} == 7 ]];then
sleep 1s;
docker stop $(docker ps -q)
sleep 1s;
rm -rf /mnts/wxedge1;
sleep 1s;
docker start $(docker ps -a -q)

elif [[ ${beforestart} == 8 ]];then
sleep 1s;
docker rm -f wxedge >& echo 'remove ttnode container'
docker rmi -f registry.hub.docker.com/onething1/wxedge:latest || 'remove tiptime/ttnode from dockerhub'

elif [[ ${beforestart} == 9 ]];then
sleep 1s;
startWxedgeSever

else
echo "

退出安装脚本
";
sleep 5s;
fi


