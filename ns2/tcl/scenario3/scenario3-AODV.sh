ns sim-scn3-0.tcl AODV
gzip -9 -f sim-scn3-0-AODV.nam
rm -f sim-scn3-0-AODV.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn3-0-AODV-trace.tr"
rm -f sim-scn3-0-AODV-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn3-0-AODV-trace-clean.tr"
cd plot
gnuplot < sim-scn3-0-AODV-over.gnu
gnuplot < sim-scn3-0-AODV-total.gnu
gnuplot < sim-scn3-0-AODV-delivery.gnu
gnuplot < sim-scn3-0-AODV-average.gnu
gnuplot < sim-scn3-0-AODV-total-geral.gnu
cd ..
gzip -9 -f sim-scn3-0-AODV-trace-clean.tr
rm -f sim-scn3-0-AODV-trace-clean.tr

ns sim-scn3-1.tcl AODV
gzip -9 -f sim-scn3-1-AODV.nam
rm -f sim-scn3-1-AODV.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn3-1-AODV-trace.tr"
rm -f sim-scn3-1-AODV-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn3-1-AODV-trace-clean.tr"
cd plot
gnuplot < sim-scn3-1-AODV-over.gnu
gnuplot < sim-scn3-1-AODV-total.gnu
gnuplot < sim-scn3-1-AODV-delivery.gnu
gnuplot < sim-scn3-1-AODV-average.gnu
gnuplot < sim-scn3-1-AODV-total-geral.gnu
cd ..
gzip -9 -f sim-scn3-1-AODV-trace-clean.tr
rm -f sim-scn3-1-AODV-trace-clean.tr

ns sim-scn3-2.tcl AODV
gzip -9 -f sim-scn3-2-AODV.nam
rm -f sim-scn3-2-AODV.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn3-2-AODV-trace.tr"
rm -f sim-scn3-2-AODV-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn3-2-AODV-trace-clean.tr"
cd plot
gnuplot < sim-scn3-2-AODV-over.gnu
gnuplot < sim-scn3-2-AODV-total.gnu
gnuplot < sim-scn3-2-AODV-delivery.gnu
gnuplot < sim-scn3-2-AODV-average.gnu
gnuplot < sim-scn3-2-AODV-total-geral.gnu
cd ..
gzip -9 -f sim-scn3-2-AODV-trace-clean.tr
rm -f sim-scn3-2-AODV-trace-clean.tr

ns sim-scn3-3.tcl AODV
gzip -9 -f sim-scn3-3-AODV.nam
rm -f sim-scn3-3-AODV.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn3-3-AODV-trace.tr"
rm -f sim-scn3-3-AODV-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn3-3-AODV-trace-clean.tr"
cd plot
gnuplot < sim-scn3-3-AODV-over.gnu
gnuplot < sim-scn3-3-AODV-total.gnu
gnuplot < sim-scn3-3-AODV-delivery.gnu
gnuplot < sim-scn3-3-AODV-average.gnu
gnuplot < sim-scn3-3-AODV-total-geral.gnu
cd ..
gzip -9 -f sim-scn3-3-AODV-trace-clean.tr
rm -f sim-scn3-3-AODV-trace-clean.tr

ns sim-scn3-4.tcl AODV
gzip -9 -f sim-scn3-4-AODV.nam
rm -f sim-scn3-4-AODV.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn3-4-AODV-trace.tr"
rm -f sim-scn3-4-AODV-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn3-4-AODV-trace-clean.tr"
cd plot
gnuplot < sim-scn3-4-AODV-over.gnu
gnuplot < sim-scn3-4-AODV-total.gnu
gnuplot < sim-scn3-4-AODV-delivery.gnu
gnuplot < sim-scn3-4-AODV-average.gnu
gnuplot < sim-scn3-4-AODV-total-geral.gnu
cd ..
gzip -9 -f sim-scn3-4-AODV-trace-clean.tr
rm -f sim-scn3-4-AODV-trace-clean.tr

