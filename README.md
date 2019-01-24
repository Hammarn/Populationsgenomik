
# Population structure analysis
Before we start here are some basic Unix/Linux commands if you are not used to working in a Unix-style terminal:
### Moving about:
````
    cd – change directory
    pwd – display the name of your current directory
    ls – list names of files in a directory
````
### File/Directory manipulations:
```
    cp – copy a file
    mv – move or rename files or directories
    mkdir – make a directory
    rm – remove files or directories
    rmdir – remove a directory
```
Display file content:
```
	cat - concatenate file contents to the screen or to a file
	less - open file for viewing
```	
	    
  


Setup
Navigate to the directory you want to work in.

cd path (change directory)
mkdir directory_name (create new directory)

cd /proj/g2018001/nobackup/private #Uppmax project for this course
mkdir PopGen18_YOURNAME


## Exercise 1 - Getting exercise datasets. Reading in bed file and converting to other formats 

Copy the datasets from the directory “Data” to your working folder by pasting in the following commands in the command line, while you are in your working folder:
```
cp /path_to_course_material/unk1.bed .
cp /path_to_course_material/unk1.bim .
cp /path_to_course_material/unk1.fam .
```

These files contain SNPs from 4 unknown population groups in bed file format. You are going to figure out the ancestry of these population groups during this practical. 
To speed thing up for you we are only working with chromosome 20-22.

Look at the `.bim` (markers) and `.fam` (sample info) files by typing:
```
less unk1.bim
``` 

do the same for the `.fam` file
```
less unk1.fam 
```
As mentioned before the `.bim` file store the variant markers present in the data and `.fam` lists the samples. (you can try to look at the .bed as well, but this file is in binary format and cannot be visualized as text, if you want to see the specific genotype info you must export the bed format to a ped format)

Read in a  bed file dataset and convert to ped format by typing/pasting in:
```
plink --bfile unk1 --recode --out unk1_ped 
```
#### Look at the info that plink prints to the screen. How many SNPs in the data? How many individuals? How much missing data?

#### Look at first few lines of the newly generated .map (sample info) and .ped (marker and genotype info) files using the more command as demonstrated above

Read in bed/ped file and convert to tped
```
plink --bfile unk1 --recode transpose --out unk1_tped 
plink --file unk1_ped --recode transpose --out unk1_tped 
```
Do  you see the difference in the two commands above for reading from a bed (--bfile) and reading from a ped (--file) file. Which one take longer to read-in?

Look at first few lines of the  `.tfam` and `.tped` files by using the `less` command

Can you see what symbol is used to encode missing data?

Note- try to always work with bed files, they are much smaller and takes less time to read in. 

Plink can convert to other file formats as well, look in the manual for the different types of conversions

## Exercise 2 - Data filtering. Missingness, HWE and MAF
Now we will start to clean our data before further analysis

Look at the missingness information of each individual and snp by typing:
```
plink  --bfile unk1 --missing --out test1miss
```
Look at the two generated files by using the more command
```
more test1miss.imiss
more test1miss.lmiss
```

The `.imiss` contains the individual missingness and the `.lmiss` the marker missingness
Do you understand the columns of the files? the last three columns are the number of missing, the total and the fraction of missing markers and individuals for the two files respectively

We will start our filtering process with filtering for missing data
First we filter for marker missingness, we have 1000’s of markers but only 80 individuals, so we want to try to save filtering out unnecessary individuals

Paste in the command below to filter out markers with more than 10% missing data
```
plink --bfile unk1 --geno 0.1 --make-bed --out unk2 
```
Look at the screen output, how many SNPs were excluded?

Now we will filter for individual missingness.
Paste in the command below to filter out individuals with more than 15% missing data
```
plink --bfile unk2 --mind 0.15 --make-bed --out unk3 
```
Look at the screen output, how many individuals were excluded?

To filter for minimum allele frequency is not always optimal, especially if you are going to merge your data with other datasets in which the alleles might be present. But we will apply a MAF filter in this case

Filter data for a minimum allele frequency of 1% by pasting in:
```
plink --bfile unk3 --maf 0.01 --make-bed --out unk4 
```
How many SNPs are left?

Now we will filter for SNPs out of Hardy-Weinberg equilibrium. Most likely, SNPs out of HWE usually indicates problems with the genotyping. However, to avoid filtering out SNPs that are selected for/against in certain groups (especially when working with case/control data) filtering HWE per group is recommended. After, only exclude the common SNPs that falls out of the HWE in the different groups - Exercise OPTIONAL 1. 

