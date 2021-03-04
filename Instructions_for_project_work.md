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
Your unknown samples are "different" in a way, a hint is to look at the genotyping rate - i.e. missingness. Part of your first task is to figure out what types of samples you have, and why they are valuable even though they look the way they do. It can also be helpful to look at their names in the data files.
You should not apply the filters to your unknown samples! 


Below follows a rough outline of what you need to do

* Check for related individuals in your reference dataset (And filter them away)
* Unify SNP names across you dataset (buy position)
* Filter the reference individuals &  SNPs
* PCA
* ADMIXTURE
* Projected PCA 
* Admixture dating


## More thorough instructions

#### Filtering out related individuals
In the `SCRIPTS` folder, there is a script called `sbatch_KING.sh` that can be used to run [KING](http://people.virginia.edu/~wc9c/KING/manual.html) have a look inside of it for instructions on how to run the script. Look at the manual and try and figure out how the software works.
After you have run the script have a look at the produced outputfiles and figure out how to remove the related individuals.

#### Filtering
For filtering, you can have a look at the instructions of the [popgen lab](https://github.com/Hammarn/Populationsgenomik/blob/master/1BG508.md). As well as the other scripts supplied to you. Do note that you should not apply the `maf` filtering until you have your final references dataset! 

```
--mind 0.01
--geno 0.01
--hwe 0.0000001
--maf 0.01
```
Your Unknown samples should not go through any filtering

#### Merging
The `rename_SNP.py` script can be used on the `.bim` files to change the SNP name into the names based on position. This in needed when merging datasets from different chips since the same position can have different namees on different chips.
When merging your reference dataset you want to make sure to only keep overlapping SNPS.

When you have merged together your reference dataset and finished filtering it you can merge it together with your `unkown` data.



#### Running PCA and ADMIXTURE
You have some instructions from the lab that you did, and in the SCRIPTS folder. Note that before doing this you should prune your data for SNPs in LD.
Go to the admixture manual and search for `prune` and you will find out how to carry out the pruning:
http://software.genetics.ucla.edu/admixture/admixture-manual.pdf

After that you can run PCA and Admixture, remember that Admixture takes quite a lot of time.

It's probably a good idea to run PCA on just your reference dataset as well as the final dataset with both the references and the unkown samples.


#### Projected PCA
In `SCRIPTS` there is a script called `prep_run_proj_pca.sh` that can be used to run a projected PCA. 
It will require some tweaking though and you will need a way to plot it. Contact me when are ready to run it! 


#### Admixture dating

For Malder you can have a look [here](https://github.com/Hammarn/Populationsgenomik/blob/master/1BG512.md#optional-2---malder) or at the [MALDER](https://github.com/joepickrell/malder) or [ALDER](https://github.com/joepickrell/malder/blob/master/MALDER/README.txt) manuals.

There might be other tools that might be more useful in your use case, I will get back to you with some other options instead of Malder.


Good luck!

Rickard

 

