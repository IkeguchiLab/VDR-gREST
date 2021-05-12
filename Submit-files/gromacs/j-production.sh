#PBS -N jAgo
#PBS -q q0002
#PBS -l select=4

cd $PBS_O_WORKDIR
. /home/g0002/share/gromacs/gromacs-2016.3/bin/GMXRC

export OMP_NUM_THREADS=5

cnt=1
cntmax=10

while [ ${cnt} -le ${cntmax} ]
do
    if [ ${cnt} -eq 1 ]; then
        gmx grompp -f step5_production.mdp -o step5_${cnt}.tpr -c step4.1_equilibration.gro -p topol.top
        aprun -n 32 -d 5 -N 8 -S 4 -j 1 -cc depth gmx_mpi mdrun -v -deffnm step5_${cnt}
    else
        pcnt=`expr ${cnt} - 1`
        gmx convert-tpr -s step5_${pcnt}.tpr -f step5_${pcnt}.trr -e step5_${pcnt}.edr -o step5_${cnt}.tpr -extend 100000
        aprun -n 32 -d 5 -N 8 -S 4 -j 1 -cc depth gmx_mpi mdrun -v -deffnm step5_${cnt}
    fi
    cnt=`expr ${cnt} + 1`
done

