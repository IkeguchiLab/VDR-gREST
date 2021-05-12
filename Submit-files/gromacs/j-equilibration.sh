#PBS -N jAgo
#PBS -q q0002
#PBS -l select=4

cd $PBS_O_WORKDIR
. /home/g0002/share/gromacs/gromacs-2016.3/bin/GMXRC

export OMP_NUM_THREADS=5

cnt=1
cntmax=1

while [ ${cnt} -le ${cntmax} ]
do
pcnt=`expr ${cnt} - 1`
    if [ ${cnt} -eq 1 ]; then
      gmx grompp -f step4.${cnt}_equilibration.mdp -o step4.${cnt}_equilibration.tpr -c step4.${pcnt}_minimization.gro -r step3_input.gro -p topol.top
      aprun -n 32 -d 5 -N 8 -S 4 -j 1 -cc depth gmx_mpi mdrun -v -deffnm step4.${cnt}_equilibration
    else
      gmx grompp -f step6.${cnt}_equilibration.mdp -o step6.${cnt}_equilibration.tpr -c step6.${pcnt}_equilibration.gro -r step5_input.gro -p topol.top
      aprun -n 16 -d 5 -N 8 -S 4 -j 1 -cc depth gmx_mpi mdrun -v -deffnm step6.${cnt}_equilibration
    fi
    cnt=`expr ${cnt} + 1`
done
