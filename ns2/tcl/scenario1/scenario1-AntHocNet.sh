ns sim-scn1-0.tcl AntHocNet
gzip -9 -f sim-scn1-0-AntHocNet.nam
rm -f sim-scn1-0-AntHocNet.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn1-0-AntHocNet-trace.tr"
rm -f sim-scn1-0-AntHocNet-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn1-0-AntHocNet-trace-clean.tr"
cd plot
gnuplot < sim-scn1-0-AntHocNet-over.gnu
gnuplot < sim-scn1-0-AntHocNet-total.gnu
gnuplot < sim-scn1-0-AntHocNet-delivery.gnu
gnuplot < sim-scn1-0-AntHocNet-average.gnu
gnuplot < sim-scn1-0-AntHocNet-total-geral.gnu
cd ..
gzip -9 -f sim-scn1-0-AntHocNet-trace-clean.tr
rm -f sim-scn1-0-AntHocNet-trace-clean.tr

ns sim-scn1-1.tcl AntHocNet
gzip -9 -f sim-scn1-1-AntHocNet.nam
rm -f sim-scn1-1-AntHocNet.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn1-1-AntHocNet-trace.tr"
rm -f sim-scn1-1-AntHocNet-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn1-1-AntHocNet-trace-clean.tr"
cd plot
gnuplot < sim-scn1-1-AntHocNet-over.gnu
gnuplot < sim-scn1-1-AntHocNet-total.gnu
gnuplot < sim-scn1-1-AntHocNet-delivery.gnu
gnuplot < sim-scn1-1-AntHocNet-average.gnu
gnuplot < sim-scn1-1-AntHocNet-total-geral.gnu
cd ..
gzip -9 -f sim-scn1-1-AntHocNet-trace-clean.tr
rm -f sim-scn1-1-AntHocNet-trace-clean.tr

ns sim-scn1-2.tcl AntHocNet
gzip -9 -f sim-scn1-2-AntHocNet.nam
rm -f sim-scn1-2-AntHocNet.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn1-2-AntHocNet-trace.tr"
rm -f sim-scn1-2-AntHocNet-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn1-2-AntHocNet-trace-clean.tr"
cd plot
gnuplot < sim-scn1-2-AntHocNet-over.gnu
gnuplot < sim-scn1-2-AntHocNet-total.gnu
gnuplot < sim-scn1-2-AntHocNet-delivery.gnu
gnuplot < sim-scn1-2-AntHocNet-average.gnu
gnuplot < sim-scn1-2-AntHocNet-total-geral.gnu
cd ..
gzip -9 -f sim-scn1-2-AntHocNet-trace-clean.tr
rm -f sim-scn1-2-AntHocNet-trace-clean.tr

ns sim-scn1-3.tcl AntHocNet
gzip -9 -f sim-scn1-3-AntHocNet.nam
rm -f sim-scn1-3-AntHocNet.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn1-3-AntHocNet-trace.tr"
rm -f sim-scn1-3-AntHocNet-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn1-3-AntHocNet-trace-clean.tr"
cd plot
gnuplot < sim-scn1-3-AntHocNet-over.gnu
gnuplot < sim-scn1-3-AntHocNet-total.gnu
gnuplot < sim-scn1-3-AntHocNet-delivery.gnu
gnuplot < sim-scn1-3-AntHocNet-average.gnu
gnuplot < sim-scn1-3-AntHocNet-total-geral.gnu
cd ..
gzip -9 -f sim-scn1-3-AntHocNet-trace-clean.tr
rm -f sim-scn1-3-AntHocNet-trace-clean.tr

ns sim-scn1-4.tcl AntHocNet
gzip -9 -f sim-scn1-4-AntHocNet.nam
rm -f sim-scn1-4-AntHocNet.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn1-4-AntHocNet-trace.tr"
rm -f sim-scn1-4-AntHocNet-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn1-4-AntHocNet-trace-clean.tr"
cd plot
gnuplot < sim-scn1-4-AntHocNet-over.gnu
gnuplot < sim-scn1-4-AntHocNet-total.gnu
gnuplot < sim-scn1-4-AntHocNet-delivery.gnu
gnuplot < sim-scn1-4-AntHocNet-average.gnu
gnuplot < sim-scn1-4-AntHocNet-total-geral.gnu
cd ..
gzip -9 -f sim-scn1-4-AntHocNet-trace-clean.tr
rm -f sim-scn1-4-AntHocNet-trace-clean.tr

