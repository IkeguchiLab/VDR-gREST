#PBS -N jAgo
#PBS -q q0002
#PBS -l select=1

cd $PBS_O_WORKDIR
. /home/g0002/share/gromacs/gromacs-2016.3/bin/GMXRC

export OMP_NUM_THREADS=5

# gmx grompp -f step4.0_minimization.mdp -o step4.0_minimization.tpr -c step3_charmm2gmx.pdb -p topol.top # for agonist/antagonist-MD
# the bolow is for CoA simulations
gmx grompp -f step4.0_minimization.mdp -o step4.0_minimization.tpr -c step3_input.gro -r step3_input.gro -p topol.top -maxwarn 1

aprun -n 8 -d 5 -N 8 -S 4 -j 1 -cc depth gmx_mpi mdrun -v -deffnm step4.0_minimization
