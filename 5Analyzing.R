Note: Following is in 'R', Hive and HDFS: This notes analyses the previous results, to make better results.



5.1 Dividing the data into Head and Tail parts:
Using Hive to filter out the records of mahout_input_a_dvs table with booktotalratings >= 25:
$ hive -e "select * from mahout_input_a_dvs where booktotalratings >= 25 order by booktotalratings desc" > mahout_input_a_dvs_head.tsv

$ cat mahout_input_a_dvs_head.tsv | wc -l
321563

$ cat mahout_input_a_dvs_head.tsv | head
127515	0971880107	0	2502	1.0195843325339728	3	0.0
259378	0971880107	0	2502	1.0195843325339728	151	1.7218543046357615
201141	0971880107	0	2502	1.0195843325339728	54	2.8703703703703702
...

Using Hive to filter out the records of mahout_input_a_dvs table with booktotalratings lt 25:
$ hive -e "select * from mahout_input_a_dvs where booktotalratings < 25 order by booktotalratings desc" > mahout_input_a_dvs_tail.tsv

$ cat mahout_input_a_dvs_tail.tsv | wc -l
731669

$ cat mahout_input_a_dvs_tail.tsv | head
170513	0684833778	0	24	2.7916666666666665	291	2.6735395189003435
159044	0060083255	7	24	2.9583333333333335	6	7.0
127200	0446364797	0	24	1.7916666666666667	874	0.7963386727688787
...

321563 + 731669 = 1053232 (total number of lines in mahout_input_a_dvs). 
Load these 2 files (head and tail parts) into R.



5.2 Clustering the Tail:
To enter into R environment: type R on your command prompt and press enter.
$R (enter)

Loading Head part into R:
> mahout_input_a_dvs_head <- read.table("mahout_input_a_dvs_head.tsv", header=FALSE, sep="\t")

To name the columns to the loaded data:
> names(mahout_input_a_dvs_head)<-c("userid", "bookisbn", "rating", "booktotalratings", "bookavgrating", "usertotalratings", "useravgrating")

> head(mahout_input_a_dvs_head)	

Loading Tail part into R:
> mahout_input_a_dvs_tail <- read.table("mahout_input_a_dvs_tail.tsv", header=FALSE, sep="\t")

To name the columns to the loaded data:
> names(mahout_input_a_dvs_tail)<-c("userid", "bookisbn", "rating", "booktotalratings", "bookavgrating", "usertotalratings", "useravgrating")

> head(mahout_input_a_dvs_tail)

To Plot the tail data based on book and its rating:
> plot(mahout_input_a_dvs_tail$bookisbn, mahout_input_a_dvs_tail$rating)

Running KMeans Clustering Algorithm on the Tail part:
> clustering_tail <- kmeans(mahout_input_a_dvs_tail, 5)	

Note: Kmeans is used here for convenience and simplicity. For the actual challenge you need to analyze and see which of the clustering methods give better results.

> print(clustering_tail)
...
[99901] ...
[99937] ...
[99973] ...

Within cluster sum of squares by cluster:
[1] 2.731015e+26 8.785281e+22 4.726557e+26 3.513411e+22 5.092071e+25
 (between_SS / total_SS =  98.9 %)

Available components:
[1] "cluster"      "centers"      "totss"        "withinss"     "tot.withinss"
[6] "betweenss"    "size"        

Plotting the above KMeans result:
> plot(clustering_tail$cluster)	
To understand which cluster does each {userid, bookisbn} combination belongs to:
we are taking userid, bookisbn, clusterNumber into “tail_clusters”:

> tail_clusters <- matrix(c(mahout_input_a_dvs_tail[,1],mahout_input_a_dvs_tail[,2],clustering_tail$cluster),ncol=3) 

> head(tail_clusters)
> tail(tail_clusters)

Plotting the above clusters:
> plot(tail_clusters,col=tail_clusters[,3])


Separating each clustered part:
> tail_cluster1 <- tail_clusters[tail_clusters[,3] == 1,]
> tail_cluster2 <- tail_clusters[tail_clusters[,3] == 2,]
> tail_cluster3 <- tail_clusters[tail_clusters[,3] == 3,]
> tail_cluster4 <- tail_clusters[tail_clusters[,3] == 4,]
> tail_cluster5 <- tail_clusters[tail_clusters[,3] == 5,]
	
> tail(tail_cluster4)
           [,1]      [,2] [,3]
[587102,] 57562 316845469    4
[587103,] 57562 415924995    4
[587104,] 57562 674011864    4

To cross verify the total number of lines:
> length(tail_cluster1[,1])+length(tail_cluster2[,1])+length(tail_cluster3[,1])+length(tail_cluster4[,1])+length(tail_cluster5[,1])
[1] 731669

Checking the individual cluster lengths below: 	
> length(tail_cluster1[,1])
> length(tail_cluster2[,1])
> length(tail_cluster3[,1])
> length(tail_cluster4[,1])
> length(tail_cluster5[,1])

NOTE: It is clearly evident that the clusters are not uniform. So you can do further analysis on Clustering methods (EM Clustering, etc) and also decide on the number of clusters (5, 10, etc) as well. 	

To dump the userids and bookisbns of each cluster SEPARATELY, so to run against Mahout in part 6:
Saving Cluster1’s Column1:
> write.table(tail_cluster1[,1], "cl1_users.tsv", sep="\t", row.names=FALSE)
Saving Cluster1’s Column2:
> write.table(tail_cluster1[,2], "cl1_books.tsv", sep="\t", row.names=FALSE)

> write.table(tail_cluster2[,1], "cl2_users.tsv", sep="\t", row.names=FALSE)
> write.table(tail_cluster2[,2], "cl2_books.tsv", sep="\t", row.names=FALSE)

> write.table(tail_cluster3[,1], "cl3_users.tsv", sep="\t", row.names=FALSE)
> write.table(tail_cluster3[,2], "cl3_books.tsv", sep="\t", row.names=FALSE)
...
Repeat the same for the rest of the clusters.

To dump Head part as well, so to run against Mahout in part 6:
> write.table(mahout_input_a_dvs_head$userid, "head_users.tsv", sep="\t", row.names=FALSE)
> write.table(mahout_input_a_dvs_head$bookisbn, "head_books.tsv", sep="\t", row.names=FALSE)
	
To Quit the R workspace: Type y to save the workspace.
> quit()
Save workspace image? [y/n/c]: y