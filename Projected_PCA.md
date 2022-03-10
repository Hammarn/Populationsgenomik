# Projected PCA
First of all you will need merged plink files wich contains your ancient individuals together with the references.

Secondly you need to create two file. One file with the list of all your reference pops and another with the ancient individuals. It's the information contained in second column of the `.fam` files that you want.

```
cut -f 1 -d " " reference_file.fam | sort -u >  pca_ref.pops
```

do the same for the aDNA ones:

```
cut -f 2 -d " " aDNA_file.fam > pca_adna.pops
```

Now you need to create `.tfam, .tped` files from your`.bed, .fam, .bim` files.

If you need to be refreshed:

```
plink --bfile "your_input" --recode transpose --out "your_output"
```

Once you have that run the [prep\_run\_proj\_pca.sh](scripts/prep_run_proj_pca.sh)

You will need to have the number of indivduals in your modern reference and in your ancient samples as argument 2 and 3

```
prep_run_proj_pca.sh basename_of_your_tfam_files num_modern num_ancient
```

E.g. if you have 100 modern populations and 2 ancient individuals:

```
prep_run_proj_pca.sh my_tfam 100 2
```
Then you can run R (you first need to install ggplot2):

### R plotting
```
R
library(ggplot2)
evec=read.table('plot.evec',skip=1,col.names=c("Ind","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","Pop","ModAnc"))
modern=subset(evec,evec[,ncol(evec)]=='Modern')
ancient=subset(evec,evec[,ncol(evec)]=='aDNA')
ggplot(modern,aes(x=PC1, y=PC2))+geom_text(data=modern,label=modern$Pop,colour='grey80', size=2.8)+theme_bw()+guides(fill=FALSE) + geom_point(data=ancient,aes(x=PC1,y=PC2,colour=Pop,shape=Pop,group=Pop), size=2.5)+scale_shape_manual(values=rep(1:14,3))
``` 