For reasons of time we will now just filter the entire dataset for SNPs that aren’t in HWE with a significance value of 0.001
```
plink --bfile unk4 --hwe 0.001 --make-bed --out unk5
```

Look at the screen. How many SNPs were excluded?

If you only what to look at the HWE stats you can do as follows. By doing this command you can also obtain the observed and expected heterozygosities. 
```
plink --bfile unk5 --hardy --out hardy_unk5
```
Look at file hardy_unk5.hwe, see if you understand the output?

There are additional filtering steps that that you can go further. PLINK site on the side lists all the cool commands that you can use to treat your data. Usually we also filter for related individuals and do a sex-check on the X-chromosome to check for sample mix-ups. 

You normally also want to merge your dataset with already published ones or with some other data that you have access and you are interested to combine. If you have extra time we recommend you to do the exercise *OPTIONAL 2*. However, if you don’t, please just read through so you can have a grasp about how and why you do those steps.



=============================================================================

###  OPTIONAL 1: If you have time plot heterozygosities per population in R and look at the different heterozygosities in the different populations.

Compare the expected heterozygosities of the four populations:
Do HWE for Unknown populations 1 -4 
```
#getting 4 different groups from the fam files 
grep 'Unknown1 ' unk4.fam >list1 
grep 'Unknown3 ' unk4.fam >list2 
grep 'Unknown5 ' unk4.fam >list3 
grep 'Unknown11 ' unk4.fam >list4 
#extracting the groups from the bed files using the above generated lists 
plink --bfile unk4 --keep list1 --make-bed --out unk4_1 
plink --bfile unk4 --keep list2 --make-bed --out unk4_2 
plink --bfile unk4 --keep list3 --make-bed --out unk4_3 
plink --bfile unk4 --keep list4 --make-bed --out unk4_4 
#doing hwe filtering at p value <= 0.01 for the different sets of pops 
plink --bfile unk4_1 --hwe 0.01 --make-bed --out unk4_1h 
plink --bfile unk4_2 --hwe 0.01 --make-bed --out unk4_2h 
plink --bfile unk4_3 --hwe 0.01 --make-bed --out unk4_3h 
plink --bfile unk4_4 --hwe 0.01 --make-bed --out unk4_4h
```