ns sim-scn3-5.tcl AODV
gzip -9 -f sim-scn3-5-AODV.nam
rm -f sim-scn3-5-AODV.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn3-5-AODV-trace.tr"
rm -f sim-scn3-5-AODV-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn3-5-AODV-trace-clean.tr"
cd plot
gnuplot < sim-scn3-5-AODV-over.gnu
gnuplot < sim-scn3-5-AODV-total.gnu
gnuplot < sim-scn3-5-AODV-delivery.gnu
gnuplot < sim-scn3-5-AODV-average.gnu
gnuplot < sim-scn3-5-AODV-total-geral.gnu
cd ..
gzip -9 -f sim-scn3-5-AODV-trace-clean.tr
rm -f sim-scn3-5-AODV-trace-clean.tr

ns sim-scn3-6.tcl AODV
gzip -9 -f sim-scn3-6-AODV.nam
rm -f sim-scn3-6-AODV.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn3-6-AODV-trace.tr"
rm -f sim-scn3-6-AODV-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn3-6-AODV-trace-clean.tr"
cd plot
gnuplot < sim-scn3-6-AODV-over.gnu
gnuplot < sim-scn3-6-AODV-total.gnu
gnuplot < sim-scn3-6-AODV-delivery.gnu
gnuplot < sim-scn3-6-AODV-average.gnu
gnuplot < sim-scn3-6-AODV-total-geral.gnu
cd ..
gzip -9 -f sim-scn3-6-AODV-trace-clean.tr
rm -f sim-scn3-6-AODV-trace-clean.tr

ns sim-scn3-7.tcl AODV
gzip -9 -f sim-scn3-7-AODV.nam
rm -f sim-scn3-7-AODV.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn3-7-AODV-trace.tr"
rm -f sim-scn3-7-AODV-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn3-7-AODV-trace-clean.tr"
cd plot
gnuplot < sim-scn3-7-AODV-over.gnu
gnuplot < sim-scn3-7-AODV-total.gnu
gnuplot < sim-scn3-7-AODV-delivery.gnu
gnuplot < sim-scn3-7-AODV-average.gnu
gnuplot < sim-scn3-7-AODV-total-geral.gnu
cd ..
gzip -9 -f sim-scn3-7-AODV-trace-clean.tr
rm -f sim-scn3-7-AODV-trace-clean.tr

ns sim-scn3-8.tcl AODV
gzip -9 -f sim-scn3-8-AODV.nam
rm -f sim-scn3-8-AODV.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn3-8-AODV-trace.tr"
rm -f sim-scn3-8-AODV-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn3-8-AODV-trace-clean.tr"
cd plot
gnuplot < sim-scn3-8-AODV-over.gnu
gnuplot < sim-scn3-8-AODV-total.gnu
gnuplot < sim-scn3-8-AODV-delivery.gnu
gnuplot < sim-scn3-8-AODV-average.gnu
gnuplot < sim-scn3-8-AODV-total-geral.gnu
cd ..
gzip -9 -f sim-scn3-8-AODV-trace-clean.tr
rm -f sim-scn3-8-AODV-trace-clean.tr

ns sim-scn3-9.tcl AODV
gzip -9 -f sim-scn3-9-AODV.nam
rm -f sim-scn3-9-AODV.nam
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.CleanTCL "sim-scn3-9-AODV-trace.tr"
rm -f sim-scn3-9-AODV-trace.tr
java -classpath "../libs/anthocnet-tcl-1.0.jar:../libs/commons-io-2.1.jar" net.sf.anthocnet.FindResultTCL "sim-scn3-9-AODV-trace-clean.tr"
cd plot
gnuplot < sim-scn3-9-AODV-over.gnu
gnuplot < sim-scn3-9-AODV-total.gnu
gnuplot < sim-scn3-9-AODV-delivery.gnu
gnuplot < sim-scn3-9-AODV-average.gnu
gnuplot < sim-scn3-9-AODV-total-geral.gnu
cd ..
gzip -9 -f sim-scn3-9-AODV-trace-clean.tr
rm -f sim-scn3-9-AODV-trace-clean.tr

