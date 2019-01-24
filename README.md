
#Population structure analysis
Before we start here are some basic Unix/Linux commands if you are not used to working in a Unix-style terminal:
#####Moving about:
````
    cd – change directory
    pwd – display the name of your current directory
    ls – list names of files in a directory
````
####File/Directory manipulations:
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


##Exercise 1 - Getting exercise datasets. Reading in bed file and converting to other formats 

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

####Look at first few lines of the newly generated .map (sample info) and .ped (marker and genotype info) files using the more command as demonstrated above

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

You normally also want to merge your dataset with already published ones or with some other data that you have access and you are interested to combine. If you have extra time we recommend you to do the exercise OPTIONAL 2. However, if you don’t, please just read through so you can have a grasp about how and why you do those steps.