##### To prepare your files for R just paste this in:
``
plink --bfile unk4_1h --hardy --out hardy_unk4_1h 
grep 'ALL' hardy_unk4_1h.hwe | sed 's/ALL/POP1/g' >hzt
plink --bfile unk4_2h --hardy --out hardy_unk4_2h 
grep 'ALL' hardy_unk4_2h.hwe | sed 's/ALL/POP2/g' >>hzt
plink --bfile unk4_3h --hardy --out hardy_unk4_3h 
grep 'ALL' hardy_unk4_3h.hwe | sed 's/ALL/POP3/g' >>hzt
plink --bfile unk4_4h --hardy --out hardy_unk4_4h 
grep 'ALL' hardy_unk4_4h.hwe | sed 's/ALL/POP4/g' >>hzt
```

Now we will plot the heterozygosities of the two populations in R
Open R by typing
```
R
```
Paste in the following script:
```
WD<-getwd()
setwd(WD)
infile1<-"hzt"
outname<-"HeterozygosityPlot1"
data1<-read.table(infile1)
pdf (file=paste(outname,".pdf", sep =""), width =5, height = 5, pointsize =10)
boxplot(data1[,8]~data1[,3], col = "Gold", xlab="Population", ylab="Exp Heterozygosity", main = "Heterozygosity boxplot")
dev.off()
#quit R
quit()
N
```

Look at the produced PDF, do you see a difference in heterozygosity (HeterozygosityPlot1.pdf) in the populations, are they significant?

=============================================================================

OPTIONAL 2 - Data Merging and strand flipping.

The next step would be to start merging your data to comparative datasets. Due to time constraints we are now skipping this step and continuing to exercise 5. You can however, work through this exercise optionally.
Usually when you merge your data with another dataset there are strand issues. The SNPs in the other dataset might be typed on the reverse DNA strand and yours on the forward, or vice versa. Therefore you need to flip the strand to the other orientation for all the SNPs where there is a strand mismatch. One should not flip C/G and A/T SNPs because one cannot distinguish reverse and forward orientation (i.e. C/G becomes G/C unlike other SNPs i.e. G/T which become C/A). Therefore before merging and flipping all A/T and C/G SNPs must be excluded. However this can be a problem since some of your SNPs in your dataset may be monomorphic, when you dont apply the MAF filter. I.E in the bim file they will appear as C 0 (with 0 meaning missing). So you dont know what kind of SNP it is, it can be C G or C T for instance, if it is C G it needs to be filtered out but not if it is C T.

Therefore, before merging our data to other datasets it is important to first merge your data with a fake / reference_individual, that you prepare, which is heterozygous at every SNP position. This “fake” reference individual you can easily prepare from the SNP info file you get from the genotyping company or your own genomics processing software (such as Genome Studio from Illumina). You can also prepare it from data downloaded for each SNP from a web-database such as dbSNP. 

Have you noticed that PLINK sometimes generates a .nof file and in the log file output the following is mentioned
902 SNPs with no founder genotypes observed
Warning, MAF set to 0 for these SNPs (see --nonfounders)
This is the monomorphic SNPs in you data.

So our first step will be merging with a reference that we prepared form SNP info data beforehand:
Copy the RefInd files (bim, bed and fam) from your local data folder to working folder:

Extract your SNPs of interest from the RefInd (remember you filtered out a number of SNPs already)
plink --bfile RefInd1 --extract unk5.bim --make-bed --out RefInd1_ext 

Make a list of CG and AT SNPs in your data:
```
sed 's/\t/ /g' RefInd1_ext.bim | grep " C G" >ATCGlist
sed 's/\t/ /g' RefInd1_ext.bim | grep " G C" >>ATCGlist
sed 's/\t/ /g' RefInd1_ext.bim | grep " A T" >>ATCGlist
sed 's/\t/ /g' RefInd1_ext.bim | grep " T A" >>ATCGlist
```

Exclude the CG and AT SNPs form both your reference ind and data
plink  --bfile RefInd1_ext --exclude ATCGlist --make-bed --out RefInd1_ext2 
plink  --bfile unk5 --exclude ATCGlist --make-bed --out unk6

Merge with RefInd
plink --bfile RefInd1_ext2 --bmerge unk6.bed unk6.bim unk6.fam --make-bed --out MergeRef1  

An error is generated because of the strand mismatches. The generated file MergeRef1.missnp
contains the info on the SNPs where there are mismatches - flip the strand of these SNPs in your data.
plink --bfile unk6 --flip MergeRef1-merge.missnp --make-bed --out  unk7  

Try merging again:
```
plink --bfile RefInd1_ext2 --bmerge unk7.bed unk7.bim unk7.fam --make-bed --out MergeRef2  
```

Now it works.
No .nof file is generated which means none of your SNPs are monomorphic anymore

Now we will merge our data with a set of reference populations that we get from already published study such as HapMap data or HGDP population data. Many of the sites archiving the data provided them in PLINK format as well. For this practical we selected a few Ref pops from HapMap and HGDP to compare your Unknown populations to.

Copy the RefInd files (bim, bed and fam) from your local data folder to working folder:

Look at the .fam file, do you recognise some of these pops? There are two HapMap and three HGDP populations.

First extract the SNPs we have in our data from the downloaded RefPops
```
plink --bfile refpops1 --extract MergeRef2.bim --make-bed --out refpops2  
```

Now we will merge our data with the downloaded data
```
plink --bfile MergeRef2 --bmerge refpops2.bed refpops2.bim refpops2.fam --make-bed --out MergeRefPop1  
```

Another strand issue, flip the strands of the refPop datasets to be merged
```
plink --bfile refpops2 --flip MergeRefPop1-merge.missnp --make-bed --out refpops3  
```

Try merge again:
```
plink --bfile MergeRef2 --bmerge refpops3.bed refpops3.bim refpops3.fam --make-bed --out MergeRefPop2 
```

It works now. Look at your screen output. You will see that the Refpops only contains SNPs that overlap with a small percentage of the SNPs in the UNknown Pops data (~15 000 vs ~95 000). We will now again filter for SNP missingness to exclude all of the extra SNPs in the Unknown Pop data (Retain only the overlap).

```
plink --bfile MergeRefPop2 --geno 0.1 --make-bed --out MergeRefPop2fil 
```

How many SNPs are left for your analyses?

Last thing to do is to extract your fake/Ref_ind from your data.
```
plink --bfile MergeRefPop2fil --remove RefInd1.fam --make-bed --out MergeRefPop3  
```

This is the final files for the next exercise. Rename them:
```
mv MergeRefPop3.bed PopStrucIn1.bed; mv MergeRefPop3.bim PopStrucIn1.bim; mv MergeRefPop3.fam PopStrucIn1.fam 
```

Now you have generated your input files for the next exercise which will deal with population structure analysis. You will look at the population structure of your unknown samples in comparison to the known reference populations from HapMap and HGDP.


=============================================================================

PART 2: Population structure inference 
Using ADMIXTURE/CLUMPP/DISTRUCT and principal component analysis with EIGENSOFT 

In case you didn’t go through OPTIONAL 2, please copy these files into your folder:
```
cp ../Data/PopStrucIn1.bed .
cp ../Data/PopStrucIn1.bim .
cp ../Data/PopStrucIn1.fam .
```



Admixture is a similar tool as structure but runs much quicker especially on large datasets.
Admixture runs directly from .bed or .ped files and need no extra parameter file preparation. You do not specify burnin and repeats, ADMIXTURE exits when it converged on a solution (Delta< minimum value)


A basic ADMIXTURE run looks like this:
admixture -s time PopStrucIn1.bed 2

This command execute the program with a seed set from system clock time, it gives the input file (remember the extension) and the K value at which to run ADMIXTURE (2 in the previous command).

For ADMIXTURE you also need to run many iterations at each K value, thus a cluster computer and some scripting is useful.

Make a script from the code below to run Admixture for K2-6 with 3 iterations at each K value:
```
for i in {2..6};
do                                                                                      
for j in {1..3};                                                                                      
do
admixture -s time PopStrucIn1.bed ${i} 
mv PopStrucIn1.${i}.Q PopStrucIn1.${i}.Q.${j};
mv PopStrucIn1.${i}.P PopStrucIn1.${i}.P.${j};
done
done
```

Look for a while at the screen output. You will see a short burin, followed by the repeats, and the run stop if delta goes below a minimum value. For K=2 this happens quickly, but the higher Ks take longer. If it takes too long for your liking (it probably 	will take around 5-10 min) press ctrlC and copy the output from the folder Data.

Look at the generated output files. What do they contain?

You can quickly look at your admixture output in R by opening R and pasting in the code below. 

```
WD<-getwd()
setwd(WD)

