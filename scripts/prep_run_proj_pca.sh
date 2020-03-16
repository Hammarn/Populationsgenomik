## 1 is the basename of the merged plinkfile
## 2 i number of indivudals in modern reference
## 3 is number of individuals in ancient samples


module load bioinfo-tools
module load plink/1.90b4.9
module load  eigensoft

## Inputs
infile=$1
fbase=$(basename $infile)
mod_popfile=pca_ref.pops
anc_popfile=pca_adna.pops

grep -f $mod_popfile $infile.tfam > $TMPDIR/keep.tmp
grep -f $anc_popfile $infile.tfam >> $TMPDIR/keep.tmp

plink --tfile $infile --keep $TMPDIR/keep.tmp --recode --out $TMPDIR/$fbase.subset

ped_add_pop.py $TMPDIR/$fbase.subset

mv $TMPDIR/$fbase.subset2.ped $TMPDIR/$fbase.subset.ped

### make the parameter file
echo  outliermode: 2 >> $TMPDIR/pca.par
echo altnormstyle:    NO >> $TMPDIR/pca.par
echo familynames:     NO >> $TMPDIR/pca.par
echo grmoutname:      grmjunk >> $TMPDIR/pca.par
echo killr2:    YES >> $TMPDIR/pca.par
echo r2thresh:  0.7 >> $TMPDIR/pca.par
echo genotypename: ${TMPDIR}/${fbase}.subset.ped >> $TMPDIR/pca.par
echo snpname: ${TMPDIR}/${fbase}.subset.map >> $TMPDIR/pca.par
echo indivname: ${TMPDIR}/${fbase}.subset.ped >> $TMPDIR/pca.par
echo evecoutname: ${fbase}.popsubset_withOutliers.evec >> $TMPDIR/pca.par
echo evaloutname: ${fbase}.popsubset_withOutliers.eval >> $TMPDIR/pca.par
echo lsqproject: YES >> $TMPDIR/pca.par
echo poplistname: ${mod_popfile} >> $TMPDIR/pca.par
echo shrinkmode: YES >> $TMPDIR/pca.par


### Run the PCA
module load bionfo-tools
module load eigensoft
smartpca -p $TMPDIR/pca.par > logfile_aDNA_unknown.log
printf 'Modern\n%.0s' {1..${2}} > modern_ancient.txt
printf 'aDNA\n%.0s' {1..${3}} >> modern_ancient.txt
paste SGDP.merged_ancient.popsubset_withOutliers.evec modern_ancient.txt > plot.evec
