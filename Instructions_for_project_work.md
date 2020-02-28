# Instructions for project work
### DATA
You have been given some reference and target populations. They can be found at:

```
/proj/g2020001/nobackup/HUMAN_POPGEN_PROJECT/IN_DATA
```

You will also find some useful scripts in the `SCRIPTS` folder.

## Your task
Ultimately you need to identify what populations you have in the `Unknown.fam`.

To achieve this you have been given a bunch of references that might be useful for comparison.



## Workflow
Below follows a rough outline of what you need to do

* Check for related individuals in your reference dataset (And filter them away)
* Unify SNP names across you dataset (buy position)
* Filter the reference individuals &  SNPs
* PCA
* ADMIXTURE
* Projected PCA (Procrustes)
* MALDER


## More thorough instructions
In the `SCRIPTS` folder, there is a script called `sbatch_KING.sh` that can be used to run [KING](http://people.virginia.edu/~wc9c/KING/manual.html) have a look inside of it for instructions on how to run the script. Look at the manual and 

The `rename_SNP.py` script can be used on the `.bim` files to change the SNP name into the names based on position.

For filtering, you can have a look at the instructions of the [popgen lab](https://github.com/Hammarn/Populationsgenomik/blob/master/1BG508.md). As well as the other scripts supplied to you. Do note that you should not apply the `maf` filtering until you have your final references dataset! 

Your samples are "different" in a way, a hint is to look at the genotyping rate - i.e. missingness. Part of your first task is to figure out what types of samples you have, and why they are valuable even though they look the way they do. It can also be helpful to look at their names in the data files.
You should not apply the filters to your unknown samples! 
 


Running PCA and ADMIXTURE
You have some instructions from the lab that you did, and in the SCRIPTS folder. Note that before doing this you should prune your data for SNPs in LD.
GO to the admixture manual and search for `prune` and you will find how to do it:
http://software.genetics.ucla.edu/admixture/admixture-manual.pdf

Don't run PCA/ADMIXTURE until you have merged your data!



 I will give you some information and scripts for the projected PCA a bit later.
 


For Malder you can have a look [here](https://github.com/Hammarn/Populationsgenomik/blob/master/1BG512.md#optional-2---malder) or at the [MALDER](https://github.com/joepickrell/malder) or [ALDER](https://github.com/joepickrell/malder/blob/master/MALDER/README.txt) manuals.


Good luck!

Rickard

 