k2_1 <- read.table("PopStrucIn1.2.Q.1")
k2_2 <- read.table("PopStrucIn1.2.Q.2")
k2_3 <- read.table("PopStrucIn1.2.Q.3")
k3_1 <- read.table("PopStrucIn1.3.Q.1")
k3_2 <- read.table("PopStrucIn1.3.Q.2")
k3_3 <- read.table("PopStrucIn1.3.Q.3")
k4_1 <- read.table("PopStrucIn1.4.Q.1")
k4_2 <- read.table("PopStrucIn1.4.Q.2")
k4_3 <- read.table("PopStrucIn1.4.Q.3")
k5_1 <- read.table("PopStrucIn1.5.Q.1")
k5_2 <- read.table("PopStrucIn1.5.Q.2")
k5_3 <- read.table("PopStrucIn1.5.Q.3")
k6_1 <- read.table("PopStrucIn1.6.Q.1")
k6_2 <- read.table("PopStrucIn1.6.Q.2")
k6_3 <- read.table("PopStrucIn1.6.Q.3")

pdf (file ="Admixture_Plot1.pdf", width =25, height = 40, pointsize =10)
par(mfrow=c(15,1))
barplot(t(as.matrix(k2_1)), col=rainbow(2),border=NA)
barplot(t(as.matrix(k2_2)), col=rainbow(2),border=NA)
barplot(t(as.matrix(k2_3)), col=rainbow(2),border=NA)
barplot(t(as.matrix(k3_1)), col=rainbow(3),border=NA)
barplot(t(as.matrix(k3_2)), col=rainbow(3),border=NA)
barplot(t(as.matrix(k3_3)), col=rainbow(3),border=NA)
barplot(t(as.matrix(k4_1)), col=rainbow(4),border=NA)
barplot(t(as.matrix(k4_2)), col=rainbow(4),border=NA)
barplot(t(as.matrix(k4_3)), col=rainbow(4),border=NA)
barplot(t(as.matrix(k5_1)), col=rainbow(5),border=NA)
barplot(t(as.matrix(k5_2)), col=rainbow(5),border=NA)
barplot(t(as.matrix(k5_3)), col=rainbow(5),border=NA)
barplot(t(as.matrix(k6_1)), col=rainbow(6),border=NA)
barplot(t(as.matrix(k6_2)), col=rainbow(6),border=NA)
barplot(t(as.matrix(k6_3)), col=rainbow(6),border=NA)
dev.off()
q()
N

```

This creates the pdf “Admixture_Plot1.pdf”. The bar plots have the individual K cluster asignment for the 3 iterations at K=2-6. The order of individuals is in file “PopStrucIn1.fam”