ns sim-scn1-5.tcl AntHocNet
gzip -9 -f sim-scn1-5-AntHocNet.nam
rm -f sim-scn1-5-AntHocNet.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn1-5-AntHocNet-trace.tr"
rm -f sim-scn1-5-AntHocNet-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn1-5-AntHocNet-trace-clean.tr"
cd plot
gnuplot < sim-scn1-5-AntHocNet-over.gnu
gnuplot < sim-scn1-5-AntHocNet-total.gnu
gnuplot < sim-scn1-5-AntHocNet-delivery.gnu
gnuplot < sim-scn1-5-AntHocNet-average.gnu
gnuplot < sim-scn1-5-AntHocNet-total-geral.gnu
cd ..
gzip -9 -f sim-scn1-5-AntHocNet-trace-clean.tr
rm -f sim-scn1-5-AntHocNet-trace-clean.tr

ns sim-scn1-6.tcl AntHocNet
gzip -9 -f sim-scn1-6-AntHocNet.nam
rm -f sim-scn1-6-AntHocNet.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn1-6-AntHocNet-trace.tr"
rm -f sim-scn1-6-AntHocNet-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn1-6-AntHocNet-trace-clean.tr"
cd plot
gnuplot < sim-scn1-6-AntHocNet-over.gnu
gnuplot < sim-scn1-6-AntHocNet-total.gnu
gnuplot < sim-scn1-6-AntHocNet-delivery.gnu
gnuplot < sim-scn1-6-AntHocNet-average.gnu
gnuplot < sim-scn1-6-AntHocNet-total-geral.gnu
cd ..
gzip -9 -f sim-scn1-6-AntHocNet-trace-clean.tr
rm -f sim-scn1-6-AntHocNet-trace-clean.tr

ns sim-scn1-7.tcl AntHocNet
gzip -9 -f sim-scn1-7-AntHocNet.nam
rm -f sim-scn1-7-AntHocNet.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn1-7-AntHocNet-trace.tr"
rm -f sim-scn1-7-AntHocNet-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn1-7-AntHocNet-trace-clean.tr"
cd plot
gnuplot < sim-scn1-7-AntHocNet-over.gnu
gnuplot < sim-scn1-7-AntHocNet-total.gnu
gnuplot < sim-scn1-7-AntHocNet-delivery.gnu
gnuplot < sim-scn1-7-AntHocNet-average.gnu
gnuplot < sim-scn1-7-AntHocNet-total-geral.gnu
cd ..
gzip -9 -f sim-scn1-7-AntHocNet-trace-clean.tr
rm -f sim-scn1-7-AntHocNet-trace-clean.tr

ns sim-scn1-8.tcl AntHocNet
gzip -9 -f sim-scn1-8-AntHocNet.nam
rm -f sim-scn1-8-AntHocNet.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn1-8-AntHocNet-trace.tr"
rm -f sim-scn1-8-AntHocNet-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn1-8-AntHocNet-trace-clean.tr"
cd plot
gnuplot < sim-scn1-8-AntHocNet-over.gnu
gnuplot < sim-scn1-8-AntHocNet-total.gnu
gnuplot < sim-scn1-8-AntHocNet-delivery.gnu
gnuplot < sim-scn1-8-AntHocNet-average.gnu
gnuplot < sim-scn1-8-AntHocNet-total-geral.gnu
cd ..
gzip -9 -f sim-scn1-8-AntHocNet-trace-clean.tr
rm -f sim-scn1-8-AntHocNet-trace-clean.tr

ns sim-scn1-9.tcl AntHocNet
gzip -9 -f sim-scn1-9-AntHocNet.nam
rm -f sim-scn1-9-AntHocNet.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn1-9-AntHocNet-trace.tr"
rm -f sim-scn1-9-AntHocNet-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn1-9-AntHocNet-trace-clean.tr"
cd plot
gnuplot < sim-scn1-9-AntHocNet-over.gnu
gnuplot < sim-scn1-9-AntHocNet-total.gnu
gnuplot < sim-scn1-9-AntHocNet-delivery.gnu
gnuplot < sim-scn1-9-AntHocNet-average.gnu
gnuplot < sim-scn1-9-AntHocNet-total-geral.gnu
cd ..
gzip -9 -f sim-scn1-9-AntHocNet-trace-clean.tr
rm -f sim-scn1-9-AntHocNet-trace-clean.tr

